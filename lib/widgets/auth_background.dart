import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {

  final Widget child;
  final List<Color> colors;

  const AuthBackground({Key? key, required this.child, required this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _ColorBox(colors: colors,),

          const _HeaderIcon(),

          child,

        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: const Icon(Icons.person_pin, color: Colors.white, size: 100),
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  final List<Color> colors;
  const _ColorBox({ Key? key, required this.colors }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height*.4,
      child: Stack(
        children: const [
          Positioned(child: _CarrotIcon(), top: 150, right: 40),
          Positioned(child: _CarrotIcon(), top: 80, left: 30),
          Positioned(child: _CarrotIcon(), top: 30, right: 30),
          Positioned(child: _CarrotIcon(), bottom: -30, left: 20),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
        )
      ),
    );
  }
}

class _CarrotIcon extends StatelessWidget {
  const _CarrotIcon({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(
              image: const AssetImage('assets/carrot_icon.png'),
              height: 100,
              width: 100,
              color: Colors.white.withOpacity(0.1),
            ),
    );
  }
}