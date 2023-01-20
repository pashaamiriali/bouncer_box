import 'package:bouncer_box/helper/animation_helper.dart';
import 'package:bouncer_box/helper/gesture_helper.dart';
import 'package:bouncer_box/provider/bouncer_provider.dart';
import 'package:bouncer_box/screens/widgets/bouncer_image_box.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.screenSize});

  final Size screenSize;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final bool _showMeasures;
  @override
  void initState() {
    super.initState();
    _showMeasures = kDebugMode;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BouncerProvider>(builder: (context, provider, child) {
      var screenSize = MediaQuery.of(context).size;
      return Stack(
        children: [
          SafeArea(
            child: Scaffold(
              body: SizedBox(
                height: provider.walls.bottom + provider.boxHight,
                width: provider.walls.right + provider.boxWidth,
                child: AnimatedBox(
                  provider: provider,
                ),
              ),
            ),
          ),
          ...buildScreenMeasures(screenSize),
        ],
      );
    });
  }

  List<Widget> buildScreenMeasures(Size screenSize) {
    if (!_showMeasures) return [];
    return [
      ...List.generate((screenSize.height / 50).round(), (index) {
        var height = screenSize.height - (index + 1) * 50;
        return Positioned(
          top: height,
          child: Text(
            height.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
            ),
          ),
        );
      }),
      ...List.generate((screenSize.width / 50).round(), (index) {
        var width = screenSize.width - (index + 1) * 50;
        return Positioned(
          left: width,
          child: Text(
            width.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
            ),
          ),
        );
      }),
    ];
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
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.provider.animationDuration),
        vsync: this);
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
          _controller.duration =
              Duration(milliseconds: widget.provider.animationDuration);
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
            Offset currentPosition = getXYFromAnimationValue(
              widget.provider,
              _animation.value,
            );
            return Transform.translate(
              offset: currentPosition,
              child: BouncerImageBox(
                width: widget.provider.boxWidth,
                height: widget.provider.boxHight,
              ),
            );
          },
        ),
        CustomGestureDetector(
          provider: widget.provider,
          onGesture: () {
            setDistanceToTargetForGesture(widget.provider, _animation.value);
            setState(() {
              _animation =
                  Tween<double>(begin: 0, end: widget.provider.distanceToTarget)
                      .animate(_controller);
              _controller.duration =
                  Duration(milliseconds: widget.provider.animationDuration);
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
