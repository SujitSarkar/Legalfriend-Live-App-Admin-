import 'package:flutter/material.dart';

class LiveAppBar extends StatelessWidget {
  const LiveAppBar({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.width * .12,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: size.width*.06),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(size.width*.03)),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xffCB081B),
            Color(0xff9B0C17),
          ],
        ),
      ),
      child: child,
    );
  }
}
