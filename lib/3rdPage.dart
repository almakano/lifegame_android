import 'package:flutter/material.dart';
import 'main.dart';

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  var data;

  void fetchData() {
    data = RequestTask.get('/data/settings');
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
