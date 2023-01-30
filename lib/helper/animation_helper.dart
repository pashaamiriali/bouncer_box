//this turns the duration based on milliseconds instead of seconds
import 'package:bouncer_box/helper/bounce_helper.dart';
import 'package:bouncer_box/provider/bouncer_provider.dart';
import 'package:flutter/animation.dart';

double getAnimationDurationFromVelocityAndDistanceToTarget(
    double velocity, double distanceToTarget) {
  return (distanceToTarget / velocity) * 1000;
}

void setDistanceToTargetForGesture(
    BouncerProvider provider, double animationValue) {
  Offset currentPosition = getXYFromAnimationValue(provider, animationValue);
  provider.setCurrentPosition(currentPosition);
  switch (provider.dragDirection) {
    case DragDirection.topLeft:
      _handleTopLeft(provider);
      break;
    case DragDirection.topRight:
      _handleTopRight(provider);
      break;
    case DragDirection.bottomLeft:
      _handleBottomLeft(provider);
      break;
    case DragDirection.bottomRight:
      _handleBottomRight(provider);
      break;
    case DragDirection.stationary:
      //nothing
      break;
  }
}

Offset getXYFromAnimationValue(
    BouncerProvider provider, double animationValue) {
  double x = 0;
  double y = 0;
  if (provider.isTargetBasedOnX) {
    x = provider.currentX + animationValue;
    y = provider.currentY + animationValue * provider.slope;
  } else {
    x = provider.currentX + animationValue / provider.slope;
    y = provider.currentY + animationValue;
  }
  return Offset(x, y);
}

void findTheWallReached(BouncerProvider provider) {
  double currentX = 0;
  double currentY = 0;
  if (provider.isTargetBasedOnX) {
    currentX = provider.distanceToTarget + provider.currentX;
    currentY = (provider.distanceToTarget * provider.slope) + provider.currentY;
  } else {
    currentX = (provider.distanceToTarget / provider.slope) + provider.currentX;
    currentY = provider.distanceToTarget + provider.currentY;
  }
  provider.setDragVelocity(provider.velocity / 2);
  currentX = double.parse(currentX.toStringAsFixed(maxDigits));
  currentY = double.parse(currentY.toStringAsFixed(maxDigits));
  provider.setCurrentPosition(Offset(currentX, currentY));
  if (currentX == provider.walls.left) {
    leftWallReached(provider);
  } else if (currentX == provider.walls.right) {
    rightWallReached(provider);
  } else if (currentY == provider.walls.top) {
    topWallReached(provider);
  } else if (currentY == provider.walls.bottom) {
    bottomWallReached(provider);
  }
}

int getAnimationDurationBasedOnDistance(
    double velocity, double distanceToTarget) {
  distanceToTarget = _regulateDistanceToTargetForDuration(distanceToTarget);
  velocity = _regulateVelocityForDuration(velocity);

  //distance to target is in pixels
  //velocity is in pixels per second
  //we want milliseconds
  int duration = ((distanceToTarget / velocity) * 1000).toInt();
  //avoiding stack overflow
  if (duration < 100) {
    duration = 100;
  } else if (duration > 20000) {
    duration = 20000;
  }
  return duration;
}

double _regulateVelocityForDuration(double velocity) {
  if (velocity < 0) {
    velocity *= -1;
  } else if (velocity == 0) {
    velocity = 1;
  } else if (velocity == double.nan) {
    velocity = 1;
  }
  return velocity;
}

double _regulateDistanceToTargetForDuration(double distanceToTarget) {
  if (distanceToTarget < 0) {
    distanceToTarget *= -1;
  } else if (distanceToTarget == 0) {
    distanceToTarget = 1;
  } else if (distanceToTarget == double.nan) {
    distanceToTarget = 1;
  }
  return distanceToTarget;
}

void _handleBottomRight(BouncerProvider provider) {
  if (withGoingToOppositeHorizontalWallWillCrossTopWall(
      provider, provider.walls.right)) {
    goToBottomWall(provider);
  } else {
    goToRightWall(provider);
  }
}

void _handleBottomLeft(BouncerProvider provider) {
  provider.reverseSlope();
  if (withGoingToOppositeHorizontalWallWillCrossBottomWall(
      provider, provider.walls.left)) {
    goToBottomWall(provider);
  } else {
    goToLeftWall(provider);
  }
}

void _handleTopRight(BouncerProvider provider) {
  if (withGoingToOppositeHorizontalWallWillCrossTopWall(
      provider, provider.walls.right)) {
    goToTopWall(provider);
  } else {
    goToRightWall(provider);
  }
}

void _handleTopLeft(BouncerProvider provider) {
  if (withGoingToOppositeHorizontalWallWillCrossTopWall(
      provider, provider.walls.left)) {
    goToTopWall(provider);
  } else {
    goToLeftWall(provider);
  }
}
