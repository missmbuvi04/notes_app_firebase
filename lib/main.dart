import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'presentation/cubit/auth_cubit.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/notes_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: MaterialApp(
        title: 'Notes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthCubit, AuthStatus>(
          builder: (_, state) => switch (state) {
            AuthStatus.authenticated => const NotesPage(),
            AuthStatus.unauthenticated => const LoginPage(),
            AuthStatus.unknown => const Scaffold(body: Center(child: CircularProgressIndicator())),
          },
        ),
      ),
    );
  }
}
// This is a simple Flutter application that initializes Firebase and sets up a multi-bloc provider for authentication.
// It uses the `AuthCubit` to manage authentication state and displays either a login page or a notes page based on the authentication status.
// The app is structured to use Material Design with a color scheme based on a seed color.