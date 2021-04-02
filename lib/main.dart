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
  static String endPoint = 'https://lifesim.makano.pp.ua';
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

    debugPrint(App.endPoint);
    var time1 = DateTime.now();
    var response =
        await http.get(Uri.parse(App.endPoint + url), headers: headers);
    var time2 = DateTime.now().difference(time1);

    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      App.cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }

    if (App.isLog)
      debugPrint(
          "GET ${App.endPoint + url}: ${response.statusCode} ${time2}s ${response.body}");
    if (response.statusCode == 200) {
      try {
        var res = (new JsonDecoder()).convert(response.body);
        return res;
      } on Exception catch (e) {
        debugPrint("GET: $e");
      }
    }
  }

  static dynamic post(String url,
      {Map<String, String> headers, body, encoding}) async {
    if (headers == null) {
      headers = new Map();
    }
    headers[HttpHeaders.userAgentHeader] = "android";
    if (App.token != null) {
      headers[HttpHeaders.authorizationHeader] = "Basic " + App.token;
    }
    DateTime time1 = DateTime.now();

    http.Response response = await http.post(Uri.parse(App.endPoint + url),
        body: body, headers: headers);
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

    return response;
  }

  static dynamic upload(String url, List<File> files) async {
    var headers = {HttpHeaders.userAgentHeader: "android"};
    if (App.token != null) {
      headers[HttpHeaders.authorizationHeader] = "Basic " + App.token;
    }
    DateTime time1 = DateTime.now();

    try {
      var request =
          http.MultipartRequest("POST", Uri.parse(App.endPoint + url));
      request.headers.addAll(headers);

      for (int i = 0; i < files.length; i++) {
        var len = await files[i].length();
        request.files.add(http.MultipartFile("files", files[i].openRead(), len,
            filename: basename(files[i].path)));
      }

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
