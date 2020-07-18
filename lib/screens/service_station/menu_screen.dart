import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/service_station.dart';
import '../../providers/service_orders.dart';
import '../../widgets/service_station_menu.dart';
import './bookings_screen.dart';
import './partner_details_screen.dart';
import './delivery_executives_screen.dart';
import '../welcome_screen.dart';

class MenuScreen extends StatelessWidget {
  static const routeName = '/service-station-menu';

  @override
  Widget build(BuildContext context) {
    var ssName =
        Provider.of<ServiceStation>(context, listen: false).item1.ssName;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          ssName,
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 24,
          ),
        ),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.deepOrange,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text('Are you sure you want to logout?'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(context)
                              .pushReplacementNamed(WelcomeScreen.routeName);
                          Provider.of<ServiceStation>(context, listen: false)
                              .logout();
                          Provider.of<ServiceOrders>(context, listen: false)
                              .logout();
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
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
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
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                ServiceStationMenu('Bookings', BookingsScreen.routeName,
                    'assets/images/bookings.png'),
                ServiceStationMenu(
                    'Delivery Executives',
                    DeliveryExecutivesScreen.routeName,
                    'assets/images/delivery_executives.png'),
                ServiceStationMenu(
                    'Inventory Management',
                    BookingsScreen.routeName,
                    'assets/images/inventory_management.png'),
                ServiceStationMenu('Reports', BookingsScreen.routeName,
                    'assets/images/reports.png'),
                ServiceStationMenu(
                    'Protto Partner Details',
                    PartnerDetailsScreen.routeName,
                    'assets/images/protto_patner_details.png'),
                ServiceStationMenu('Settlements', BookingsScreen.routeName,
                    'assets/images/settlements.png'),
              ],
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 45,
              child: RaisedButton(
                child: Text(
                  'Protto Support',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
                elevation: 0,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      )),
    );
  }
}
