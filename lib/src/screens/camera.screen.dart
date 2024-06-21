import 'dart:async';
import 'dart:io';

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String cameraInfo;
  final int cameraIndex;
  final Function(File image) onPictureTaken;

  const CameraScreen({
    Key? key,
    required this.title,
    required this.cameras,
    required this.cameraInfo,
    required this.cameraIndex,
    required this.onPictureTaken,
  }) : super(key: key);

  final String title;

  @override
  State<CameraScreen> createState() => _CameraScreen();
}

class _CameraScreen extends State<CameraScreen> {
  int _cameraId = -1;
  int cameraIndex = -1;
  bool _initialized = false;
  bool _previewPaused = false;
  Size? _previewSize;
  StreamSubscription<CameraErrorEvent>? _errorStreamSubscription;
  StreamSubscription<CameraClosingEvent>? _cameraClosingStreamSubscription;
  final MediaSettings _mediaSettings =
      const MediaSettings(resolutionPreset: ResolutionPreset.max);

  double _currentZoomLevel = 1.0;
  double _minZoomLevel = 1.0;
  double _maxZoomLevel = 1.0;

  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    // _initializeCamera();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  void dispose() {
    _disposeCurrentCamera();
    _errorStreamSubscription?.cancel();
    _errorStreamSubscription = null;
    _cameraClosingStreamSubscription?.cancel();
    _cameraClosingStreamSubscription = null;
    super.dispose();
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeCamera(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                top: true,
                child: Center(child: _buildCameraPreview()),
              ),
            );
          }
        });
  }

  Widget _buildCameraPreview() {
    if (_previewPaused) {
      return Stack(children: [
        if (_previewSize != null)
          AspectRatio(
            aspectRatio: _previewSize!.width / _previewSize!.height,
            child: CameraPlatform.instance.buildPreview(_cameraId),
          ),
        Positioned(
          bottom: 30,
          left: 20,
          child: Center(
            child: ElevatedButton(
              onPressed: _togglePreview,
              child: const Text("Cancel"),
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 20,
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                if (_capturedImage != null) {
                  widget.onPictureTaken(File(_capturedImage!.path));
                }
                _disposeCurrentCamera();
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            ),
          ),
        ),
      ]);
    }
    return Stack(
      children: [
        if (_previewSize != null)
          AspectRatio(
            aspectRatio: _previewSize!.width / _previewSize!.height,
            child: CameraPlatform.instance.buildPreview(_cameraId),
          ),
        // camera button
        Positioned(
          bottom: 20,
          right: 20,
          left: 20,
          child: Center(
            child: OutlinedButton(
              onPressed: () async {
                _togglePreview();
                await _takePicture();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.green;
                  } else if (states.contains(MaterialState.hovered)) {
                    return Colors.grey;
                  }
                  return Colors.transparent;
                }),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.only(
                      top: 20, bottom: 20, left: 40, right: 40),
                ),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // switch camera button
        if (widget.cameras.length > 1)
          Positioned(
            bottom: 30,
            right: 20,
            child: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.flip_camera_ios_outlined,
                  color: Colors.white,
                ),
                hoverColor: Colors.grey,
                onPressed: _switchCamera,
              ),
            ),
          ),
        // return button
        Positioned(
          top: 10,
          left: 20,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            ),
            hoverColor: Colors.grey,
            onPressed: () {
              _disposeCurrentCamera();
              Navigator.of(context).pop();
            },
          ),
        ),
        // zoom slider
        Positioned(
          right: 20,
          top: 20,
          child: Center(
            child: Slider(
              value: _currentZoomLevel,
              min: _minZoomLevel,
              max: _maxZoomLevel,
              onChanged: (value) async {
                setState(() {
                  _currentZoomLevel = value;
                });
                await CameraPlatform.instance.setZoomLevel(_cameraId, value);
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Initializes the camera on the device.
  Future<void> _initializeCamera() async {
    assert(!_initialized);

    if (widget.cameras.isEmpty) {
      return;
    }

    int cameraId = -1;
    try {
      cameraIndex = widget.cameraIndex % widget.cameras.length;
      final CameraDescription camera = widget.cameras[cameraIndex];

      cameraId = await CameraPlatform.instance.createCameraWithSettings(
        camera,
        _mediaSettings,
      );

      unawaited(_errorStreamSubscription?.cancel());
      _errorStreamSubscription = CameraPlatform.instance
          .onCameraError(cameraId)
          .listen(_onCameraError);

      unawaited(_cameraClosingStreamSubscription?.cancel());
      _cameraClosingStreamSubscription = CameraPlatform.instance
          .onCameraClosing(cameraId)
          .listen(_onCameraClosing);

      final Future<CameraInitializedEvent> initialized =
          CameraPlatform.instance.onCameraInitialized(cameraId).first;

      await CameraPlatform.instance.initializeCamera(
        cameraId,
      );

      final CameraInitializedEvent event = await initialized;
      _previewSize = Size(
        event.previewWidth,
        event.previewHeight,
      );

      _minZoomLevel = await CameraPlatform.instance.getMinZoomLevel(cameraId);
      _maxZoomLevel = await CameraPlatform.instance.getMaxZoomLevel(cameraId);

      if (mounted) {
        setState(() {
          _initialized = true;
          _cameraId = cameraId;
          _currentZoomLevel = _minZoomLevel;
        });
      }
    } on CameraException {
      try {
        if (cameraId >= 0) {
          await CameraPlatform.instance.dispose(cameraId);
        }
      } on CameraException catch (e) {
        debugPrint('Failed to dispose camera: ${e.code}: ${e.description}');
      }

      if (mounted) {
        setState(() {
          _initialized = false;
          _cameraId = -1;
          _previewSize = null;
        });
      }
    }
  }

  Future<void> _switchCamera() async {
    debugPrint("Switching camera");
    if (widget.cameras.length > 1) {
      // select next index;
      try {
        cameraIndex = (widget.cameraIndex + 1) % widget.cameras.length;
      } on CameraException catch (e) {
        debugPrint("Error disposing camera: $e");
      }
    }
  }

  Future<void> _togglePreview() async {
    if (_initialized && _cameraId >= 0) {
      if (!_previewPaused) {
        await CameraPlatform.instance.pausePreview(_cameraId);
      } else {
        await CameraPlatform.instance.resumePreview(_cameraId);
      }
      if (mounted) {
        setState(() {
          _previewPaused = !_previewPaused;
        });
      }
    }
  }

  Future<void> _takePicture() async {
    // final XFile file = await CameraPlatform.instance.takePicture(_cameraId);
    // _showInSnackBar('Picture captured to: ${file.path}');
    final XFile file = await CameraPlatform.instance.takePicture(_cameraId);
    setState(() {
      _capturedImage = file;
    });
    _showInSnackBar('Picture captured to: ${file.path}');
  }

  void _onCameraError(CameraErrorEvent event) {
    if (mounted) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Error: ${event.description}')));

      _disposeCurrentCamera();
    }
  }

  void _onCameraClosing(CameraClosingEvent event) {
    if (mounted) {
      _showInSnackBar('Camera is closing');
    }
  }

  void _showInSnackBar(String message) {
    _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    ));
  }

  Future<void> _disposeCurrentCamera() async {
    try {
      await CameraPlatform.instance.dispose(_cameraId);

      if (mounted) {
        setState(() {
          _initialized = false;
          _cameraId = -1;
          _previewSize = null;
          _previewPaused = false;
        });
      }
    } on CameraException catch (e) {
      if (mounted) {
        debugPrint("Error disposing camera: $e");
      }
    }
  }
}
