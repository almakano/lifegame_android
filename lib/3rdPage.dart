import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  List<dynamic> data;

  Future fetchData() async {
    final response =
        await http.get(Uri.parse('https://lifesim.makano.pp.ua/data/settings'));
    if (response.statusCode == 200) {
      data = json.decode(response.body);
    } else {
      throw Exception('Failed to load settings');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: data != null ? (data as Map).length : 0,
            itemBuilder: (BuildContext context, int index) {
              final item = (data as Map).values.elementAt(index);
              return Column(children: [
                CheckboxListTile(
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  onChanged: (bool value) {
                    setState(() {
                      item['value'] = value;
                    });
                  },
                  value: item['value'],
                ),
                Divider(height: 2.0),
              ]);
            }));
  }
}
