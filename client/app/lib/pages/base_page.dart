import 'package:app/utilities/http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class BasePage extends StatefulWidget {
  final bool authenticationRequired;

  const BasePage({Key? key, this.authenticationRequired = false}) : super(key: key);
}

abstract class BasePageState<T extends BasePage> extends State<T> {
  static final env = dotenv.env;
  
  @override
  void initState() {
    super.initState();
    if (widget.authenticationRequired && !HTTPClient.isAuthenticated()) {
      // TODO - Logging for unauthenticated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });
    }
  }

  @protected
  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(env['APP_NAME'] ?? 'App Name'),
        actions: [
          IconButton(icon: const Icon(Icons.login), onPressed: () {
            Navigator.of(context).pushNamed('/');
          }),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: buildContent(context)),
          Container(
            color: Colors.grey[200],
            height: 50.0,
            child: const Center(child: Text('Footer Content Here')),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
      ),
    );
  }
}