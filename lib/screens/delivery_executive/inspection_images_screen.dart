import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/delivery_orders.dart';
import '../../models/http_exception.dart';

class InspectionImagesScreen extends StatefulWidget {
  static const routeName = '/inspection-images';

  @override
  _InspectionImagesScreenState createState() => _InspectionImagesScreenState();
}

class _InspectionImagesScreenState extends State<InspectionImagesScreen> {
  var _isLoading = true;
  var status;
  List<File> preImgs = [];
  List<File> postImgs = [];
  List<String> preImgUrl = [];
  List<String> postImgUrl = [];
  var _isInit = true;
  var isPreFuelSet = false;
  var isPostFuelSet = false;
  var isPreOdometerSet = false;
  var isPostOdometerSet = false;
  var prerating = 0.0;
  var postrating = 0.0;
  var preOdometer = TextEditingController();
  var postOdometer = TextEditingController();

  void _savePage(BuildContext context, String bookingId) async {
    try {
      if (status != '7') {
        if (preOdometer.text.isEmpty || preImgUrl.length != 6) {
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('There should be 6 images and an odometer reading'),
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
        } else {
          setState(() {
            _isLoading = true;
          });
          await Provider.of<DeliveryOrders>(context, listen: false)
              .incrementstatus(bookingId, '1',
                  'Inspection images cannot be uploaded right now');
          await Provider.of<DeliveryOrders>(context, listen: false)
              .addpreimages(bookingId, preImgUrl, preOdometer.text, prerating);
          Navigator.of(context).pop();
        }
      } else {
        if (postOdometer.text.isEmpty || postImgUrl.length != 6) {
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('There should be 6 images and an odometer reading'),
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
        } else {
          setState(() {
            _isLoading = true;
          });
          await Provider.of<DeliveryOrders>(context, listen: false)
              .incrementstatus(bookingId, '7',
                  'Inspection images cannot be uploaded right now');
          await Provider.of<DeliveryOrders>(context, listen: false)
              .addpostimages(
            bookingId,
            postImgUrl,
            postOdometer.text,
            postrating,
          );
          Navigator.of(context).pop();
        }
      }
    } on HttpException catch (error) {
      await showDialog(
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
      Navigator.of(context).pop();
    }
  }

  Future<void> _showPopup(String text, String image) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            text,
            textAlign: TextAlign.center,
          ),
          content: Container(
            child: Image.asset(
              image,
              fit: BoxFit.fill,
              width: 100,
              height: 120,
            ),
          ),
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

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      status = await Provider.of<DeliveryOrders>(context, listen: false)
          .fetchBooking(
              (ModalRoute.of(context).settings.arguments as DeliveryOrderItem)
                  .bookingId);
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
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
          : RefreshIndicator(
              onRefresh: () async {
                preImgUrl = [];
                postImgUrl = [];
                preImgs = [];
                postImgs = [];
                setState(() {});
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
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
                              Expanded(
                                flex: 1,
                                child: Text(
                                  order.customer,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.deepOrange,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${order.make}',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      '${order.model}',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
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
                    status == '1'
                        ? Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 38, vertical: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      onPressed: () async {
                                        if (preImgs.length == 6) {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                title: Text(
                                                    'No more than 6 images can be clicked!'),
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
                                        } else {
                                          var text = '';
                                          var image = '';
                                          switch (preImgs.length) {
                                            case 0:
                                              text = 'Front pic';
                                              image = 'assets/images/front.png';
                                              break;
                                            case 1:
                                              text = 'Left pic';
                                              image = 'assets/images/left.png';
                                              break;
                                            case 2:
                                              text = 'Rear pic';
                                              image = 'assets/images/rear.png';
                                              break;
                                            case 3:
                                              text = 'Right pic';
                                              image = 'assets/images/right.png';
                                              break;
                                            case 4:
                                              text = 'Dashboard pic';
                                              image =
                                                  'assets/images/dashboard.png';
                                              break;
                                            case 5:
                                              text = 'Number plate pic';
                                              image =
                                                  'assets/images/number_plate.png';
                                              break;
                                          }
                                          await _showPopup(text, image);
                                          var imgFile =
                                              await ImagePicker.pickImage(
                                            source: ImageSource.camera,
                                            // maxHeight: 640,
                                            // maxWidth: 640,
                                            imageQuality: 25,
                                          );
                                          if (imgFile == null) {
                                            return;
                                          }
                                          setState(() {
                                            preImgs.add(imgFile);
                                            preImgUrl.add(base64Encode(
                                                imgFile.readAsBytesSync()));
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                preImgs.isEmpty
                                    ? Container()
                                    : GridView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 1,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5,
                                        ),
                                        children: List.generate(
                                          preImgs.length,
                                          (index) {
                                            return Container(
                                              child: Image.file(
                                                preImgs[index],
                                                fit: BoxFit.cover,
                                                height: 300,
                                                width: 300,
                                              ),
                                            );
                                          },
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
                                          color:
                                              Color.fromRGBO(112, 112, 112, 1),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      isPreOdometerSet
                                          ? Expanded(
                                              child: TextField(
                                                controller: preOdometer,
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            )
                                          : FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  isPreOdometerSet = true;
                                                });
                                              },
                                              child: Text(
                                                'Add',
                                                style: TextStyle(
                                                    color: Colors.deepOrange),
                                              ),
                                            )
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
                                          color:
                                              Color.fromRGBO(112, 112, 112, 1),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      isPreFuelSet
                                          ? Slider(
                                              value: prerating,
                                              onChanged: (newRating) {
                                                setState(() {
                                                  prerating = newRating;
                                                });
                                              },
                                              divisions: 10,
                                              label: '$prerating',
                                              min: 0,
                                              max: 10,
                                            )
                                          : FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  isPreFuelSet = true;
                                                });
                                              },
                                              child: Text(
                                                'Add',
                                                style: TextStyle(
                                                    color: Colors.deepOrange),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    status == '7'
                        ? Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 38, vertical: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      onPressed: () async {
                                        if (postImgs.length == 6) {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                title: Text(
                                                    'No more than 6 images can be clicked!'),
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
                                        } else {
                                          var text = '';
                                          var image = '';
                                          switch (postImgs.length) {
                                            case 0:
                                              text = 'Front pic';
                                              image = 'assets/images/front.png';
                                              break;
                                            case 1:
                                              text = 'Left pic';
                                              image = 'assets/images/left.png';
                                              break;
                                            case 2:
                                              text = 'Rear pic';
                                              image = 'assets/images/rear.png';
                                              break;
                                            case 3:
                                              text = 'Right pic';
                                              image = 'assets/images/right.png';
                                              break;
                                            case 4:
                                              text = 'Dashboard pic';
                                              image =
                                                  'assets/images/dashboard.png';
                                              break;
                                            case 5:
                                              text = 'Number plate pic';
                                              image =
                                                  'assets/images/number_plate.png';
                                              break;
                                          }
                                          await _showPopup(text, image);
                                          var imgFile =
                                              await ImagePicker.pickImage(
                                            source: ImageSource.camera,
                                            imageQuality: 25,
                                          );
                                          if (imgFile == null) {
                                            return;
                                          }
                                          setState(() {
                                            postImgs.add(imgFile);
                                            postImgUrl.add(base64Encode(
                                                imgFile.readAsBytesSync()));
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                postImgs.isEmpty
                                    ? Container()
                                    : GridView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 1,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5,
                                        ),
                                        children: List.generate(
                                          postImgs.length,
                                          (index) {
                                            return Container(
                                              child: Image.file(
                                                postImgs[index],
                                                fit: BoxFit.cover,
                                                height: 300,
                                                width: 300,
                                              ),
                                            );
                                          },
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
                                          color:
                                              Color.fromRGBO(112, 112, 112, 1),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      isPostOdometerSet
                                          ? Expanded(
                                              child: TextField(
                                                controller: postOdometer,
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            )
                                          : FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  isPostOdometerSet = true;
                                                });
                                              },
                                              child: Text(
                                                'Add',
                                                style: TextStyle(
                                                    color: Colors.deepOrange),
                                              ),
                                            )
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
                                          color:
                                              Color.fromRGBO(112, 112, 112, 1),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      isPostFuelSet
                                          ? Slider(
                                              value: postrating,
                                              onChanged: (newRating) {
                                                setState(() {
                                                  postrating = newRating;
                                                });
                                              },
                                              divisions: 10,
                                              label: '$postrating',
                                              min: 0,
                                              max: 10,
                                            )
                                          : FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  isPostFuelSet = true;
                                                });
                                              },
                                              child: Text(
                                                'Add',
                                                style: TextStyle(
                                                    color: Colors.deepOrange),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
    );
  }
}
