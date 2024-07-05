import 'dart:async';
import 'dart:io';

import 'package:app/src/screens/camera.screen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoUploadOpt extends StatefulWidget {
  final List<File> images;
  const PhotoUploadOpt({super.key, required this.images});

  @override
  State<StatefulWidget> createState() => _PhotoUploadOptState();
}

class _PhotoUploadOptState extends State<PhotoUploadOpt> {
  final ImagePicker _picker = ImagePicker();
  String _cameraInfo = 'Unknown';
  // int _cameraIndex = 0;
  // List<CameraDescription> _cameras = <CameraDescription>[];

// Pick image from gallery
  Future<void> _pickImage(ImageSource source) async {
    // final pickedFile = await _picker.pickImage(source: source);

    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          widget.images.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _pickMultipleImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      setState(() {
        widget.images.addAll(
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
      });
    } catch (e) {
      debugPrint("Error picking images: $e");
    }
  }

  Future<void> _requestCameraPermission() async {
    String cameraInfo;
    final status = await Permission.camera.request();
    if (status.isGranted) {
      cameraInfo = 'Take a Photo';
    } else {
      cameraInfo = 'No available cameras';
    }

    // List<CameraDescription> cameras = <CameraDescription>[];

    // int cameraIndex = 0;
    // try {
    //   cameras = await CameraPlatform.instance.availableCameras();
    //   if (cameras.isEmpty) {
    //     cameraInfo = 'No available cameras';
    //   } else {
    //     cameraIndex = _cameraIndex % cameras.length;
    //     cameraInfo = 'Take a Photo';
    //     debugPrint("Found camera: ${cameras[cameraIndex].name}");
    //   }
    // } on PlatformException catch (e) {
    //   cameraInfo = 'Failed to get cameras: ${e.code}: ${e.message}';
    // }

    if (mounted) {
      setState(() {
        // _cameraIndex = cameraIndex;
        // _cameras = cameras;
        _cameraInfo = cameraInfo;
      });
    }
  }

// Show picker
  Future<void> _showPicker({bool multiImg = true}) async {
    await _requestCameraPermission();
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  multiImg
                      ? _pickMultipleImages()
                      : _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(_cameraInfo),
                onTap: () {
                  // _openCamera();
                  // _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraScreen(
                            title: 'cam',
                            // cameras: _cameras,
                            // cameraIndex: _cameraIndex,
                            // cameraInfo: _cameraInfo,
                            onPictureTaken: (image) => setState(
                                  () {
                                    widget.images.add(image);
                                  },
                                )),
                      ));
                  // Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

// Delete image
  void _removeImage(int index) {
    setState(() {
      widget.images.removeAt(index);
    });
  }

// Show image
  void _showImage(
      BuildContext context, File image, Function(int)? removeImage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            children: [
              InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4,
                child: Image.file(image),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: IconButton(
                  icon: const Icon(Icons.cancel_sharp, color: Colors.grey),
                  hoverColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: IconButton(
                    icon:
                        const Icon(Icons.delete_outlined, color: Colors.white),
                    hoverColor: Colors.red,
                    onPressed: () {
                      Navigator.of(context).pop();
                      // _removeImage(index);
                      removeImage!(widget.images.indexOf(image));
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return
        // SizedBox(
        // child:
        Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        widget.images.isNotEmpty
            ? Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(widget.images.length, (index) {
                  return MouseRegion(
                    // onEnter: (_) {
                    //   setState(() {
                    //     _hoveredIndex = index;
                    //   });
                    // },
                    // onExit: (_) {
                    //   setState(() {
                    //     _hoveredIndex = null;
                    //   });
                    // },
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showImage(
                                context, widget.images[index], _removeImage);
                          },
                          child: Image.file(
                            widget.images[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // if (_hoveredIndex == index)
                        Positioned(
                          // right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete_outlined,
                              color: Colors.white,
                            ),
                            hoverColor: Colors.red,
                            onPressed: () {
                              _removeImage(index);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              )
            : const Text("No images selected"),
        // const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () {
              _showPicker(multiImg: false);
            },
            child: const Text('Take Photo'),
          ),
        ),
      ],
      // ),
    );
  }
}
