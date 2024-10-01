import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BasePage extends StatelessWidget {
  const BasePage(
      {super.key,
      required this.child,
      this.floatingButton = const SizedBox(),
      this.floatingLocation = FloatingActionButtonLocation.centerFloat});
  final Widget child;
  final Widget floatingButton;
  final FloatingActionButtonLocation floatingLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: floatingButton,
        floatingActionButtonLocation: floatingLocation,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    'assets/citybg.png',
                    fit: BoxFit.cover,
                    height: 150, // Adjust the height as needed
                  ),
                ),
              ),
              SingleChildScrollView(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.97,
                      width: MediaQuery.of(context).size.width,
                      child: child)),
            ],
          ),
        ));
  }
}
