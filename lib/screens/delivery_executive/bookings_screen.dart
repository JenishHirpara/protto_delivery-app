import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../widgets/delivery_active_order_detail.dart';
import '../../providers/delivery_orders.dart';
import '../../providers/delivery_executive.dart';
import '../../screens/welcome_screen.dart';

class BookingsScreen extends StatefulWidget {
  static const routeName = '/delivery-bookings';

  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  var _isInit = true;
  var _isLoading = true;

  Future<void> _refreshPage() async {
    await Provider.of<DeliveryOrders>(context, listen: false)
        .fetchAndSetOrders();
    setState(() {});
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<DeliveryOrders>(context, listen: false)
          .fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<DeliveryOrders>(context, listen: false).items;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Service Bookings',
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
              MdiIcons.logout,
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
                          Provider.of<DeliveryExecutive>(context, listen: false)
                              .logout();
                          Provider.of<DeliveryOrders>(context, listen: false)
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshPage,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(12),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, i) => Column(
                      children: <Widget>[
                        ChangeNotifierProvider.value(
                          value: orders[i],
                          child: DeliveryActiveOrderDetail(i),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                    itemCount: orders.length,
                  ),
                ),
              ),
            ),
    );
  }
}
