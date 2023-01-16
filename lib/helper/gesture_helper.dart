import 'package:bouncer_box/helper/bounce_helper.dart';
import 'package:bouncer_box/provider/bouncer_provider.dart';
import 'package:flutter/material.dart';

class CustomGestureDetector extends StatelessWidget {
  const CustomGestureDetector(
      {super.key,
      required this.provider,
      required this.child,
      required this.onGesture});
  final BouncerProvider provider;
  final Widget child;
  final Function onGesture;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            if (details.delta.dy > 0) {
              provider.setDragDirection(DragDirection.bottomRight);
            } else {
              provider.setDragDirection(DragDirection.topRight);
            }
          } else {
            if (details.delta.dy > 0) {
              provider.setDragDirection(DragDirection.bottomLeft);
            } else {
              provider.setDragDirection(DragDirection.topLeft);
            }
          }
          double slope =
              getSlopeBasedOnDXDY(details.delta.dx, details.delta.dy);
          provider.setDragSlope(slope);
        },
        onPanEnd: (details) {
          double velocity = getGeneralVelocityBasedOnXYSlope(
            details.velocity.pixelsPerSecond.dx,
            details.velocity.pixelsPerSecond.dy,
            provider.slope,
          );
          provider.setDragVelocity(velocity);
          onGesture();
        },
        child: child);
  }
}

double getGeneralVelocityBasedOnXYSlope(double vX, double vY, double slope) {
  if (slope == 0) {
    return vX;
  } else if (slope == double.nan) {
    return vY;
  } else {
    //TODO: change this to a more accurate speed later
    return (vX + vY) / 2;
  }
}

double getSlopeBasedOnDXDY(double dX, double dY) {
  if (dX == 0 && (dY > 0 || dY < 0)) {
    return double.nan;
  } else if (dY == 0 && (dX > 0 || dX < 0)) {
    return 0;
  } else {
    return dY / dX;
  }
}
