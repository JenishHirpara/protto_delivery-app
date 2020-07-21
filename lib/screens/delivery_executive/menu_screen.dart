import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './delivery_info_screen.dart';
import './inspection_images_screen.dart';
import './display_inspection_images_screen.dart';
import '../../providers/delivery_orders.dart';

class MenuScreen extends StatelessWidget {
  static const routeName = '/delivery-ex-menu';

  @override
  Widget build(BuildContext context) {
    final order =
        ModalRoute.of(context).settings.arguments as DeliveryOrderItem;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          order.customer,
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
            GridView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10),
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                //childAspectRatio: 9 / 10,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            InspectionImagesScreen.routeName,
                            arguments: order);
                      },
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.15),
                              offset: Offset(0.0, 5.0), //(x,y)
                              blurRadius: 7.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Image.asset('assets/images/1.png'),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Click Inspection Images',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            DeliveryInfoScreen.routeName,
                            arguments: order);
                      },
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.15),
                              offset: Offset(0.0, 5.0), //(x,y)
                              blurRadius: 7.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Image.asset('assets/images/2.png'),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Delivery Info',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            DisplayInspectionImagesScreen.routeName,
                            arguments: order);
                      },
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.15),
                              offset: Offset(0.0, 5.0), //(x,y)
                              blurRadius: 7.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Image.asset('assets/images/3.png'),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Display Inspection Images',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
