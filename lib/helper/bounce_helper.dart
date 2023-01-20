import 'package:bouncer_box/provider/bouncer_provider.dart';
import 'package:bouncer_box/infrastructure/exceptions.dart';
import 'package:flutter/material.dart';

const int maxDigits = 2;

enum DragDirection { topLeft, topRight, bottomLeft, bottomRight, stationary }

double getY(double x, double slope) {
  return double.parse((x * slope).toStringAsFixed(maxDigits));
}

double getX(double y, double slope) {
  if (y == 0 || slope == 0) {
    throw OperationOnZeroException();
  }
  return double.parse((y / slope).toStringAsFixed(maxDigits));
}

//The initial position is the center of the screen.
Offset getInitialPosition(
  double screenWidth,
  double screenHeight,
  double boxWidth,
  double boxHeight,
) {
  return Offset(
    (screenWidth / 2) - (boxWidth / 2),
    (screenHeight / 2) - (boxHeight / 2),
  );
}

void leftWallReached(BouncerProvider provider) {
  provider.reverseSlope();
  if (goingUp(provider)) {
    if (withGoingToOppositeHorizontalWallWillCrossTopWall(
      provider,
      provider.walls.right,
    )) {
      goToTopWall(provider);
    } else {
      goToRightWall(provider);
    }
  } else if (stayingAtTheSameHeight(provider)) {
    goToRightWall(provider);
  } else {
    //Going down
    if (withGoingToOppositeHorizontalWallWillCrossBottomWall(
      provider,
      provider.walls.right,
    )) {
      goToBottomWall(provider);
    } else {
      // provider.reverseSlope();
      goToRightWall(provider);
    }
  }
}

void rightWallReached(BouncerProvider provider) {
  //reversing the slope so that the negative x still gives us negative y when going up and positive y when going down
  provider.reverseSlope();
  if (goingUp(provider)) {
    if (withGoingToOppositeHorizontalWallWillCrossTopWall(
        provider, provider.walls.left)) {
      goToTopWall(provider);
    } else {
      goToLeftWall(provider);
    }
  } else if (stayingAtTheSameHeight(provider)) {
    goToLeftWall(provider);
  } else {
    //Going down
    if (withGoingToOppositeHorizontalWallWillCrossBottomWall(
      provider,
      provider.walls.left,
    )) {
      goToBottomWall(provider);
    } else {
      goToLeftWall(provider);
    }
  }
}

void topWallReached(BouncerProvider provider) {
  if (goingRight(provider)) {
    provider.reverseSlope();
    if (withGoingToOppositeVerticalWallWillCrossRightWall(
        provider, provider.walls.bottom)) {
      goToRightWall(provider);
    } else {
      goToBottomWall(provider);
    }
  } else if (stayingAtTheSameWidth(provider)) {
    goToBottomWall(provider);
  } else {
    //going left
    provider.reverseSlope();
    if (withGoingToOppositeVerticalWallWillCrossLeftWall(
        provider, provider.walls.bottom)) {
      goToLeftWall(provider);
    } else {
      goToBottomWall(provider);
    }
  }
}

void bottomWallReached(BouncerProvider provider) {
  if (goingRight(provider)) {
    provider.reverseSlope();
    if (withGoingToOppositeVerticalWallWillCrossRightWall(
        provider, provider.walls.top)) {
      goToRightWall(provider);
    } else {
      goToTopWall(provider);
    }
  } else if (stayingAtTheSameWidth(provider)) {
    goToTopWall(provider);
  } else {
    //going left
    provider.reverseSlope();
    if (withGoingToOppositeVerticalWallWillCrossLeftWall(
        provider, provider.walls.top)) {
      goToLeftWall(provider);
    } else {
      goToTopWall(provider);
    }
  }
}

void goToBottomWall(BouncerProvider provider) {

  provider.setTargetOnY();
  provider.setDistanceToTarget(
      getDistanceToTarget(provider.currentY, provider.walls.bottom));
}

void goToTopWall(BouncerProvider provider) {
  provider.setTargetOnY();
  provider.setDistanceToTarget(
      getDistanceToTarget(provider.currentY, provider.walls.top));
}

void goToRightWall(BouncerProvider provider) {
  provider.setTargetOnX();
  provider.setDistanceToTarget(
      getDistanceToTarget(provider.currentX, provider.walls.right));
}

void goToLeftWall(BouncerProvider provider) {

  provider.setTargetOnX();
  provider.setDistanceToTarget(
      getDistanceToTarget(provider.currentX, provider.walls.left));
}

bool goingUp(BouncerProvider provider) {
  //because the y is 0 on the top
  return provider.previousY > provider.currentY;
}

bool goingRight(BouncerProvider provider) {
  return provider.previousX < provider.currentX;
}

bool stayingAtTheSameHeight(BouncerProvider provider) {
  return provider.slope == 0;
}

bool stayingAtTheSameWidth(BouncerProvider provider) {
  return provider.previousX == provider.currentX;
}

bool withGoingToOppositeHorizontalWallWillCrossTopWall(
  BouncerProvider provider,
  double oppositeHorizontalWall,
) {
  double finalHight = getFinalHeightBasedOnHorizontalWall(
    oppositeHorizontalWall,
    provider.currentX,
    provider.slope,
    provider.currentY,
  );
  //"less than" because the higher the object on the screen, the lower the y
  return finalHight < provider.walls.top;
}

bool withGoingToOppositeVerticalWallWillCrossRightWall(
    BouncerProvider provider, double oppositeVerticalWall) {
  double finalWidth = getFinalWidthBasedOnVerticalWall(
    oppositeVerticalWall,
    provider.currentY,
    provider.slope,
    provider.currentX,
  );
  return finalWidth > provider.walls.right;
}

bool withGoingToOppositeVerticalWallWillCrossLeftWall(
    BouncerProvider provider, double oppositeVerticalWall) {
  double finalWidth = getFinalWidthBasedOnVerticalWall(
    oppositeVerticalWall,
    provider.currentY,
    provider.slope,
    provider.currentX,
  );
  return finalWidth < provider.walls.left;
}

bool withGoingToOppositeHorizontalWallWillCrossBottomWall(
  BouncerProvider provider,
  double oppositeHorizontalWall,
) {
  double finalHight = getFinalHeightBasedOnHorizontalWall(
    oppositeHorizontalWall,
    provider.currentX,
    provider.slope,
    provider.currentY,
  );
  //"more than" because the higher the object on the screen, the lower the y
  return finalHight > provider.walls.bottom;
}

double getDistanceToTarget(double currentAxis, double targetWall) {
  return (targetWall - currentAxis);
}

double getFinalHeightBasedOnHorizontalWall(
    double horizontalWall, double currentX, double slope, double currentY) {
  double distanceToHorizontalWall = horizontalWall - currentX;
  double distanceToHightWhenOnHorizontalWall =
      getY(distanceToHorizontalWall, slope);
  double finalHight = currentY + distanceToHightWhenOnHorizontalWall;
  return finalHight;
}

double getFinalWidthBasedOnVerticalWall(
    double verticalWall, double currentY, double slope, double currentX) {
  double distanceToVerticalWall = verticalWall - currentY;
  double distanceToWidthWhenOnVerticalWall =
      getX(distanceToVerticalWall, slope);
  double finalWidth = currentX + distanceToWidthWhenOnVerticalWall;
  return finalWidth;
}

//you should account for the times when the delta x is 0 and the delta is more or
// less than 0 for y;
