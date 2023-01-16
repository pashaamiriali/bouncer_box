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
    currentX == provider.distanceToTarget + provider.currentX;
    currentY = (provider.distanceToTarget * provider.slope) + provider.currentX;
  } else {
    currentX = (provider.distanceToTarget / provider.slope) + provider.currentX;
    currentY == provider.distanceToTarget + provider.currentY;
  }
  currentX = double.parse(currentX.toStringAsFixed(maxDigits));
  currentY = double.parse(currentY.toStringAsFixed(maxDigits));
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

void _handleBottomRight(BouncerProvider provider) {
  if (withGoingToOppositeHorizontalWallWillCrossTopWall(
      provider, provider.walls.right)) {
    goToBottomWall(provider);
  } else {
    goToRightWall(provider);
  }
}

void _handleBottomLeft(BouncerProvider provider) {
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
