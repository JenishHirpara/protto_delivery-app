import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/http_exception.dart';
import '../../providers/delivery_orders.dart';
import './inspection_images_screen.dart';
import './display_inspection_images_screen.dart';
import './edit_regno_screen.dart';
import './delivery_info_screen.dart';
import './payments_screen.dart';

class SampleStepTile {
  SampleStepTile({
    Key key,
    this.title,
    this.date,
  });

  Widget title;
  String date;
}

class ActiveOrderScreen extends StatefulWidget {
  static const routeName = '/active-order';

  final DeliveryOrderItem order;

  ActiveOrderScreen(this.order);

  @override
  _ActiveOrderScreenState createState() => _ActiveOrderScreenState();
}

class _ActiveOrderScreenState extends State<ActiveOrderScreen> {
  Location _location = new Location();
  var _locationData;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  var _order;

  void _dropBikeToSS(String bookingId) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Have you dropped off the bike to SS?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(ctx).pop();
                try {
                  await Provider.of<DeliveryOrders>(context, listen: false)
                      .incrementstatus(bookingId, '3',
                          'Bike cannot be dropped to SS right now');
                  showDialog(
                    context: context,
                    builder: (ctx1) {
                      return AlertDialog(
                        title: Text('Bike drop to Service Station approved!'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Okay'),
                            onPressed: () {
                              Navigator.of(ctx1).pop();
                            },
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
                        title: Text('Error occurred!'),
                        content: Text(error.message),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Okay'),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _bikePickedFromSS(String bookingId) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Have you picked up the bike from customer?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(ctx).pop();
                try {
                  await Provider.of<DeliveryOrders>(context, listen: false)
                      .incrementstatus(bookingId, '6',
                          'Bike cannot be picked from SS right now');
                  showDialog(
                    context: context,
                    builder: (ctx1) {
                      return AlertDialog(
                        title:
                            Text('Pick up bike from service station approved!'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Okay'),
                            onPressed: () {
                              Navigator.of(ctx1).pop();
                            },
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
                        title: Text('Error occurred!'),
                        content: Text(error.message),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Okay'),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openMap(DeliveryOrderItem order) async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }
    if (!_serviceEnabled) {
      return;
    }
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
    _locationData = await _location.getLocation();
    var url =
        'https://www.google.com/maps/dir/?api=1&origin=${_locationData.latitude},${_locationData.longitude}&destination=${order.latitude},${order.longitude}&travelmode=driving&dir_action=navigate';
    _launchURL(url);
  }

  Future<void> _refreshPage() async {
    _order = await Provider.of<DeliveryOrders>(context, listen: false)
        .fetchabooking(widget.order.bookingId, widget.order);
    print(_order.status);
    Provider.of<DeliveryOrders>(context, listen: false)
        .changeorderstatus(widget.order.id, _order);
    print(Provider.of<DeliveryOrders>(context, listen: false).items[1].status);
    setState(() {});
  }

  List<SampleStepTile> get steps {
    return [
      SampleStepTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Confirmed',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xff707070),
                fontFamily: 'SourceSansPro',
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(4.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400],
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), //(x,y)
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: FlatButton(
                color: Color.fromRGBO(250, 250, 250, 1),
                child: Text(
                  'Location',
                  style: TextStyle(
                    fontFamily: 'SourceSansProSB',
                    color: Color.fromRGBO(112, 112, 112, 0.7),
                  ),
                ),
                onPressed: () => _openMap(widget.order),
              ),
            ),
          ],
        ),
        date: _order == null ? widget.order.date : _order.date,
      ),
      SampleStepTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Inspection',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xff707070),
                fontFamily: 'SourceSansPro',
              ),
            ),
            SizedBox(height: 5),
            int.parse(widget.order.status) >= 2
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400],
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 2.0), //(x,y)
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: FlatButton(
                      color: Color.fromRGBO(250, 250, 250, 1),
                      child: Text(
                        'Click Images',
                        style: TextStyle(
                          fontFamily: 'SourceSansProSB',
                          color: Color.fromRGBO(112, 112, 112, 0.7),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            InspectionImagesScreen.routeName,
                            arguments: widget.order);
                      },
                    ),
                  ),
            SizedBox(height: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(4.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400],
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), //(x,y)
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: FlatButton(
                color: Color.fromRGBO(250, 250, 250, 1),
                child: Text(
                  'Reg No',
                  style: TextStyle(
                    fontFamily: 'SourceSansProSB',
                    color: Color.fromRGBO(112, 112, 112, 0.7),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditRegnoScreen.routeName,
                      arguments: [widget.order.bikeid, widget.order.id]);
                },
              ),
            ),
          ],
        ),
        date: _order == null ? widget.order.date : _order.date,
      ),
      SampleStepTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bike Picked Up',
              style: TextStyle(
                color: Color(0xff707070),
                fontFamily: 'SourceSansPro',
              ),
            ),
            SizedBox(height: 10),
            int.parse(widget.order.status) >= 3
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400],
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 2.0), //(x,y)
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: FlatButton(
                      color: Color.fromRGBO(250, 250, 250, 1),
                      child: Text(
                        'OTP',
                        style: TextStyle(
                          fontFamily: 'SourcsSansProSB',
                          color: Color.fromRGBO(112, 112, 112, 0.7),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          DeliveryInfoScreen.routeName,
                          arguments: widget.order,
                        );
                      },
                    ),
                  ),
          ],
        ),
        date: _order == null ? widget.order.date : _order.date,
      ),
      SampleStepTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Bike Dropped at Service Station',
              style: TextStyle(
                color: Color(0xff707070),
                fontFamily: 'SourceSansPro',
              ),
            ),
            SizedBox(height: 10),
            int.parse(widget.order.status) >= 4
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400],
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 2.0), //(x,y)
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: FlatButton(
                      color: Color.fromRGBO(250, 250, 250, 1),
                      child: Text(
                        'Dropped Off',
                        style: TextStyle(
                          fontFamily: 'SourcsSansProSB',
                          color: Color.fromRGBO(112, 112, 112, 0.7),
                        ),
                      ),
                      onPressed: () {
                        _dropBikeToSS(widget.order.bookingId);
                      },
                    ),
                  ),
          ],
        ),
        date: _order == null ? widget.order.date : _order.date,
      ),
      SampleStepTile(
        title: Text(
          'Service Started',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'SourceSansPro',
            color: Color(0xff707070),
          ),
        ),
        date: widget.order.date,
      ),
      SampleStepTile(
        title: Text(
          'Service Done',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'SourceSansPro',
            color: Color(0xff707070),
          ),
        ),
        date: _order == null ? widget.order.date : _order.date,
      ),
      SampleStepTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Picked from SS',
              style: TextStyle(
                color: Color(0xff707070),
                fontFamily: 'SourceSansPro',
              ),
            ),
            SizedBox(height: 5),
            int.parse(widget.order.status) >= 7
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400],
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 2.0), //(x,y)
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: FlatButton(
                      color: Color.fromRGBO(250, 250, 250, 1),
                      child: Text(
                        'Picked Up',
                        style: TextStyle(
                          fontFamily: 'SourcsSansProSB',
                          color: Color.fromRGBO(112, 112, 112, 0.7),
                        ),
                      ),
                      onPressed: () {
                        _bikePickedFromSS(widget.order.bookingId);
                      },
                    ),
                  ),
            SizedBox(height: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(4.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400],
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), //(x,y)
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: FlatButton(
                color: Color.fromRGBO(250, 250, 250, 1),
                child: Text(
                  'Location',
                  style: TextStyle(
                    fontFamily: 'SourcsSansProSB',
                    color: Color.fromRGBO(112, 112, 112, 0.7),
                  ),
                ),
                onPressed: () => _openMap(widget.order),
              ),
            ),
          ],
        ),
        date: _order == null ? widget.order.date : _order.date,
      ),
      SampleStepTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Inspection',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'SourceSansPro',
                color: Color(0xff707070),
              ),
            ),
            SizedBox(height: 5),
            int.parse(widget.order.status) >= 8
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400],
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 2.0), //(x,y)
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: FlatButton(
                      color: Color.fromRGBO(250, 250, 250, 1),
                      child: Text(
                        'Click Images',
                        style: TextStyle(
                          fontFamily: 'SourceSansProSB',
                          color: Color.fromRGBO(112, 112, 112, 0.7),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            InspectionImagesScreen.routeName,
                            arguments: widget.order);
                      },
                    ),
                  ),
            SizedBox(height: 5),
            int.parse(widget.order.status) >= 9
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400],
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 2.0), //(x,y)
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: FlatButton(
                      color: Color.fromRGBO(250, 250, 250, 1),
                      child: Text(
                        'Payment',
                        style: TextStyle(
                          fontFamily: 'SourceSansProSB',
                          color: Color.fromRGBO(112, 112, 112, 0.7),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            PaymentsScreen.routeName,
                            arguments: widget.order);
                      },
                    ),
                  ),
          ],
        ),
        date: _order == null ? widget.order.date : _order.date,
      ),
      SampleStepTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivered',
              style: TextStyle(
                color: Color(0xff707070),
                fontFamily: 'SourceSansPro',
              ),
            ),
            SizedBox(height: 10),
            int.parse(widget.order.status) >= 9
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400],
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 2.0), //(x,y)
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: FlatButton(
                      color: Color.fromRGBO(250, 250, 250, 1),
                      child: Text(
                        'OTP',
                        style: TextStyle(
                          fontFamily: 'SourcsSansProSB',
                          color: Color.fromRGBO(112, 112, 112, 0.7),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          DeliveryInfoScreen.routeName,
                          arguments: widget.order,
                        );
                      },
                    ),
                  ),
          ],
        ),
        date: _order == null ? widget.order.date : _order.date,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Active Order',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Theme.of(context).primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(112, 112, 112, 1),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${widget.order.make}',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Theme.of(context).primaryColor,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            '${widget.order.model}',
                            softWrap: true,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            widget.order.bikeYear,
                            style: TextStyle(
                              color: Color.fromRGBO(112, 112, 112, 0.7),
                            ),
                          ),
                          Text(
                            widget.order.bikeNumber,
                            style: TextStyle(
                              color: Color.fromRGBO(112, 112, 112, 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: RaisedButton(
                          child: Text(
                            'View Images',
                            style: TextStyle(
                              fontFamily: 'SourceSansProSB',
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              DisplayInspectionImagesScreen.routeName,
                              arguments: widget.order,
                            );
                          },
                          color: Theme.of(context).primaryColor,
                          elevation: 6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Track the progress',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Color(0xff707070),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ...steps.asMap().entries.map((entry) {
                      int index = entry.key;
                      SampleStepTile step = entry.value;
                      return Container(
                        height: 110,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 110,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(step.date)),
                                          style: TextStyle(
                                            fontFamily: 'SourceSansPro',
                                            color: Color.fromRGBO(
                                                128, 128, 128, 1),
                                          ),
                                        ),
                                        // Text(
                                        //   step.time,
                                        //   style: TextStyle(
                                        //     fontFamily: 'SourceSansPro',
                                        //     color: Color.fromRGBO(
                                        //         128, 128, 128, 1),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 110,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          int.parse(_order == null
                                                      ? widget.order.status
                                                      : _order.status) >=
                                                  index + 1
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_unchecked,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                        index == 8
                                            ? Container()
                                            : Container(
                                                height: 90,
                                                child: VerticalDivider(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  thickness: 2,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: 110,
                                    child: step.title,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
