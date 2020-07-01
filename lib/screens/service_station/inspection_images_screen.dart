import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/service_orders.dart';

class InspectionImagesScreen extends StatelessWidget {
  static const routeName = '/service-inspection-images';

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context).settings.arguments as ServiceOrderItem;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inspection Images',
          style: GoogleFonts.montserrat(
            color: Color.fromRGBO(241, 93, 36, 1),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: InkWell(
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 36),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Customer Name',
                    style: GoogleFonts.montserrat(
                      color: Colors.deepOrange,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Yamaha FZ',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 2,
              indent: 16,
              endIndent: 16,
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 36),
              child: Text(
                'Pre Service Inspection',
                style: GoogleFonts.montserrat(
                  color: Color.fromRGBO(112, 112, 112, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 36, vertical: 10),
              height: 230,
              width: double.infinity,
              child: GridView(
                children: <Widget>[
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                ],
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 36, vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Color.fromRGBO(240, 240, 240, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Odometer:',
                    style: GoogleFonts.cantataOne(
                      color: Color.fromRGBO(112, 112, 112, 1),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    '12,500',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 36, vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Color.fromRGBO(240, 240, 240, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Fuel Level:',
                    style: GoogleFonts.cantataOne(
                      color: Color.fromRGBO(112, 112, 112, 1),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    '75%',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 36),
              child: Text(
                'Pre Delivery Inspection',
                style: GoogleFonts.montserrat(
                  color: Color.fromRGBO(112, 112, 112, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 36, vertical: 10),
              height: 230,
              width: double.infinity,
              child: GridView(
                children: <Widget>[
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                ],
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 36, vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Color.fromRGBO(240, 240, 240, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Odometer:',
                    style: GoogleFonts.cantataOne(
                      color: Color.fromRGBO(112, 112, 112, 1),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    '12,500',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 36, vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Color.fromRGBO(240, 240, 240, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Fuel Level:',
                    style: GoogleFonts.cantataOne(
                      color: Color.fromRGBO(112, 112, 112, 1),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    '75%',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
