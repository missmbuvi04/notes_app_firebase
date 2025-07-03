import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';
import '../cubit/auth_cubit.dart';

bool isStrongPassword(String pass) {
  final re = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{8,}$');
  return re.hasMatch(pass);
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = false; // show Sign‑up first
  String email = '', password = '';

  // ─── Form Controllers ───
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _clearFields() {
    emailCtrl.clear();
    passCtrl.clear();
  }

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

                  // ─── Email ───
                  TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    onSaved: (v) => email = v!.trim(),
                    validator: (v) => EmailValidator.validate(v ?? '')
                        ? null
                        : 'Enter a valid email',
                  ),

                  // ─── Password ───
                  TextFormField(
                    controller: passCtrl,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (v) => password = v!,
                    validator: (v) {
                      if ((v ?? '').isEmpty) return 'Password required';
                      if (!isLogin && !isStrongPassword(v!)) {
                        return 'Min 8 chars, upper, lower, digit & symbol';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ─── Submit ───
                  FilledButton(
                    child: Text(isLogin ? 'Login' : 'Create account'),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      _formKey.currentState!.save();

                      final auth = context.read<AuthCubit>();
                      final messenger = ScaffoldMessenger.of(context); // captured before await

                      try {
                        if (isLogin) {
                          await auth.signIn(email, password);
                        } else {
                          await auth.signUp(email, password);
                          await auth.signOut();

                          if (!mounted) return;  // guard async gap
                          setState(() {
                            isLogin = true;
                            _clearFields();
                          });
                          messenger.showSnackBar(
                            const SnackBar(
                                content: Text('Account created — please log in')),
                          );
                          return;
                        }
                      } catch (e) {
                        messenger.showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                  ),

                  // ─── Toggle ───
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                        _clearFields(); // clear fields on toggle
                      });
                    },
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
