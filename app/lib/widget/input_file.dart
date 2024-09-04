// input for an image
// component will be incluuded in a form
// the form will be used to create a new recipe
// file picker will be used to select an image
// the image file must be accessible to the form

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadFileWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final ImageProvider? backgroundImage;
  final IconData? icon;

  const UploadFileWidget({
    super.key,
    this.width,
    this.height,
    this.backgroundImage,
    this.icon,
  });

  @override
  State<UploadFileWidget> createState() => _UploadFileWidgetState();
}

class _UploadFileWidgetState extends State<UploadFileWidget> {
  String? _fileName;
  PlatformFile? _pickedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
        _fileName = _pickedFile?.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 100,
      height: widget.height ?? 100,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(255, 239, 239, 1)),
        borderRadius: BorderRadius.circular(5.0),
        color: const Color.fromRGBO(255, 239, 239, 1),
        image: widget.backgroundImage != null
            ? DecorationImage(
                image: widget.backgroundImage!,
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: IconButton(
        onPressed: _pickFile,
        icon: Icon(widget.icon),
        iconSize: 50,
        color: Colors.black,
        tooltip: _fileName,
      ),
    );
  }
}
