import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/delivery_orders.dart';
import '../../models/http_exception.dart';

class InspectionImagesScreen extends StatefulWidget {
  static const routeName = '/inspection-images';

  @override
  _InspectionImagesScreenState createState() => _InspectionImagesScreenState();
}

class _InspectionImagesScreenState extends State<InspectionImagesScreen> {
  var _isLoading = false;

  Widget _imageBuilder(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.width * 0.25,
        color: Colors.grey,
      ),
      onTap: () {},
    );
  }

  void _savePage(BuildContext context, String bookingId) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<DeliveryOrders>(context, listen: false)
          .incrementstatus(bookingId, '1');
      Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    final order =
        ModalRoute.of(context).settings.arguments as DeliveryOrderItem;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inspection Images',
          style: GoogleFonts.montserrat(
            color: Colors.deepOrange,
            fontSize: 20,
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
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
              ),
            ),
            onPressed: () => _savePage(context, order.bookingId),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 38, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Pre Service Inspection',
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Color.fromRGBO(112, 112, 112, 1),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: Color.fromRGBO(112, 112, 112, 1),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        GridView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            _imageBuilder(context),
                            _imageBuilder(context),
                            _imageBuilder(context),
                            _imageBuilder(context),
                            _imageBuilder(context),
                            _imageBuilder(context),
                          ],
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 40,
                          color: Color.fromRGBO(240, 240, 240, 1),
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                              FlatButton(
                                onPressed: () {},
                                child: Text(
                                  'Add',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 40,
                          color: Color.fromRGBO(240, 240, 240, 1),
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                              FlatButton(
                                onPressed: () {},
                                child: Text(
                                  'Add',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 38, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Pre Delivery Inspection',
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Color.fromRGBO(112, 112, 112, 1),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: Color.fromRGBO(112, 112, 112, 1),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        GridView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            _imageBuilder(context),
                            _imageBuilder(context),
                            _imageBuilder(context),
                            _imageBuilder(context),
                            _imageBuilder(context),
                            _imageBuilder(context),
                          ],
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 40,
                          color: Color.fromRGBO(240, 240, 240, 1),
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                              FlatButton(
                                onPressed: () {},
                                child: Text(
                                  'Add',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 40,
                          color: Color.fromRGBO(240, 240, 240, 1),
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                              FlatButton(
                                onPressed: () {},
                                child: Text(
                                  'Add',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
