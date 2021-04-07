import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithUserCredential(AuthCredential credential) =>
      _auth.signInWithCredential(credential);

  Future<void> logOut() => _auth.signOut();
  Stream<User> get currentUser => _auth.authStateChanges();
}
