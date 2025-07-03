import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

// ─────────── password‑strength helper ───────────
bool isStrongPassword(String pass) {
  final strong = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{8,}$'); // ≥8, upper, lower, digit, symbol
  return strong.hasMatch(pass);
}

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLogin ? 'Login' : 'Sign up',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    onSaved: (v) => email = v!.trim(),
                    validator: (v) =>
                        v != null && v.contains('@') ? null : 'Enter a valid email',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (v) => pass = v!,
                    validator: (v) {
                      if ((v ?? '').isEmpty) return 'Password required';
                      if (!isLogin && !isStrongPassword(v!)) {
                        return 'Min 8 chars, upper, lower, digit & symbol';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final auth = context.read<AuthCubit>();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(isLogin ? 'Signing in…' : 'Creating account…'),
                          ),
                        );

                        try {
                          isLogin
                              ? await auth.signIn(email, pass)
                              : await auth.signUp(email, pass);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      }
                    },
                    child: Text(isLogin ? 'Login' : 'Create account'),
                  ),
                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin
                          ? 'New here? Create an account'
                          : 'Have an account? Login',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
