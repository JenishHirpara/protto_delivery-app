import 'package:flutter/material.dart';

class ServiceStationMenu extends StatelessWidget {
  final String title;
  final String routeName;
  final String url;

  ServiceStationMenu(this.title, this.routeName, this.url);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          child: Container(
            width: mediaQuery.size.width * 0.3,
            height: mediaQuery.size.width * 0.3,
            child: Image(image: AssetImage(url)),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(routeName);
          },
        ),
        SizedBox(height: 7),
        Text(
          title,
          softWrap: true,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
