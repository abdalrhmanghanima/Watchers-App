import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:watchers/features/auth/data/mappers/auth_user_mapper.dart';
import 'package:watchers/features/auth/domain/entities/auth_user.dart';

class _MockUser extends Mock implements User {}

void main() {
  const mapper = AuthUserMapper();

  test('maps a null Firebase user to null', () {
    expect(mapper.fromFirebase(null), isNull);
  });

  test('maps a Firebase user to the domain entity', () {
    final user = _MockUser();
    when(() => user.uid).thenReturn('uid-1');
    when(() => user.email).thenReturn('watcher@watchers.app');
    when(() => user.displayName).thenReturn('celestialwatcher');
    when(() => user.photoURL).thenReturn('https://example.com/avatar.jpg');

    final result = mapper.fromFirebase(user);

    expect(result, isA<AuthUser>());
    expect(result!.uid, 'uid-1');
    expect(result.email, 'watcher@watchers.app');
    expect(result.displayName, 'celestialwatcher');
    expect(result.photoUrl, 'https://example.com/avatar.jpg');
  });

  test('keeps optional fields null when the source omits them', () {
    final user = _MockUser();
    when(() => user.uid).thenReturn('uid-2');
    when(() => user.email).thenReturn(null);
    when(() => user.displayName).thenReturn(null);
    when(() => user.photoURL).thenReturn(null);

    final result = mapper.fromFirebase(user);

    expect(result!.uid, 'uid-2');
    expect(result.email, isNull);
    expect(result.displayName, isNull);
    expect(result.photoUrl, isNull);
  });
}