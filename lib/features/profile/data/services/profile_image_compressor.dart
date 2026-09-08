import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../domain/enums/profile_image_type.dart';
import '../../domain/errors/profile_exception.dart';

abstract interface class ProfileImageCompressor {
  Future<Uint8List> compress(String sourcePath, ProfileImageType type);
}

class FlutterImageCompressor implements ProfileImageCompressor {
  const FlutterImageCompressor();

  @override
  Future<Uint8List> compress(String sourcePath, ProfileImageType type) async {
    final isProfile = type == ProfileImageType.profilePhoto;
    try {
      final bytes = await FlutterImageCompress.compressWithFile(
        sourcePath,
        minWidth: isProfile ? 512 : 1600,
        minHeight: isProfile ? 512 : 0,
        quality: isProfile ? 70 : 80,
        format: CompressFormat.jpeg,
      );
      if (bytes == null) {
        throw const ProfileException('Could not prepare your image.');
      }
      return bytes;
    } catch (_) {
      throw const ProfileException('Could not prepare your image.');
    }
  }
}