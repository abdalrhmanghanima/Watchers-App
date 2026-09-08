import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/errors/profile_exception.dart';

abstract interface class UserProfileStore {
  Future<String?> getCoverUrl(String uid);

  Future<void> setCoverUrl(String uid, String url);
}

class FirestoreUserProfileStore implements UserProfileStore {
  const FirestoreUserProfileStore({required this.firestore});

  final FirebaseFirestore firestore;

  @override
  Future<String?> getCoverUrl(String uid) async {
    try {
      final snapshot = await firestore.collection('users').doc(uid).get();
      return snapshot.data()?['coverUrl'] as String?;
    } catch (_) {
      throw const ProfileException('Could not load your profile.');
    }
  }

  @override
  Future<void> setCoverUrl(String uid, String url) async {
    try {
      await firestore.collection('users').doc(uid).set(
        {'coverUrl': url},
        SetOptions(merge: true),
      );
    } catch (_) {
      throw const ProfileException('Could not save your cover photo.');
    }
  }
}