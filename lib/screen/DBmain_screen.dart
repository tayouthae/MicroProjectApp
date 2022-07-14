import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchingData with ChangeNotifier {
  Future fetchpaper() async {
    var url = "https://microproject-47857.firebaseio.com/test.json";
    final response = await http.get(url);
    final extractedData = json.decode(response.body);
    print(extractedData);
    // await print('done');
    notifyListeners();
  }
}
