import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          // ListView(scrollDirection: Axis.vertical, children: [
          //   ListTile(
          //     leading: CircleAvatar(
          //       backgroundColor: Colors.red,
          //     ),
          //     title: Text('Name'),
          //     subtitle: Text('Description'),
          //     trailing: Icon(Icons.keyboard_arrow_right),
          //     onTap: () {
          //       print('Click Item');
          //     },
          //   ),
          // ]),
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(
                        '1st page',
                      ),
                    ]))
              ])
        ]));
  }
}
