import 'package:bortube_frontend/objects/user.dart';
import 'package:bortube_frontend/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email address';
  }
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  return value!.isNotEmpty && !regex.hasMatch(value)
      ? 'Please enter a valid email address'
      : null;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _loading = false;

  Future<void> submitLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      // Wait one second:
      await Future.delayed(const Duration(seconds: 1));
      String email = emailController.text;
      String password = passwordController.text;
      String userId = await loginUserBackend(email, password).catchError((e) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Error while logging in. Please try again later. Error:'),
            backgroundColor: Colors.red,
          ),
        );
        throw e;
      });
      setState(() {
        _loading = false;
      });
      print("UserId logged in: $userId");
      if (userId == "400") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email or password is incorrect. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      var user = await getUserBackend(userId, context).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error while fetching user data. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        throw error;
      });

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList(
          "loggedInUser", [user.id, user.email, user.displayName]);

      // Access the UserProvider and update the user data
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(user as User?);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Welcome ${user.displayName}, you have been logged in.'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/user/$userId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                              autofocus: true,
                              autofillHints: [AutofillHints.email],
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              onFieldSubmitted: (value) => submitLogin(),
                              decoration: const InputDecoration(
                                icon: Icon(Icons.alternate_email_rounded),
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                              ),
                              validator: validateEmail),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            autofillHints: [AutofillHints.password],
                            controller: passwordController,
                            onFieldSubmitted: (value) => submitLogin(),
                            decoration: const InputDecoration(
                              icon: Icon(Icons.key_rounded),
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                            obscureText: true,
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton.icon(
                            onPressed: _loading ? null : submitLogin,
                            icon: _loading
                                ? Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.all(2.0),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Icon(Icons.login_rounded),
                            label: const Text('Login'),
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              backgroundColor:
                                  Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text('Register new account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
