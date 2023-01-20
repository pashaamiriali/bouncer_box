import 'package:dio/dio.dart';

Future<void> sendGetRequest(String url, Function(Response) successHandler,
    Function errorHandler) async {
  try {
    Response response = await Dio().get(url,
        options: Options(contentType: 'image/jpg', headers: {
          "Accept-Version": 'v1',
          'Authorization': 'Client-ID NyQDRED6bs_thipxQkf5gXYz19PepgmwpjPjSaDhZjA',
        }));
    successHandler(response);
  } on Exception catch (e) {
    print(e);
    errorHandler();
  }
}
