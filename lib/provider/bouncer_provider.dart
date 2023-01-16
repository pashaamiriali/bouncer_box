import 'package:bouncer_box/model/wall_model.dart';
import 'package:flutter/cupertino.dart';

class BouncerProvider 
  extends ChangeNotifier {
  late final Walls walls;
  late final double boxWidth;
  late final double boxHight;
  late double slope;
  late bool isTargetBasedOnX;
  late double distanceToTarget;
  late double previousY;
  late double previousX;
  late double currentY;
  late double currentX;
  void _init(
    Walls walls,
    double boxWidth,
    double boxHight,
    slope,
    bool isTargetBasedOnX,
    double distanceToTarget,
    double previousY,
    double previousX,
    double currentY,
    double currentX,
  ) {
    this.walls = walls;
    this.boxWidth = boxWidth;
    this.boxHight = boxHight;
    this.slope = slope;
    this.isTargetBasedOnX = isTargetBasedOnX;
    this.distanceToTarget = distanceToTarget;
    this.previousY = previousY;
    this.previousX = previousX;
    this.currentY = currentY;
    this.currentX = currentX;
  }

  static BouncerProvider init({
    required Walls walls,
    required double boxWidth,
    required double boxHeight,
    required double slope,
    required bool isTargetBasedOnX,
    required double distanceToTarget,
    required double previousY,
    required double previousX,
    required double currentY,
    required double currentX,
  }) {
    var bouncerProvider = BouncerProvider();
    bouncerProvider._init(
      Walls(
        bottom: (walls.bottom - boxHeight).toDouble(),
        top: (walls.top).toDouble(),
        right: (walls.right - boxWidth).toDouble(),
        left: (walls.left)..toDouble(),
      ),
      boxWidth.toDouble(),
      boxHeight.toDouble(),
      slope,
      isTargetBasedOnX,
      distanceToTarget,
      previousY,
      previousX,
      currentY,
      currentX,
    );
    return bouncerProvider;
  }

  void setTargetOnY() {
    isTargetBasedOnX = false;
    notifyListeners();
  }

  void setTargetOnX() {
    isTargetBasedOnX = true;
    notifyListeners();
  }

  void setDistanceToTarget(double distanceToTarget) {
    this.distanceToTarget = distanceToTarget;
    notifyListeners();
  }

  void reverseSlope() {
    slope *= -1;
    notifyListeners();
  }
}
