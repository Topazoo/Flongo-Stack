import 'package:flutter/material.dart';

class KeyToLockOpenPageRoute {
static Widget Function(BuildContext, Animation<double>, Animation<double>, Widget) transitionsBuilder = (context, animation, secondaryAnimation, child) =>
  AnimatedBuilder(
    animation: animation,
    builder: (context, _) {
      if (animation.isCompleted) {
        // Once the animation is completed, just return the child (i.e., the page)
        return child;
      }

      double backgroundOpacity;
      double padlockOpacity;

      // Calculate the opacity for background and padlock image
      if (animation.value <= 0.7) {
        backgroundOpacity = animation.value * 0.7; // Fade to dark
        padlockOpacity = animation.value * 2.0; // Fade in the padlock
      } else {
        backgroundOpacity = (1.0 - animation.value) * 0.7; // Fade back to light
        padlockOpacity = (1.0 - animation.value) * 2.0; // Fade out the padlock
      }

      return Stack(
        children: [
          FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.2, 1.0),
              ),
            ),
            child: child,
          ),
          Positioned.fill(
            child: Opacity(
              opacity: animation.value.clamp(0.0, 1.0),
              child: Container(
                color: Colors.black.withOpacity(backgroundOpacity),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Padlock Image with fade in and fade out effect
                      Opacity(
                        opacity: padlockOpacity.clamp(0.0, 1.0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: animation.value > 0.25
                              ? Image.asset(
                                  'assets/padlock_open.png',
                                  width: 300,
                                  height: 300,
                                )
                              : Image.asset(
                                  'assets/padlock_closed.png',
                                  width: 300,
                                  height: 300,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}