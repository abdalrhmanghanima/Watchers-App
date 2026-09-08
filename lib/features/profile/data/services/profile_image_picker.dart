import 'package:image_picker/image_picker.dart';

import '../../domain/enums/profile_image_source.dart';
import '../../domain/errors/profile_exception.dart';

abstract interface class ProfileImagePicker {
  Future<String> pickImage(ProfileImageSource source);
}

class DeviceProfileImagePicker implements ProfileImagePicker {
  DeviceProfileImagePicker({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<String> pickImage(ProfileImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source == ProfileImageSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
      );
      final path = file?.path;
      if (path == null || path.isEmpty) {
        throw const ProfileException('No image was selected.');
      }
      return path;
    } on ProfileException {
      rethrow;
    } catch (_) {
      throw const ProfileException('Could not open the image picker.');
    }
  }
}