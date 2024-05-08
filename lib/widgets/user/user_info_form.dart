import 'package:bortube_frontend/objects/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserInfoForm extends StatefulWidget {
  const UserInfoForm({super.key, required this.user});

  final User user;

  @override
  State<UserInfoForm> createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.user.email;
    _displayNameController.text = widget.user.displayName;

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
              onChanged: (value) {
                widget.user.email = value;
              },
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
              onChanged: (value) {
                widget.user.displayName = value;
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
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            if (_hasChanges)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Save changes logic
                    },
                    child: const Text('Save changes'),
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
