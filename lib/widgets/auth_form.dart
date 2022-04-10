import 'dart:io';

import 'package:chat_app_demo/widgets/user_image.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function _submitAuthForm;
  final bool _isLoading;
  const AuthForm(
    this._submitAuthForm,
    this._isLoading, {
    Key? key,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = {
    'email': '',
    'username': '',
    'password': '',
  };
  var _isLogin = true;
  File? _pickedImage;
  void _choosenImage(File choosenImage) {
    _pickedImage = choosenImage;
  }

  @override
  void initState() {
    super.initState();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_isLogin && _pickedImage == null) {
      // ignore: deprecated_member_use
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState?.save();

    print(_formData);
    widget._submitAuthForm(_formData, _pickedImage, _isLogin, context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_isLogin)
                        UserImage(
                          choosenImagefn: _choosenImage,
                        ),
                      TextFormField(
                        key: const ValueKey('email'),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null) return null;
                          if (value.isEmpty || !value.contains('@')) {
                            return 'must enter a valid email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value == null) return;
                          _formData['email'] = value.trim();
                        },
                      ),
                      if (!_isLogin)
                        TextFormField(
                          key: const ValueKey('username'),
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                          validator: (value) {
                            if (value == null) return null;
                            if (value.isEmpty) {
                              return 'must not be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value == null) return;
                            _formData['username'] = value.trim();
                          },
                        ),
                      TextFormField(
                        key: const ValueKey('password'),
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null) return null;
                          if (value.length < 6) {
                            return 'must be bigger than 6';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value == null) return;
                          _formData['password'] = value.trim();
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      if (widget._isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      if (!widget._isLoading)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: Text(_isLogin ? 'Login' : 'Signup'),
                          onPressed: () {
                            _onSave();
                          },
                        ),
                      if (!widget._isLoading)
                        TextButton(
                          child: Text(_isLogin
                              ? 'Create new account'
                              : 'Already have an account'),
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                        )
                    ],
                  ),
                ))),
      ),
    );
  }
}
