import 'package:flutter/material.dart';

import '../providers/service_orders.dart';

class ServiceStationOrderMenu extends StatelessWidget {
  final String title;
  final String routeName;
  final ServiceOrderItem order;
  final String imageurl;

  ServiceStationOrderMenu(
      this.title, this.routeName, this.order, this.imageurl);

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
            child: Image(image: AssetImage(imageurl)),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(routeName, arguments: order);
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
