import 'package:bouncer_box/helper/image_helper.dart';
import 'package:flutter/cupertino.dart';

enum PictureLoadingStatus { initial, loaded, loading, failure }

class PicturesProvider extends ChangeNotifier {
  String currentPicture = "";
  PictureLoadingStatus pictureLoadingStatus = PictureLoadingStatus.initial;
  void init() {
    loadNewPicture();
  }

  void loadNewPicture() async {
    getImage(this);
    print('loading new picture');
  }

  void setStatusLoading() {
    pictureLoadingStatus = PictureLoadingStatus.loading;
    notifyListeners();
  }

  void setImage(String image) {
    currentPicture = image;
    pictureLoadingStatus = PictureLoadingStatus.loaded;
    notifyListeners();
  }

  void setImageLoadingFailure() {
    pictureLoadingStatus = PictureLoadingStatus.failure;
    notifyListeners();
  }
}
