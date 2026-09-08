import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/repositories/profile_repository.dart';
import '../repositories/firebase_profile_repository.dart';
import '../services/profile_image_compressor.dart';
import '../services/profile_image_picker.dart';
import '../services/profile_photo_storage.dart';
import '../services/user_profile_store.dart';

final firebaseStorageProvider = Provider<FirebaseStorage>(
  (_) => FirebaseStorage.instance,
);

final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (_) => FirebaseFirestore.instance,
);

final profileImagePickerProvider = Provider<ProfileImagePicker>(
  (_) => DeviceProfileImagePicker(),
);

final profileImageCompressorProvider = Provider<ProfileImageCompressor>(
  (_) => const FlutterImageCompressor(),
);

final profilePhotoStorageProvider = Provider<ProfilePhotoStorage>(
  (ref) => FirebaseProfilePhotoStorage(
    storage: ref.watch(firebaseStorageProvider),
  ),
);

final userProfileStoreProvider = Provider<UserProfileStore>(
  (ref) => FirestoreUserProfileStore(
    firestore: ref.watch(firebaseFirestoreProvider),
  ),
);

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return FirebaseProfileRepository(
    picker: ref.watch(profileImagePickerProvider),
    compressor: ref.watch(profileImageCompressorProvider),
    storage: ref.watch(profilePhotoStorageProvider),
    store: ref.watch(userProfileStoreProvider),
    repository: ref.watch(authRepositoryProvider),
  );
});