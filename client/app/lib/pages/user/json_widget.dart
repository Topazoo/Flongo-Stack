import 'package:app/theme.dart';
import 'package:app/utils/scroll_behavior.dart';
import 'package:flutter/material.dart';

class UserJSONWidget extends StatefulWidget {
  final Map data;
  final String apiURL;

  const UserJSONWidget({Key? key, required this.data, required this.apiURL}) : super(key: key);

  @override
  _UserJSONWidgetState createState() => _UserJSONWidgetState();
}

class _UserJSONWidgetState extends State<UserJSONWidget> {
  late Map data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: MouseScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildUserNameAndId(),
              _buildCreatedOn(),
              const SizedBox(height: 8),
              const Divider(),
              _buildDetailRow('First Name', data['first_name']),
              const Divider(),
              _buildDetailRow('Last Name', data['last_name']),
              const Divider(),
              _buildDetailRow('Email Address', data['email_address']),
              const Divider(),
              _buildDetailRow('Email Validated', data['is_email_validated'].toString()),
              const Divider(),
              _buildDetailRow('Roles', data['roles'].join(', ')),
              const Divider(),
              const SizedBox(height: 15),
              _buildActionButtons(),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildUserNameAndId() {
    return RichText(
      text: TextSpan(
        text: data['username'],
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        children: [
          TextSpan(
            text: ' (${data['_id']})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatedOn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        "Created On: ${data['createdOn'] ?? ''}",
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

   Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(Icons.edit, 'Edit', Colors.blue),
          _buildButton(Icons.delete, 'Delete', Colors.red),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, Color color) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      onPressed: () {
        // Implement your logic here
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.accentTextColor,
        minimumSize: const Size(200, 65)
      ),
    );
  }
}