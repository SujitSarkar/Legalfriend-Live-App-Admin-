import 'package:flutter/material.dart';

class BottomTile extends StatefulWidget {
  const BottomTile({Key? key}) : super(key: key);

  @override
  _BottomTileState createState() => _BottomTileState();
}
class _BottomTileState extends State<BottomTile> with SingleTickerProviderStateMixin{
  AnimationController? _animationController;
  Animation<double>? animation;
  CurvedAnimation? curve;

  @override
  void dispose() {
    super.dispose();
    _animationController!.dispose();
    curve!.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500), //center button animation duration
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController!,
      curve: const Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve!);
    Future.delayed(
      const Duration(seconds: 1),
          () => _animationController!.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ScaleTransition(
      scale: animation!,
      child: GestureDetector(
        onTap: () {
          _animationController!.reset();
          _animationController!.forward();
        },
        child: SizedBox(
          width: size.width,
          height: size.width * .11,
          //color: Colors.red,
          child: Image.asset('assets/logo/splash_image.png'),
        ),
      ),
    );
  }
}
