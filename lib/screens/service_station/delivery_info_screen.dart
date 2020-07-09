import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/service_orders.dart';
import '../../providers/service_station.dart';

class DeliveryInfoScreen extends StatefulWidget {
  static const routeName = '/service-delivery-info';

  @override
  _DeliveryInfoScreenState createState() => _DeliveryInfoScreenState();
}

class _DeliveryInfoScreenState extends State<DeliveryInfoScreen> {
  var _isInit = true;
  var _isLoading = true;
  final _form = GlobalKey<FormState>();
  var _userName;
  var _id;
  List<DeliveryExecutiveUser> deliveryEx;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<ServiceStation>(context, listen: false)
          .getDeliveryExecutives();
      setState(() {
        _isLoading = false;
      });
      var actualdeliveryEx =
          Provider.of<ServiceStation>(context, listen: false).item2;
      deliveryEx = [actualdeliveryEx[0]];
      if (actualdeliveryEx.length != 0) {
        for (int i = 1; i < actualdeliveryEx.length; i++) {
          var duplicate = deliveryEx.indexWhere(
              (user) => user.userName == actualdeliveryEx[i].userName);
          if (duplicate == -1) {
            deliveryEx.add(actualdeliveryEx[i]);
          }
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm(ServiceOrderItem order) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ServiceOrders>(context, listen: false)
          .assignDeliveryExecutive(order, _userName, _id);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (error) {}
  }

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

  void _openMap(ServiceOrderItem order) async {
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

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context).settings.arguments as ServiceOrderItem;

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 5),
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
                                          color:
                                              Color.fromRGBO(128, 128, 128, 1),
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
                          SizedBox(height: 4),
                          Row(
                            children: <Widget>[
                              Text(
                                'Del. Ex:',
                                style: GoogleFonts.cantataOne(
                                  color: Color.fromRGBO(128, 128, 128, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                order.deName == null
                                    ? 'Not assigned'
                                    : order.deName,
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
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 5),
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
                                          color:
                                              Color.fromRGBO(128, 128, 128, 1),
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
                          SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              Text(
                                'Del. Ex:',
                                style: GoogleFonts.cantataOne(
                                  color: Color.fromRGBO(128, 128, 128, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                order.deName,
                                style: GoogleFonts.cantataOne(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Delivery Executive Name',
                            style: TextStyle(
                              color: Color.fromRGBO(112, 112, 112, 1),
                            ),
                          ),
                          Form(
                            key: _form,
                            child: DropdownButtonFormField(
                              items: deliveryEx.map<DropdownMenuItem>((ex) {
                                return DropdownMenuItem<String>(
                                  child: Text(
                                    ex.userName,
                                    textAlign: TextAlign.left,
                                  ),
                                  value: ex.userName,
                                );
                              }).toList(),
                              onChanged: (value) {
                                _userName = value;
                              },
                              onSaved: (value) {
                                _userName = value;
                                _id = Provider.of<ServiceStation>(context,
                                        listen: false)
                                    .item2
                                    .firstWhere((ex) => ex.userName == value)
                                    .id;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: RaisedButton(
                        onPressed: () => _saveForm(order),
                        child: Text(
                          'DONE',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.deepOrange,
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
