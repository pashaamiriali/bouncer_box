import 'package:bouncer_box/helper/gesture_helper.dart';
import 'package:bouncer_box/provider/bouncer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.screenSize});

  final Size screenSize;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BouncerProvider>(builder: (context, provider, child) {
      return CustomGestureDetector(
        provider: provider,
        onGesture: () {
          //TODO: handle animation change
        },
        child: SafeArea(
          child: Scaffold(
            body: AnimatedBox(
              provider: provider,
            ),
          ),
        ),
      );
    });
  }
}

class AnimatedBox extends StatefulWidget {
  final BouncerProvider provider;
  const AnimatedBox({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  State<AnimatedBox> createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<AnimatedBox>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _animation = Tween<double>(begin: 0, end: widget.provider.distanceToTarget)
        .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    double x = 0;
    double y = 0;
    if (widget.provider.isTargetBasedOnX) {
      x = widget.provider.currentX + widget.provider.distanceToTarget;
      y = widget.provider.currentY +
          widget.provider.distanceToTarget * widget.provider.slope;
    } else {
      x = widget.provider.currentX +
          widget.provider.distanceToTarget / widget.provider.slope;
      y = widget.provider.currentY + widget.provider.distanceToTarget;
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(x, y),
          child: Container(
            width: widget.provider.boxWidth,
            height: widget.provider.boxWidth,
            color: Colors.red,
          ),
        );
      },
    );
  }
}
