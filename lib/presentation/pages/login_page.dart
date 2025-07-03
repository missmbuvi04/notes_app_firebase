import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';




class LoginPage extends StatefulWidget { const LoginPage({super.key}); @override _LoginPageState createState() => _LoginPageState(); }

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  String email = '', pass = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(isLogin ? 'Login' : 'Sign up', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  onSaved: (v) => email = v!.trim(),
                  validator: (v) => v!.contains('@') ? null : 'Bad email',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (v) => pass = v!,
                  validator: (v) => v!.length < 6 ? 'Min 6 chars' : null,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final auth = context.read<AuthCubit>();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isLogin ? 'Signing in…' : 'Signing up…')),
                      );
                      try {
                        isLogin ? await auth.signIn(email, pass) : await auth.signUp(email, pass);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: Text(isLogin ? 'Login' : 'Create account'),
                ),
                TextButton(
                  onPressed: () => setState(() => isLogin = !isLogin),
                  child: Text(isLogin ? 'New? Create one' : 'I already have an account'),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
