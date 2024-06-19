import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadOpt extends StatefulWidget {
  const PhotoUploadOpt({super.key});

  @override
  State<PhotoUploadOpt> createState() => _PhotoUploadOptState();
}

class _PhotoUploadOptState extends State<PhotoUploadOpt> {
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  // int? _hoveredIndex;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _pickMultipleImages() async {
    final pickedFiles = await _picker.pickMultiImage();

    setState(() {
      _images.addAll(
          pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
    });
  }

  void _showPicker(BuildContext context, {bool multiImg = true}) {
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
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

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
                      removeImage!(_images.indexOf(image));
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
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _images.isNotEmpty
              ? Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(_images.length, (index) {
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
                              _showImage(context, _images[index], _removeImage);
                            },
                            child: Image.file(
                              _images[index],
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _showPicker(context);
            },
            child: const Text('Upload Photo'),
          ),
        ],
      ),
    );
  }
}
