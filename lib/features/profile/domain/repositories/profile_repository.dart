import '../../../auth/domain/entities/auth_user.dart';
import '../entities/user_profile.dart';
import '../enums/profile_image_source.dart';

abstract interface class ProfileRepository {
  Future<UserProfile> loadProfile(AuthUser user);

  Future<UserProfile> updateDisplayName(UserProfile profile, String name);

  Future<UserProfile> updateProfilePhoto(
    UserProfile profile,
    ProfileImageSource source,
  );

  Future<UserProfile> updateCoverPhoto(
    UserProfile profile,
    ProfileImageSource source,
  );
}