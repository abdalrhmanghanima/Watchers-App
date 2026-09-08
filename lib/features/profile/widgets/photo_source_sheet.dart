import 'package:flutter/material.dart';

import '../domain/enums/profile_image_source.dart';

Future<ProfileImageSource?> showPhotoSourceSheet(BuildContext context) {
  return showModalBottomSheet<ProfileImageSource>(
    context: context,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Camera'),
            onTap: () => Navigator.of(context).pop(ProfileImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Gallery'),
            onTap: () => Navigator.of(context).pop(ProfileImageSource.gallery),
          ),
        ],
      ),
    ),
  );
}