import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:protto_delivery_ex_app/providers/delivery_executive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../../providers/delivery_orders.dart';
import '../../models/http_exception.dart';

class DeliveryInfoScreen extends StatefulWidget {
  static const routeName = '/delivery-ex-info';

  @override
  _DeliveryInfoScreenState createState() => _DeliveryInfoScreenState();
}

class _DeliveryInfoScreenState extends State<DeliveryInfoScreen> {
  Location _location = new Location();
  var _locationData;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

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
    String query = Uri.encodeComponent(order.address);
    var url =
        'https://www.google.com/maps/dir/?api=1&origin=${_locationData.latitude},${_locationData.longitude}&destination=$query&travelmode=driving&dir_action=navigate';
    _launchURL(url);
  }

  void _dropBikeToSS(String bookingId) async {
    try {
      await Provider.of<DeliveryOrders>(context, listen: false)
          .incrementstatus(bookingId, '3');
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Bike drop to Service Station approved!'),
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
  }

  void _bikePickedFromSS(String bookingId) async {
    try {
      await Provider.of<DeliveryOrders>(context, listen: false)
          .incrementstatus(bookingId, '7');
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Pick up bike from service station approved!'),
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
  }

  Widget _otp(String otp) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.14,
            height: MediaQuery.of(context).size.width * 0.14,
            color: Color.fromRGBO(200, 200, 200, 1),
            child: Center(
              child: Text(
                otp[0],
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.14,
            height: MediaQuery.of(context).size.width * 0.14,
            color: Color.fromRGBO(200, 200, 200, 1),
            child: Center(
              child: Text(
                otp[1],
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.14,
            height: MediaQuery.of(context).size.width * 0.14,
            color: Color.fromRGBO(200, 200, 200, 1),
            child: Center(
              child: Text(
                otp[2],
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.14,
            height: MediaQuery.of(context).size.width * 0.14,
            color: Color.fromRGBO(200, 200, 200, 1),
            child: Center(
              child: Text(
                otp[3],
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order =
        ModalRoute.of(context).settings.arguments as DeliveryOrderItem;
    var otp = order.otp;
    var deliveryOtp = order.deliveryOtp;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delivery Info',
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    order.customer,
                    style: GoogleFonts.montserrat(
                      color: Colors.deepOrange,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '${order.make} ${order.model}',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
                thickness: 2,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'PickUp Info',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 9,
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Address: ',
                                  style: GoogleFonts.cantataOne(
                                    color: Color.fromRGBO(128, 128, 128, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: order.landmark != ''
                                      ? '${order.flat}, ${order.landmark}, ${order.address}'
                                      : '${order.flat}, ${order.address}',
                                  style: GoogleFonts.cantataOne(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            onPressed: () => _openMap(order),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Text(
                          'Date:',
                          style: GoogleFonts.cantataOne(
                            color: Color.fromRGBO(128, 128, 128, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          order.date,
                          style: GoogleFonts.cantataOne(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Text(
                          'Time:',
                          style: GoogleFonts.cantataOne(
                            color: Color.fromRGBO(128, 128, 128, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          order.time,
                          style: GoogleFonts.cantataOne(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 4),
                    // Row(
                    //   children: <Widget>[
                    //     Text(
                    //       'Del. Ex:',
                    //       style: GoogleFonts.cantataOne(
                    //         color: Color.fromRGBO(128, 128, 128, 1),
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     SizedBox(width: 8),
                    //     Text(
                    //       'Delivery Ex. Name',
                    //       style: GoogleFonts.cantataOne(
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Text(
                          'Service station: ',
                          style: GoogleFonts.cantataOne(
                            color: Color.fromRGBO(128, 128, 128, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          Provider.of<DeliveryExecutive>(context, listen: false)
                              .item
                              .ssName,
                          style: GoogleFonts.cantataOne(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Otp',
                style: GoogleFonts.montserrat(fontSize: 18),
              ),
              SizedBox(height: 10),
              _otp(otp),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepOrange),
                  ),
                  child: RaisedButton(
                    child: Text('Dropped'),
                    color: Colors.white,
                    elevation: 0,
                    onPressed: () => _dropBikeToSS(order.bookingId),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Drop Off address',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 9,
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Address: ',
                                  style: GoogleFonts.cantataOne(
                                    color: Color.fromRGBO(128, 128, 128, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: order.landmark != ''
                                      ? '${order.flat}, ${order.landmark}, ${order.address}'
                                      : '${order.flat}, ${order.address}',
                                  style: GoogleFonts.cantataOne(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            onPressed: () => _openMap(order),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Delivery Otp',
                style: GoogleFonts.montserrat(fontSize: 18),
              ),
              SizedBox(height: 10),
              _otp(deliveryOtp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepOrange),
                  ),
                  child: RaisedButton(
                    child: Text('Picked'),
                    color: Colors.white,
                    elevation: 0,
                    onPressed: () => _bikePickedFromSS(order.bookingId),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
