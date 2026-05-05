import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final userProfileProvider =
    FutureProvider.family<UserProfile?, String>((ref, uid) async {
  final db = ref.watch(firestoreProvider);
  final doc = await db.collection('users').doc(uid).get();
  if (!doc.exists) return null;
  return UserProfile.fromFirestore(doc.data()!);
});

final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>(AuthController.new);

class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  FirebaseAuth get _auth => ref.read(firebaseAuthProvider);
  FirebaseFirestore get _db => ref.read(firestoreProvider);

  Future<bool> checkUsernameAvailable(String username) async {
    final normalized = username.trim().toLowerCase();
    final doc = await _db.collection('usernames').doc(normalized).get();
    return !doc.exists;
  }

  Future<UserProfile> signUp({
    required String username,
    required String fullName,
    required int age,
    required String email,
    required String password,
    required String preferences,
  }) async {
    final normalizedUsername = username.trim().toLowerCase();

    if (!await checkUsernameAvailable(normalizedUsername)) {
      throw FirebaseAuthException(
        code: 'username-taken',
        message: 'Username is already taken',
      );
    }

    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;

    try {
      await cred.user!.updateDisplayName(fullName);

      final profile = UserProfile(
        uid: uid,
        username: normalizedUsername,
        fullName: fullName,
        age: age,
        email: email,
        preferences: preferences,
      );

      final usernameRef =
          _db.collection('usernames').doc(normalizedUsername);
      final userRef = _db.collection('users').doc(uid);

      await _db.runTransaction((tx) async {
        final claim = await tx.get(usernameRef);
        if (claim.exists) {
          throw FirebaseAuthException(
            code: 'username-taken',
            message: 'Username is already taken',
          );
        }
        tx.set(usernameRef, {
          'uid': uid,
          'createdAt': DateTime.now().toIso8601String(),
        });
        tx.set(userRef, profile.toFirestore());
      });

      await cred.user!.sendEmailVerification();
      await _auth.signOut();
      return profile;
    } catch (e) {
      await cred.user?.delete().catchError((_) {});
      rethrow;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

String authErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account with that email already exists.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'username-taken':
        return error.message ?? 'Username is already taken.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }
  return 'Something went wrong. Please try again.';
}
