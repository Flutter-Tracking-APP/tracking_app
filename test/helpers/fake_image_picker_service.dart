import 'dart:io';
import 'package:tracking_app/config/di/image_picker_service.dart';

class FakeImagePickerService implements ImagePickerService {
  File? fileToReturn;

  FakeImagePickerService({this.fileToReturn});

  @override
  Future<File?> pickImageFromGallery() async => fileToReturn;

  @override
  Future<File?> pickImageFromCamera() async => fileToReturn;
}
