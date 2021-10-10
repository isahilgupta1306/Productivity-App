// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
// import 'package:productivity_app/models/disctionary_model.dart';

// class ApiManager {
//   final String _baseUrl = "https://owlbot.info/api/v4/dictionary/";
//   final String _token = "1cd10ef057f32eb0f0edc736c34e6f7fca684bed";

//   // ApiManager(this.streamController);
//   Future<MeaningModelOwlBot> searchByFuture(String word) async {
//     late MeaningModelOwlBot meaningModel;
//     if (word == null || word.length == 0) {}
//     Response response = await http.get(Uri.parse(_baseUrl + word.trim()),
//         headers: {"Authorization": "Token " + _token});
//     try {
//       if (response.statusCode == 200) {
//         // if req suceeds
//         var jsonMap = json.decode(response.body);

//         print(jsonMap);
//         meaningModel = MeaningModelOwlBot.fromJson(jsonMap);
//         print('after model');

//         print(meaningModel.definitions[0].example);

//         if (meaningModel == null) {
//           print('model null hai');
//         }
//       }
//       return meaningModel;
//     } catch (Exception) {
//       return meaningModel;
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:productivity_app/models/disctionary_model.dart';

class ApiManager {
  String _baseUrl = "https://owlbot.info/api/v4/dictionary/";
  String _token = "1cd10ef057f32eb0f0edc736c34e6f7fca684bed";

  // ApiManager(this.streamController);
  Future<MeaningModelOwlBot?> searchByFuture(String word) async {
    MeaningModelOwlBot? meaningModel;
    if (word == null || word.length == 0) {}
    Response response = await http.get(Uri.parse(_baseUrl + word.trim()),
        headers: {"Authorization": "Token " + _token});
    try {
      if (response.statusCode == 200) {
        // if req suceeds
        var jsonMap = json.decode(response.body);
        print('working!');
        print(jsonMap);

        meaningModel = MeaningModelOwlBot.fromJson(jsonMap);
        print(meaningModel.definitions);
        print('after model');

        print(meaningModel.definitions[0].example);

        if (meaningModel == null) {
          print('model null hai');
        }

        return meaningModel;
      }
    } catch (Exception) {
      return meaningModel;
    }
  }
}
