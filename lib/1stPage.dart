import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  FirstPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListView(scrollDirection: Axis.horizontal, children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red,
              ),
              title: Text('Name'),
              subtitle: Text('Description'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                print('Click Item');
              },
            ),
          ]),
          Row(children: [
            Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text(
                    '1st page',
                  ),
                ]))
          ])
        ]);
  }
}
