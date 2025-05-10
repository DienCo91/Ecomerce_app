import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:flutter_app/utils/assets_image.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key, this.image, required this.handleSetImage, this.initImage = ''});

  final File? image;
  final Function(File? file) handleSetImage;
  final String? initImage;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    getLostData();
  }

  Future<void> getImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      widget.handleSetImage(File(pickedFile.path));
    }
    print('########## $pickedFile');
  }

  Future<void> getLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) return;

    if (response.files != null && response.files!.isNotEmpty) {
      widget.handleSetImage(File(response.files!.first.path));
    } else {
      debugPrint('Lỗi khi khôi phục ảnh: ${response.exception}');
    }
  }

  void handleCancelImage() {
    widget.handleSetImage(null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: Colors.blue, width: 1.0),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.initImage != null)
                  Image.network(
                    '${ApiConstants.baseUrl}${widget.initImage}',
                    height: 298,
                    errorBuilder: (context, error, stackTrace) {
                      return Image(image: AssetsImages.defaultImage, fit: BoxFit.contain);
                    },
                  )
                else if (widget.image != null)
                  Image.file(widget.image!, height: 298)
                else
                  ElevatedButton(onPressed: getImage, child: Text("Upload Image")),
              ],
            ),
          ),
          widget.image != null || widget.initImage != null
              ? Positioned(
                top: 0,
                right: 8,
                child: IconButton(
                  onPressed: handleCancelImage,
                  icon: Icon(Icons.close, color: Colors.white),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(const Color.fromARGB(122, 0, 0, 0)),
                  ),
                ),
              )
              : SizedBox(),
        ],
      ),
    );
  }
}
