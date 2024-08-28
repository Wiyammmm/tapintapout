import 'package:flutter/material.dart';

class circleButton extends StatelessWidget {
  const circleButton({super.key, required this.thisIcon});

  final Widget thisIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xffb5e1ee),
          border: Border.all(width: 3, color: Colors.lightBlue),
          borderRadius: BorderRadius.circular(100)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: thisIcon,
      ),
    );
  }
}
