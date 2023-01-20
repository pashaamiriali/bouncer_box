import 'package:bouncer_box/helper/bounce_helper.dart';
import 'package:bouncer_box/provider/bouncer_provider.dart';
import 'package:bouncer_box/model/wall_model.dart';
import 'package:bouncer_box/provider/pictures_provider.dart';
import 'package:bouncer_box/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomeWrapper(),
    );
  }
}

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BouncerProvider>(create: (_) {
          Offset initialPosition =
              getInitialPosition(screenSize.width, screenSize.height, 100, 100);
          return _initializeBouncerProvider(screenSize, initialPosition);
        }),
        ChangeNotifierProvider<PicturesProvider>(create: (_) {
          var pictureProvider = PicturesProvider();
          pictureProvider.init();
          return PicturesProvider();
        }),
      ],
      child: MyHomePage(screenSize: screenSize),
    );
  }

  BouncerProvider _initializeBouncerProvider(
      Size screenSize, Offset initialPosition) {
    return BouncerProvider.init(
      walls: Walls(
          left: 0, right: screenSize.width, top: 0, bottom: screenSize.height),
      boxWidth: 100,
      boxHeight: 100,
      slope: 1,
      isTargetBasedOnX: true,
      distanceToTarget: 0,
      previousY: initialPosition.dy,
      previousX: initialPosition.dx,
      currentY: initialPosition.dy,
      currentX: initialPosition.dx,
    );
  }
}
