import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class WaitingForConfirmationWidget extends StatelessWidget {
  final String emailAddress;
  final bool isConfirmed;
  
  const WaitingForConfirmationWidget({super.key, required this.emailAddress, this.isConfirmed = false});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 250, // Set a minimum width for the form
        maxWidth: 250, // And a maximum width
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/images/logo_growing_bigger.svg', width: 100, height: 100),
          const SizedBox(height: 20),
          const Text('Waiting for email confirmation...'),
          const SizedBox(height: 30),
          Text("We've sent a confirmation email to $emailAddress"),
          const SizedBox(height: 20),
          const Text('Click the link in the email to confirm it'),
          const SizedBox(height: 20),
          if (isConfirmed)
            SizedBox(
              width: 100, // Set the width of the Lottie animation
              height: 100, // Set the height of the Lottie animation
              child: Lottie.asset('assets/animations/checkmark.json'),
            ),
          if (!isConfirmed)
            const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15),
                SizedBox(
                  width: 50, // Set the width of the CircularProgressIndicator
                  height: 50, // Set the height of the CircularProgressIndicator
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 15),
              ],
            )
        ],
      ),
    );
  }
}
