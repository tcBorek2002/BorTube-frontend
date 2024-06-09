import 'package:flutter/material.dart';
import 'dart:html' as html;

class CheckBoxFormFieldWithErrorMessage extends FormField<bool> {
  final String labelText;
  final bool isChecked;
  String error;
  final void Function(bool?) onChanged;

  CheckBoxFormFieldWithErrorMessage({
    Key? key,
    required this.labelText,
    required this.isChecked,
    required this.onChanged,
    required FormFieldValidator<bool>? validator,
    required this.error,
  }) : super(
          key: key,
          initialValue: isChecked,
          validator: validator,
          builder: (FormFieldState<bool> state) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: onChanged,
                        isError: true,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              "I have read and agreed with the ",
                            ),
                            new InkWell(
                              child: new Text(
                                "privacy policy.",
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () => {
                                html.window.open(
                                    "https://drive.google.com/file/d/1iYTFf6poxt4_0aBuX3RmvSH3BThqHKmT/view?usp=sharing",
                                    "Privacy Policy")
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      constraints: const BoxConstraints(minHeight: 16.0),
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: Text(
                        (error.isNotEmpty) ? ' * $error' : '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
}
