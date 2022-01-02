import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final Function() onPressed;
  final double borderRadius;
  final double height;
  final double width;
  final List<Color> gradientColors;
  const GradientButton({Key? key,
      required this.child, required this.onPressed, required this.borderRadius,
    required this.height, required this.width, required this.gradientColors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
        ),
        child: Ink(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          child: Center(
            child: child,
          ),
          ),
        );
  }
}
