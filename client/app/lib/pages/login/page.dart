import 'package:app/pages/api_page.dart';
import 'package:app/styles/theme.dart';
import 'package:app/utilities/http_client.dart';
import 'package:app/utilities/transitions/key_lock_transition.dart';
import 'package:flutter/material.dart';

class LoginPage extends API_Page {
  @override
  final String apiURL = '/authenticate';

  final Widget homeWidget;

  const LoginPage({super.key, required this.homeWidget});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends API_PageState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  void _onLoginSuccess() {
    Navigator.pushReplacement(
      context,
      KeyToLockPageRoute(page: widget.homeWidget),
    );
  }

  @override
  Widget getPageWidget(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_errorMessage != null) ...[
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16.0),
              ],
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) => value!.isEmpty ? 'Username required' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Password required' : null,
              ),
              const SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    HTTPClient('/authenticate').login(
                      _usernameController.text,
                      _passwordController.text,
                      (response) => _onLoginSuccess(),
                      (response) => setState(() {
                        _errorMessage = 'Failed to authenticate: ${response.body}';
                      })
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentTextColor,
                  minimumSize: const Size(200, 65)
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
  }
}
