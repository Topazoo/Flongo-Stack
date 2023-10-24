import 'package:app/styles/theme.dart';
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
        backgroundColor: Colors.blueGrey[900], // Stylish dark color
        title: Text(
          env['APP_NAME'] ?? 'App Name',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: _buildAppBarActions(context),
      ),
      body: Center(child: buildContent(context)),
      drawer: _buildNavBar(context),
      bottomNavigationBar: _buildFooter(),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    if (HTTPClient.isAuthenticated()) {
      return [
        const CircleAvatar(
          backgroundImage: NetworkImage('URL_TO_USER_IMAGE'),
          radius: 20,
        ),
        const SizedBox(width: 10),
      ];
    }
    return [];
  }

  Widget _buildNavBar(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(HTTPClient.getIdentity() ?? 'Guest'),
            accountEmail: Text(HTTPClient.isAuthenticated() ? "Roles: ${HTTPClient.getRoles()}" : 'Please Login'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(HTTPClient.isAuthenticated() ? 'URL_TO_USER_IMAGE' : 'DEFAULT_IMAGE_URL'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          if (HTTPClient.isAdminAuthenticated()) ...[
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Config'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/config');
              },
            ),
          ],
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              HTTPClient('/authenticate').logout(
                (response) => Navigator.of(context).pushReplacementNamed('/'),
                (response) => {}
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppTheme.accentTextColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '© ${DateTime.now().year} ${env['APP_AUTHOR'] ?? 'Anonymous'}',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          Row(
            children: [
              TextButton(
                child: const Text('Terms of Service', style: TextStyle(color: Colors.white)),
                onPressed: () {},
              ),
              TextButton(
                child: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
