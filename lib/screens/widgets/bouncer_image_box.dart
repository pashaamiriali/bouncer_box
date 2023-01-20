import 'package:bouncer_box/provider/pictures_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BouncerImageBox extends StatelessWidget {
  const BouncerImageBox({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Consumer<PicturesProvider>(builder: (context, provider, _) {
      Widget imageChild = Container();
      imageChild = buildChildImageFromStatus(provider, imageChild);
      return InkWell(
        onTap: () {
          provider.loadNewPicture();
        },
        child: Container(
          color: Colors.blueGrey,
          width: width,
          height: height,
          child: imageChild,
        ),
      );
    });
  }

  Widget buildChildImageFromStatus(
      PicturesProvider provider, Widget imageChild) {
    switch (provider.pictureLoadingStatus) {
      case PictureLoadingStatus.initial:
        imageChild = const CircularProgressIndicator();
        break;
      case PictureLoadingStatus.loaded:
        Image.network(
          provider.currentPicture,
          width: 100,
          height: 100,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.red,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return const Center(child: Text('loading ...'));
            } else {
              int loaded = loadingProgress.cumulativeBytesLoaded ?? 1;
              int total = loadingProgress.expectedTotalBytes ?? 1;
              return Center(
                  child: Text("Loading... ${(loaded / total) * 100}%"));
            }
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 1)),
              child: child,
            );
          },
        );
        break;
      case PictureLoadingStatus.loading:
        imageChild = const CircularProgressIndicator();
        break;
      case PictureLoadingStatus.failure:
        imageChild = const Icon(
          Icons.error,
          color: Colors.red,
        );
        break;
    }
    return imageChild;
  }
}
