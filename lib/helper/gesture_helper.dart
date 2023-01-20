import 'dart:math';

import 'package:bouncer_box/helper/bounce_helper.dart';
import 'package:bouncer_box/provider/bouncer_provider.dart';
import 'package:flutter/material.dart';

class CustomGestureDetector extends StatefulWidget {
  const CustomGestureDetector(
      {super.key,
      required this.provider,
      required this.child,
      required this.onGesture});
  final BouncerProvider provider;
  final Widget child;
  final Function onGesture;

  @override
  State<CustomGestureDetector> createState() => _CustomGestureDetectorState();
}

class _CustomGestureDetectorState extends State<CustomGestureDetector> {
  late double initialX;
  late double initialY;
  late double latestX;
  late double latestY;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: ((details) {
          initialX = details.globalPosition.dx;
          initialY = details.globalPosition.dy;
          latestX = details.globalPosition.dx;
          latestY = details.globalPosition.dy;
        }),
        onPanUpdate: (details) {
          latestX = details.globalPosition.dx;
          latestY = details.globalPosition.dy;
          if (details.delta.dx == 0 || details.delta.dy == 0) {
            //cancel drag because of not enough data
            return;
          }
          if (details.delta.dx > 0) {
            if (details.delta.dy > 0) {
              widget.provider.setDragDirection(DragDirection.bottomRight);
            } else {
              widget.provider.setDragDirection(DragDirection.topRight);
            }
          } else {
            if (details.delta.dy > 0) {
              widget.provider.setDragDirection(DragDirection.bottomLeft);
            } else {
              widget.provider.setDragDirection(DragDirection.topLeft);
            }
          }
        },
        onPanEnd: (details) {
          if ((latestX - initialX) == 0 || (latestY - initialY) == 0) {
            //cancel drag because of not enough data
            return;
          }
          double slope =
              getSlopeBasedOnDXDY(latestX - initialX, latestY - initialY);
          widget.provider.setDragSlope(slope);
          double velocity = getGeneralVelocityBasedOnXYSlope(
            details.velocity.pixelsPerSecond.dx,
            details.velocity.pixelsPerSecond.dy,
            widget.provider.slope,
          );
          widget.provider.setDragVelocity(velocity);
          widget.onGesture();
        },
        child: widget.child);
  }
}

double getGeneralVelocityBasedOnXYSlope(double vX, double vY, double slope) {
  vX = vX.abs();
  vY = vY.abs();
  if (slope == 0) {
    return vX;
  } else if (slope == double.nan) {
    return vY;
  } else {
    //TODO: change this to a more accurate speed later
    return max(vX, vY);
  }
}

double getSlopeBasedOnDXDY(double dX, double dY) {
  if (dX == 0 && (dY > 0 || dY < 0)) {
    return double.nan;
  } else if (dY == 0 && (dX > 0 || dX < 0)) {
    return 0;
  } else {
    if (dY > 0 && dX < 0) {
      return (dY / dX) * -1;
    } else if (dY < 0 && dX < 0) {
      return (dY / dX) * -1;
    } else {
      return dY / dX;
    }
  }
}
