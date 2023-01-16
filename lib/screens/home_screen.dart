import 'dart:async';

import 'package:bouncer_box/helper/animation_helper.dart';
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
      return SafeArea(
        child: Scaffold(
          body: SizedBox(
            height: provider.walls.bottom + provider.boxHight,
            width: provider.walls.right + provider.boxWidth,
            child: AnimatedBox(
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
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    _animation = Tween<double>(begin: 0, end: widget.provider.distanceToTarget)
        .animate(_controller);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Offset currentPosition =
            getXYFromAnimationValue(widget.provider, _animation.value);
        findTheWallReached(widget.provider);

        setState(() {
          _animation =
              Tween<double>(begin: 0, end: widget.provider.distanceToTarget)
                  .animate(_controller);
        });
        widget.provider.setCurrentPosition(currentPosition);
        _controller.reset();
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            print(_animation.value);
            Offset currentPosition = getXYFromAnimationValue(
              widget.provider,
              _animation.value,
            );
            return Transform.translate(
              offset: currentPosition,
              child: Container(
                width: widget.provider.boxWidth,
                height: widget.provider.boxWidth,
                color: Colors.red,
              ),
            );
          },
        ),
        CustomGestureDetector(
          provider: widget.provider,
          onGesture: () {
            setDistanceToTargetForGesture(widget.provider, _animation.value);
            print('distance to target: ${widget.provider.distanceToTarget}');
            print('isTargetBasedOnX: ${widget.provider.isTargetBasedOnX}');
            setState(() {
              _animation =
                  Tween<double>(begin: 0, end: widget.provider.distanceToTarget)
                      .animate(_controller);
            });
            _controller.forward();
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        )
      ],
    );
  }
}
