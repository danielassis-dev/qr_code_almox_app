import 'package:flutter/material.dart';

class AnimatedShowFloaingActionButton extends StatelessWidget {
  const AnimatedShowFloaingActionButton({
    super.key,
    required this.duration,
    required this.showButton,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final Duration duration;
  final bool showButton;
  final Text label;
  final Icon icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: duration,
          curve: Curves.easeOut,
          bottom: 0.0,
          right: showButton ? 0.0 : -200.0,
          child: AbsorbPointer(
            absorbing: !showButton,
            child: FloatingActionButton.extended(
              label: label,
              icon: icon,
              onPressed: onPressed,
            ),
          ),
        ),
      ],
    );
  }
}
