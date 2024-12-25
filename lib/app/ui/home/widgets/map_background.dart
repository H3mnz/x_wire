import 'package:flutter/material.dart';

class MapBackground extends StatelessWidget {
  final Widget child;
  const MapBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: -5,
          top: 0,
          bottom: 0,
          child: Image.asset(
            'images/world map.png',
            color: Colors.white,
            colorBlendMode: BlendMode.srcATop,
            opacity: const AlwaysStoppedAnimation(0.1),
          ),
        ),
        Positioned(
          right: -5,
          top: 0,
          bottom: 0,
          child: Transform.flip(
            flipX: true,
            child: Image.asset(
              'images/world map.png',
              color: Colors.white,
              colorBlendMode: BlendMode.srcATop,
              opacity: const AlwaysStoppedAnimation(0.1),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}
