import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../widgets/service_station_order_menu.dart';
import '../../providers/service_orders.dart';
import './delivery_info_screen.dart';
import './jobs_screen.dart';
import './coming_soon.dart';
import './inspection_images_screen.dart';
import '../../models/http_exception.dart';

class OrderMenuScreen extends StatefulWidget {
  static const routeName = 'service-station-menu2';

  @override
  _OrderMenuScreenState createState() => _OrderMenuScreenState();
}

class _OrderMenuScreenState extends State<OrderMenuScreen> {
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
                      .incrementstatus(bookingId, '5',
                          'Service cannot be completed right now');
                  Provider.of<ServiceOrders>(context, listen: false)
                      .updateStatus(bookingId);
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text('Service Done successful!'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              setState(() {});
                              Navigator.of(ctx).pop();
                              Navigator.of(context).pop();
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
    var order = ModalRoute.of(context).settings.arguments as ServiceOrderItem;
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
                  'Delivery Info',
                  DeliveryInfoScreen.routeName,
                  order,
                  'assets/images/delivery_info.png',
                ),
                ServiceStationOrderMenu(
                  'Service/Jobs',
                  JobsScreen.routeName,
                  order,
                  'assets/images/jobs.png',
                ),
                ServiceStationOrderMenu(
                  'Inspection Details',
                  InspectionImagesScreen.routeName,
                  order,
                  'assets/images/inspection_details.png',
                ),
                ServiceStationOrderMenu(
                  'Part Ordering',
                  ComingSoonScreen.routeName,
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
            int.parse(order.status) != 5 || order.jobApprove == '0'
                ? Container()
                : Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 20,
                    ),
                    width: double.infinity,
                    height: 50,
                    color: Colors.deepOrange,
                    child: RaisedButton(
                      color: Colors.deepOrange,
                      onPressed: () => _serviceDone(context, order.bookingId),
                      child: Text(
                        'Service Done',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
