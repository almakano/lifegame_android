import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_socketio_feathersjs/flutter_socketio_feathersjs.dart';

import 'home.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  static var me;
  static String token;
  static String cookie;
  static String endPoint = 'https://lifesim.makano.pp.ua/';
  static SocketIO socketChat;
  static bool isLog = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      title: 'LifeSim',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(title: 'LifeSim'),
    );
  }
}

class RequestTask {
  static Future<dynamic> get(String url) async {
    final Map<String, String> headers = new Map();

    headers[HttpHeaders.userAgentHeader] = "android";

    if (App.token != null) {
      headers[HttpHeaders.authorizationHeader] = "Basic " + App.token;
    }
    if (App.cookie != null) {
      headers[HttpHeaders.cookieHeader] = App.cookie;
    }

    DateTime time1 = DateTime.now();

    try {
      HttpClient client = new HttpClient();
      return client
          .getUrl(Uri.parse(App.endPoint + url))
          .then((HttpClientRequest request) {
        headers.forEach((k, i) {
          request.headers.add(k, i);
        });
        return request.close();
      }).then((HttpClientResponse response) {
        if (response.cookies != null) {
          App.cookie = response.cookies as String;
        }

        var time2 = DateTime.now().difference(time1);

        if (App.isLog)
        // debugPrint("GET ${App.endPoint + url}: ${response.statusCode} ${time2}s ${response.body}");
        if (response.statusCode == 200) {
          try {
            var res = json.decode(response.toString());
            return res;
          } on Exception catch (e) {
            debugPrint("GET: $e");
          }
        }
      });
    } catch (e) {
      debugPrint("GET: $e");
    }
  }

  static Future<dynamic> post(String url,
      {Map<String, String> headers, body, encoding}) async {
    if (headers == null) {
      headers = new Map();
    }
    headers[HttpHeaders.userAgentHeader] = "android";
    if (App.token != null) {
      headers[HttpHeaders.authorizationHeader] = "Basic " + App.token;
    }
    DateTime time1 = DateTime.now();

    try {
      return http
          .post(App.endPoint + url,
              body: body, headers: headers, encoding: encoding)
          .then((http.Response response) {
        if (response.headers['set-cookie'] != null) {
          App.cookie = response.headers['set-cookie'];
        }

        final String res = response.body;

        var time2 = DateTime.now().difference(time1);

        if (App.isLog)
          debugPrint(
              "POST ${App.endPoint + url}: ${response.statusCode} ${time2}s ${response.body}");
        if (response.statusCode == 200) {
          try {
            final json = (new JsonDecoder()).convert(res);
            return json;
          } on Exception catch (e) {
            debugPrint("POST: $e");
          }
        }
      });
    } catch (e) {
      debugPrint("POST: $e");
    }
  }

  static Future<dynamic> upload(String url, List<File> files) async {
    var headers = {HttpHeaders.userAgentHeader: "android"};
    if (App.token != null) {
      headers[HttpHeaders.authorizationHeader] = "Basic " + App.token;
    }
    DateTime time1 = DateTime.now();

    try {
      var multipartFiles = List(files.length);
      for (int i = 0; i < files.length; i++) {
        var len = await files[i].length();
        multipartFiles.add(http.MultipartFile("files", files[i].openRead(), len,
            filename: basename(files[i].path)));
      }
      var request =
          http.MultipartRequest("POST", Uri.parse(App.endPoint + url));
      request.headers.addAll(headers);
      request.files.addAll(multipartFiles);

      var response = await http.Response.fromStream(await request.send());
      var time2 = DateTime.now().difference(time1);

      if (App.isLog)
        debugPrint(
            "UPLOAD ${App.endPoint + url}: ${response.statusCode} ${time2}s ${response.body}");

      if (response.statusCode == 200) {
        try {
          final json = (new JsonDecoder()).convert(response.body);
          return json;
        } on Exception catch (e) {
          debugPrint("UPLOAD: $e");
        }
      }
    } catch (e) {
      debugPrint("UPLOAD: $e");
    }
  }
}
