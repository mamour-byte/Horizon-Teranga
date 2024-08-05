import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';



class LoadAnimation extends StatelessWidget {
  const LoadAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return   Center(
          child: LoadingAnimationWidget.dotsTriangle(
          size: 100,
            color: Colors.brown,
      ),
    );
  }
}
