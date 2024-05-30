import 'package:bortube_frontend/objects/user.dart';
import 'package:bortube_frontend/screens/login_screen.dart';
import 'package:bortube_frontend/screens/register_screen.dart';
import 'package:bortube_frontend/services/user_service.dart';
import 'package:bortube_frontend/widgets/user/check_box_form_field_with_error_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoForm extends StatefulWidget {
  const UserInfoForm(
      {super.key, required this.user, required this.shouldCreate});

  final User? user;
  final bool shouldCreate;

  @override
  State<UserInfoForm> createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _hasChanges = false;
  bool _agree = false;
  String _agreeError = '';

  Future<void> updateUser() async {
    if (_formKey.currentState!.validate()) {
      String? password = _passwordController.text;
      if (password.isEmpty) {
        password = null;
      }
      bool success = await updateUserBackend(widget.user!.id,
          _emailController.text, password, _displayNameController.text);
      if (success) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String currentId = prefs.getStringList("loggedInUser")![0];
        prefs.setStringList("loggedInUser",
            [currentId, _emailController.text, _displayNameController.text]);

        // Access the UserProvider and update the user data
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.loadUserFromSharedPreferences();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User updated successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _hasChanges = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error while updating user. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> createUser() async {
    if (_formKey.currentState!.validate() && _agree) {
      // Save changes logic
      bool success = await createUserBackend(_emailController.text,
          _passwordController.text, _displayNameController.text);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created! You can now log in.'),
            backgroundColor: Colors.green,
          ),
        );

        context.go('/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error while registering. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _emailController.text = widget.user!.email;
      _displayNameController.text = widget.user!.displayName;
    }

    if (widget.shouldCreate) {
      setState(() {
        _hasChanges = true;
      });
    }

    _emailController.addListener(() {
      setState(() {
        _hasChanges = true;
      });
    });

    _displayNameController.addListener(() {
      setState(() {
        _hasChanges = true;
      });
    });

    _passwordController.addListener(() {
      setState(() {
        _hasChanges = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              autofillHints: [AutofillHints.email],
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                icon: Icon(Icons.alternate_email_rounded),
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              validator: validateEmail,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              autofillHints: [AutofillHints.name],
              controller: _displayNameController,
              decoration: const InputDecoration(
                icon: Icon(Icons.account_circle_rounded),
                border: OutlineInputBorder(),
                labelText: 'Display Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a display name';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              autofillHints: [
                widget.shouldCreate
                    ? AutofillHints.newPassword
                    : AutofillHints.password
              ],
              decoration: const InputDecoration(
                icon: Icon(Icons.key_rounded),
                border: OutlineInputBorder(),
                labelText: 'Password (at least 8 characters)',
              ),
              validator: widget.shouldCreate
                  ? (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    }
                  : null,
              obscureText: true,
            ),
            widget.shouldCreate
                ? Padding(
                    padding: const EdgeInsets.only(left: 23),
                    child: CheckBoxFormFieldWithErrorMessage(
                        labelText: "I accept",
                        isChecked: _agree,
                        onChanged: (bool? value) {
                          setState(() {
                            _agree = value!;
                            if (_agree) {
                              _agreeError = '';
                            } else {
                              _agreeError = 'You need to agree.';
                            }
                          });
                        },
                        validator: (value) {
                          if (!_agree) {
                            _agreeError = 'You need to agree.';
                          }
                          return null;
                        },
                        error: "You need to agree."),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 16.0),
            if (_hasChanges)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: widget.shouldCreate ? createUser : updateUser,
                    child:
                        Text(widget.shouldCreate ? 'Register' : 'Save changes'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _displayNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
