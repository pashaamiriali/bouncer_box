import 'package:bouncer_box/provider/bouncer_provider.dart';
import 'package:bouncer_box/infrastructure/exceptions.dart';
import 'package:bouncer_box/model/wall_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bouncer_box/helper/bounce_helper.dart';

void main() {
  group("Get Y", () {
    test('should return the y axis value based on x and slope', () {
      double x1 = 0;
      double x2 = 3;
      double x3 = -4;
      double slope1 = 0;
      double slope2 = -1.6;
      double slope3 = 2.5;
      double y1 = 0;
      double y2 = -4.8;
      double y3 = -10;
      expect(getY(x1, slope1), y1);
      expect(getY(x2, slope2), y2);
      expect(getY(x3, slope3), y3);
    });
  });
  group("Get X", () {
    test('should return the x axis value based on y and slope', () {
      double y1 = 5;
      double y2 = -4.8;
      double y3 = -10;

      double slope1 = 0;
      double slope2 = -1.6;
      double slope3 = 2.5;

      double x2 = 3;
      double x3 = -4;
      expect(() => getX(y1, slope1),
          throwsA(const TypeMatcher<OperationOnZeroException>()));
      expect(getX(y2, slope2), x2);
      expect(getX(y3, slope3), x3);
    });
  });
  group("Get Initial Position", () {
    test(
        'should return the center position of the screen with '
        'the box size taken into account', () {
      double screenWidth = 375;
      double screenHeight = 650;
      double boxWidth = 100;
      double boxHeight = 100;
      Offset initialPosition = const Offset(137.5, 275);

      expect(
          getInitialPosition(
            screenWidth,
            screenHeight,
            boxWidth,
            boxHeight,
          ),
          initialPosition);
    });
  });
  group("leftWallReached ", () {
    group("when going up", () {
      test(
          "Should set the y to top wall and set y as basis for calculation if it will cross the top wall before reaching the right wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 375, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 150,
            previousY: 300, //previous y
            currentX: 0,
            currentY: 100, //current Y is less than previous Y
            distanceToTarget: 0);
        leftWallReached(provider);
        expect(provider.isTargetBasedOnX, false);
        expect(
            provider.distanceToTarget, provider.walls.top - provider.currentY);
        expect((provider.distanceToTarget / provider.slope) + provider.currentX,
            lessThan(provider.walls.right));
      });
      test(
          "Should set the x to right wall and set x as basis for calculation if it will reach the right wall without crossing the top wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 375, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 150,
            previousY: 640, //previous y
            currentX: 0,
            currentY: 600, //current Y is less than previous Y
            distanceToTarget: 0);
        leftWallReached(provider);
        expect(provider.isTargetBasedOnX, true);
        expect(provider.distanceToTarget,
            provider.walls.right - provider.currentX);
        expect(
            provider.walls.top,
            lessThan((provider.distanceToTarget * provider.slope) +
                provider.currentY));
      });
    });

    group("when staying at the same height", () {
      test(
          "Should set the x to right wall and set x as basis for calculation if it will reach the right wall without crossing the top wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 375, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: 0.0,
            isTargetBasedOnX: true,
            previousX: 150,
            previousY: 350, //previous y
            currentX: 0.0,
            currentY: 350, //current Y is less than previous Y
            distanceToTarget: 0.0);
        leftWallReached(provider);
        expect(provider.isTargetBasedOnX, true);
        expect(provider.distanceToTarget,
            provider.walls.right - provider.currentX);
        expect(
            provider.walls.top,
            lessThan((provider.distanceToTarget * provider.slope) +
                provider.currentY));
      });
    });
    group("when going down", () {
      test(
          "Should set the y to bottom wall and set y as basis for calculation if it will cross the bottom wall before reaching the right wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 375, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: 1.5,
            isTargetBasedOnX: true,
            previousX: 150,
            previousY: 100, //previous y
            currentX: 0,
            currentY: 300, //current Y is more than previous Y
            distanceToTarget: 0);
        leftWallReached(provider);
        expect(provider.isTargetBasedOnX, false);
        expect(provider.distanceToTarget,
            provider.walls.bottom - provider.currentY);
        expect((provider.distanceToTarget / provider.slope) + provider.currentX,
            lessThan(provider.walls.right));
      });
      test(
          "Should set the x to right wall and set x as basis for calculation if it will reach the right wall without crossing the top wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 375, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 150,
            previousY: 600, //previous y
            currentX: 0,
            currentY: 640, //current Y is more than previous Y
            distanceToTarget: 0);
        leftWallReached(provider);
        expect(provider.isTargetBasedOnX, true);
        expect(provider.distanceToTarget,
            provider.walls.right - provider.currentX);
        expect((provider.distanceToTarget * provider.slope) + provider.currentY,
            lessThan(provider.walls.bottom));
      });
    });
  });
  group("rightWallReached ", () {
    group("when going up", () {
      test(
          "Should set the y to top wall and set y as basis for calculation if it will cross the top wall before reaching the left wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 375, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 150,
            previousY: 300, //previous y
            currentX: 275,
            currentY: 100, //current Y is less than previous Y
            distanceToTarget: 0);
        rightWallReached(provider);
        expect(provider.isTargetBasedOnX, false);
        expect(
            provider.distanceToTarget, provider.walls.top - provider.currentY);
        expect(
            provider.walls.left,
            lessThan((provider.distanceToTarget / provider.slope) +
                provider.currentX));
      });
      test(
          "Should set the x to left wall and set x as basis for calculation if it will reach the left wall without crossing the top wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 375, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 150,
            previousY: 640, //previous y
            currentX: 275,
            currentY: 600, //current Y is less than previous Y
            distanceToTarget: 0);
        rightWallReached(provider);
        expect(provider.isTargetBasedOnX, true);
        expect(
            provider.distanceToTarget, provider.walls.left - provider.currentX);
        expect(
            provider.walls.top,
            lessThan((provider.distanceToTarget * provider.slope) +
                provider.currentY));
      });
    });

    group("when staying at the same height", () {
      test(
          "Should set the x to left wall and set x as basis for calculation if it will reach the left wall without crossing the top wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 375, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: 0.0,
            isTargetBasedOnX: true,
            previousX: 150,
            previousY: 350, //previous y
            currentX: 275,
            currentY: 350, //current Y is less than previous Y
            distanceToTarget: 0.0);
        rightWallReached(provider);
        expect(provider.isTargetBasedOnX, true);
        expect(
            provider.distanceToTarget, provider.walls.left - provider.currentX);
        expect(
            provider.walls.top,
            lessThan((provider.distanceToTarget * provider.slope) +
                provider.currentY));
      });
    });
    group("when going down", () {
      test(
          "Should set the y to bottom wall and set y as basis for calculation if it will cross the bottom wall before reaching the left wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 375, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: 1.5,
            isTargetBasedOnX: true,
            previousX: 150,
            previousY: 100, //previous y
            currentX: 275,
            currentY: 300, //current Y is more than previous Y
            distanceToTarget: 0);
        rightWallReached(provider);
        expect(provider.isTargetBasedOnX, false);
        expect(provider.distanceToTarget,
            provider.walls.bottom - provider.currentY);
        expect(
            provider.walls.left,
            lessThan((provider.distanceToTarget / provider.slope) +
                provider.currentX));
      });
      test(
          "Should set the x to left wall and set x as basis for calculation if it will reach the left wall without crossing the top wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 375, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 150,
            previousY: 600, //previous y
            currentX: 275,
            currentY: 640, //current Y is more than previous Y
            distanceToTarget: 0);
        rightWallReached(provider);
        expect(provider.isTargetBasedOnX, true);
        expect(
            provider.distanceToTarget, provider.walls.left - provider.currentX);
        expect((provider.distanceToTarget * provider.slope) + provider.currentY,
            lessThan(provider.walls.bottom));
      });
    });
  });
  group("top wall reached", () {
    group("when going right", () {
      test(
          "should set the x to right wall and set x as basis for calculation if it will reach the right wall without crossing the bottom wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 375, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 150,
            previousY: 300, //previous y
            currentX: 160,
            currentY: 0, //current Y is less than previous Y
            distanceToTarget: 0);
        topWallReached(provider);
        expect(provider.isTargetBasedOnX, true);
        expect(provider.distanceToTarget,
            provider.walls.right - provider.currentX);
        expect((provider.distanceToTarget * provider.slope) + provider.currentX,
            lessThan(provider.walls.bottom));
      });
      test(
          "should set the y to bottom wall and set y as basis for calculation if it will reach the bottom wall without crossing the right wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 500, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 0,
            previousY: 300, //previous y
            currentX: 5,
            currentY: 0, //current Y is less than previous Y
            distanceToTarget: 0);
        topWallReached(provider);
        expect(provider.isTargetBasedOnX, false);
        expect(provider.distanceToTarget,
            provider.walls.bottom - provider.currentY);
        expect((provider.distanceToTarget / provider.slope) + provider.currentY,
            lessThan(provider.walls.right));
      });
    });
    group("when staying at same width", () {
      test(
          "should set the y to bottom wall and set y as basis for calculation if it will reach the bottom wall without crossing the right wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 500, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 150,
            previousY: 300, //previous y
            currentX: 150,
            currentY: 0, //current Y is less than previous Y
            distanceToTarget: 0);
        topWallReached(provider);
        expect(provider.isTargetBasedOnX, false);
        expect(provider.distanceToTarget,
            provider.walls.bottom - provider.currentY);
        expect((provider.distanceToTarget / provider.slope) + provider.currentY,
            lessThan(provider.walls.bottom));
      });
    });
    group("when going left", () {
      test(
          "should set the x to left wall and set x as basis for calculation if it will reach the left wall without crossing the bottom wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 375, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 250,
            previousY: 300, //previous y
            currentX: 160,
            currentY: 0, //current Y is less than previous Y
            distanceToTarget: 0);
        topWallReached(provider);
        expect(provider.isTargetBasedOnX, true);
        expect(
            provider.distanceToTarget, provider.walls.left - provider.currentX);
        expect((provider.distanceToTarget * provider.slope) + provider.currentX,
            lessThan(provider.walls.bottom));
      });
      test(
          "should set the y to bottom wall and set y as basis for calculation if it will reach the bottom wall without crossing the left wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 500, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 400,
            previousY: 300, //previous y
            currentX: 390,
            currentY: 0, //current Y is less than previous Y
            distanceToTarget: 0);
        topWallReached(provider);
        expect(provider.isTargetBasedOnX, false);
        expect(provider.distanceToTarget,
            provider.walls.bottom - provider.currentY);
        expect(
            provider.walls.left,
            lessThan((provider.distanceToTarget / provider.slope) +
                provider.currentX));
      });
    });
  });
  group("bottom wall reached", () {
    group("when going right", () {
      test(
          "should set the x to right wall and set x as basis for calculation if it will reach the right wall without crossing the top wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 375, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 150,
            previousY: 300, //previous y
            currentX: 160,
            currentY: 550, //current Y is less than previous Y
            distanceToTarget: 0);
        bottomWallReached(provider);
        expect(provider.isTargetBasedOnX, true);
        expect(provider.distanceToTarget,
            provider.walls.right - provider.currentX);
        expect(
            provider.walls.top,
            lessThan((provider.distanceToTarget * provider.slope) +
                provider.currentY));
      });
      test(
          "should set the y to top wall and set y as basis for calculation if it will reach the top wall without crossing the right wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 500, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 0,
            previousY: 300, //previous y
            currentX: 10,
            currentY: 550, //current Y is less than previous Y
            distanceToTarget: 0);
        bottomWallReached(provider);
        expect(provider.isTargetBasedOnX, false);
        expect(
            provider.distanceToTarget, provider.walls.top - provider.currentY);
        expect((provider.distanceToTarget / provider.slope) + provider.currentX,
            lessThan(provider.walls.right));
      });
    });
    group("when staying at same width", () {
      test(
          "should set the y to bottom wall and set y as basis for calculation if it will reach the bottom wall without crossing the right wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 500, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 150,
            previousY: 300, //previous y
            currentX: 150,
            currentY: 550, //current Y is less than previous Y
            distanceToTarget: 0);
        bottomWallReached(provider);
        expect(provider.isTargetBasedOnX, false);
        expect(
            provider.distanceToTarget, provider.walls.top - provider.currentY);
        expect(
            provider.walls.top,
            lessThan(
              (provider.distanceToTarget / provider.slope) + provider.currentY,
            ));
      });
    });
    group("when going left", () {
      test(
          "should set the x to left wall and set x as basis for calculation if it will reach the left wall without crossing the top wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 375, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 250,
            previousY: 300, //previous y
            currentX: 160,
            currentY: 550, //current Y is less than previous Y
            distanceToTarget: 0);
        bottomWallReached(provider);
        expect(provider.isTargetBasedOnX, true);
        expect(
            provider.distanceToTarget, provider.walls.top - provider.currentX);
        expect(
            provider.walls.top,
            lessThan((provider.distanceToTarget * provider.slope) +
                provider.currentY));
      });
      test(
          "should set the y to top wall and set y as basis for calculation if it will reach the top wall without crossing the left wall",
          () {
        BouncerProvider provider = BouncerProvider.init(
            walls: Walls(left: 0, top: 0, right: 500, bottom: 650),
            boxWidth: 100,
            boxHeight: 100,
            slope: -1.5,
            isTargetBasedOnX: true,
            previousX: 400,
            previousY: 300, //previous y
            currentX: 390,
            currentY: 550, //current Y is less than previous Y
            distanceToTarget: 0);
        bottomWallReached(provider);
        expect(provider.isTargetBasedOnX, false);
        expect(provider.distanceToTarget,
            provider.walls.top - provider.currentY);
        expect(
            provider.walls.left,
            lessThan((provider.distanceToTarget / provider.slope) +
                provider.currentX));
      });
    });
  });
}
