import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthStatus { unknown, unauthenticated, authenticated }

class AuthCubit extends Cubit<AuthStatus> {
  AuthCubit() : super(AuthStatus.unknown) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      emit(user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated);
    });
  }

  Future<void> signUp(String email, String pass) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
  }

  Future<void> signIn(String email, String pass) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
  }

  Future<void> signOut() => FirebaseAuth.instance.signOut();
}
