import 'package:app/pages/http_page.dart';
import 'package:app/styles/theme.dart';
import 'package:app/utilities/http_client.dart';
import 'package:flutter/material.dart';

class LoginPage extends HTTP_Page {

  const LoginPage({Key? key, required String apiURL, bool authenticationRequired = false})
      : super(key: key, apiURL:apiURL, authenticationRequired: authenticationRequired);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends HTTP_PageState {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  Widget getPageWidget(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(200.0),
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
                      (response) =>  Navigator.pushReplacementNamed(context, '/home'),
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
