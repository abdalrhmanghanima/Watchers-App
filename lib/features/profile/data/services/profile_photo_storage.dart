import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/enums/profile_image_type.dart';
import '../../domain/errors/profile_exception.dart';

abstract interface class ProfilePhotoStorage {
  Future<String> upload(Uint8List bytes, ProfileImageType type, String uid);
}

class FirebaseProfilePhotoStorage implements ProfilePhotoStorage {
  const FirebaseProfilePhotoStorage({required this.storage});

  final FirebaseStorage storage;

  @override
  Future<String> upload(
    Uint8List bytes,
    ProfileImageType type,
    String uid,
  ) async {
    final path = type == ProfileImageType.profilePhoto
        ? 'users/$uid/profile/profile_photo.jpg'
        : 'users/$uid/profile/cover_photo.jpg';
    try {
      final reference = storage.ref(path);
      await reference.putData(
        bytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      return await reference.getDownloadURL();
    } catch (_) {
      throw const ProfileException('Could not upload your image.');
    }
  }
}