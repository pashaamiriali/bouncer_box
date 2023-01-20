import 'package:bouncer_box/infrastructure/get_request_service.dart';
import 'package:bouncer_box/provider/pictures_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Future<void> getImage(PicturesProvider provider) async {
  provider.setStatusLoading();
  sendGetRequest('https://api.unsplash.com/photos/random/',
      (Response response) {
    print(response.data['urls']['small']);
    provider.setImage(response.data['urls']['small']);
  }, () {
    provider.setImageLoadingFailure();
  });
}
