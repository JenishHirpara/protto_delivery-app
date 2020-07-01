import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './delivery_info_screen.dart';
import './inspection_images_screen.dart';

class MenuScreen extends StatelessWidget {
  static const routeName = '/delivery-ex-menu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Customer Name',
          style: GoogleFonts.montserrat(
            color: Colors.deepOrange,
            fontSize: 24,
          ),
        ),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Text(
              'Menu',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.3,
                        color: Color.fromRGBO(100, 100, 100, 1),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(DeliveryInfoScreen.routeName);
                      },
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Delivery Info',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.3,
                        color: Color.fromRGBO(100, 100, 100, 1),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(InspectionImagesScreen.routeName);
                      },
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Inspection Details',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
