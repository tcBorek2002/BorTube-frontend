import 'package:bortube_frontend/objects/user.dart';
import 'package:bortube_frontend/screens/login_screen.dart';
import 'package:bortube_frontend/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  Future<void> updateUser() async {
    if (_formKey.currentState!.validate()) {
      String? password = _passwordController.text;
      if (password.isEmpty) {
        password = null;
      }
      bool success = await updateUserBackend(widget.user!.id,
          _emailController.text, password, _displayNameController.text);
      if (success) {
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
    if (_formKey.currentState!.validate()) {
      // Save changes logic
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
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Form(
        key: _formKey,
        child: Column(
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
              autofillHints: [AutofillHints.password],
              decoration: const InputDecoration(
                icon: Icon(Icons.key_rounded),
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              validator: widget.shouldCreate
                  ? (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    }
                  : null,
              obscureText: true,
            ),
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
