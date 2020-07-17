import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../widgets/service_station_order_menu.dart';
import '../../providers/service_orders.dart';
import './delivery_info_screen.dart';
import './jobs_screen.dart';
import './inspection_images_screen.dart';
import '../../models/http_exception.dart';

class OrderMenuScreen extends StatelessWidget {
  static const routeName = 'service-station-menu2';

  Future<void> _serviceDone(BuildContext context, String bookingId) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Are you sure the service is finished?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                try {
                  await Provider.of<ServiceOrders>(context, listen: false)
                      .incrementstatus(bookingId, '5');
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text('Service Done successful!'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text('Okay'),
                          ),
                        ],
                      );
                    },
                  );
                } on HttpException catch (error) {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text(error.message),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text('Okay'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Yes'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context).settings.arguments as ServiceOrderItem;
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
                fontSize: 22,
              ),
            ),
            SizedBox(height: 20),
            GridView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                ServiceStationOrderMenu(
                  'Service/Jobs',
                  JobsScreen.routeName,
                  order,
                  'assets/images/jobs.png',
                ),
                ServiceStationOrderMenu(
                  'Delivery Info',
                  DeliveryInfoScreen.routeName,
                  order,
                  'assets/images/delivery_info.png',
                ),
                ServiceStationOrderMenu(
                  'Inspection Details',
                  InspectionImagesScreen.routeName,
                  order,
                  'assets/images/inspection_details.png',
                ),
                ServiceStationOrderMenu(
                  'Part Ordering',
                  DeliveryInfoScreen.routeName,
                  order,
                  'assets/images/part_ordering.png',
                ),
              ],
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
            Container(
              padding: EdgeInsets.all(40),
              width: double.infinity,
              //height: 50,
              child: RaisedButton(
                color: Colors.deepOrange,
                onPressed: () => _serviceDone(context, order.bookingId),
                child: Text(
                  'Service Done',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
