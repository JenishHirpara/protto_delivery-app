import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
  List<File> preImgs = [];
  List<File> postImgs = [];
  List<String> preImgUrl = [];
  List<String> postImgUrl = [];
  List<String> preImgPathName = [];
  List<String> postImgPathName = [];
  var _isInit = true;
  var isPreFuelSet = false;
  var isPostFuelSet = false;
  var isPreOdometerSet = false;
  var isPostOdometerSet = false;
  var prerating = 0.0;
  var postrating = 0.0;
  var preOdometer = TextEditingController();
  var postOdometer = TextEditingController();
  var getPreOdometer;
  var getPostOdometer;
  var getPreFuel;
  var getPostFuel;

  void _savePage(BuildContext context, String bookingId) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (Provider.of<DeliveryOrders>(context, listen: false)
          .preImages
          .isEmpty) {
        await Provider.of<DeliveryOrders>(context, listen: false)
            .incrementstatus(bookingId, '1');
        await Provider.of<DeliveryOrders>(context, listen: false).addpreimages(
            bookingId, preImgUrl, preOdometer.text, prerating, preImgPathName);
        Navigator.of(context).pop();
      } else {
        await Provider.of<DeliveryOrders>(context, listen: false)
            .incrementstatus(bookingId, '6');
        await Provider.of<DeliveryOrders>(context, listen: false).addpostimages(
            bookingId, postImgUrl, postOdometer.text, postrating);
        Navigator.of(context).pop();
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

  Future<void> _showPopup(String text) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(text),
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
      await Provider.of<DeliveryOrders>(context, listen: false).getpreimages(
          (ModalRoute.of(context).settings.arguments as DeliveryOrderItem)
              .bookingId);
      await Provider.of<DeliveryOrders>(context, listen: false).getpostimages(
          (ModalRoute.of(context).settings.arguments as DeliveryOrderItem)
              .bookingId);
      setState(() {
        _isLoading = false;
      });
      preImgUrl = Provider.of<DeliveryOrders>(context, listen: false).preImages;
      postImgUrl =
          Provider.of<DeliveryOrders>(context, listen: false).postImages;
      getPreOdometer = Provider.of<DeliveryOrders>(context, listen: false)
          .preOdometerReading;
      getPostOdometer = Provider.of<DeliveryOrders>(context, listen: false)
          .postOdometerReading;
      getPreFuel =
          Provider.of<DeliveryOrders>(context, listen: false).preFuelLevel;
      getPostFuel =
          Provider.of<DeliveryOrders>(context, listen: false).postFuelLevel;
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
                            Provider.of<DeliveryOrders>(context, listen: false)
                                    .preImages
                                    .isNotEmpty
                                ? Container()
                                : IconButton(
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
                                        switch (preImgs.length) {
                                          case 0:
                                            text = 'Front pic';
                                            break;
                                          case 1:
                                            text = 'Left pic';
                                            break;
                                          case 2:
                                            text = 'Rear pic';
                                            break;
                                          case 3:
                                            text = 'Right pic';
                                            break;
                                          case 4:
                                            text = 'Dashboard pic';
                                            break;
                                          case 5:
                                            text = 'Number plate pic';
                                            break;
                                        }
                                        await _showPopup(text);
                                        var imgFile =
                                            await ImagePicker.pickImage(
                                          source: ImageSource.camera,
                                          // maxHeight: 640,
                                          // maxWidth: 640,
                                          imageQuality: 30,
                                        );
                                        if (imgFile == null) {
                                          return;
                                        }
                                        setState(() {
                                          preImgs.add(imgFile);
                                          preImgUrl.add(base64Encode(
                                              imgFile.readAsBytesSync()));
                                          preImgPathName.add(
                                              imgFile.path.split('/').last);
                                        });
                                      }
                                    },
                                  ),
                          ],
                        ),
                        preImgUrl.isNotEmpty
                            ? GridView(
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
                                  preImgUrl.length,
                                  (index) {
                                    return Container(
                                      child: Image.memory(
                                        Base64Decoder()
                                            .convert(preImgUrl[index]),
                                        fit: BoxFit.cover,
                                        height: 300,
                                        width: 300,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : preImgs.isEmpty
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
                                  color: Color.fromRGBO(112, 112, 112, 1),
                                ),
                              ),
                              SizedBox(width: 15),
                              getPreOdometer == null
                                  ? isPreOdometerSet
                                      ? Expanded(
                                          child: TextField(
                                            controller: preOdometer,
                                            keyboardType: TextInputType.number,
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
                                  : Text(
                                      getPreOdometer,
                                      style: GoogleFonts.cantataOne(
                                        color: Color.fromRGBO(112, 112, 112, 1),
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
                              getPreFuel == null
                                  ? isPreFuelSet
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
                                  : Text(
                                      getPreFuel,
                                      style: GoogleFonts.cantataOne(
                                        color: Color.fromRGBO(112, 112, 112, 1),
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
                            Provider.of<DeliveryOrders>(context, listen: false)
                                    .postImages
                                    .isNotEmpty
                                ? Container()
                                : IconButton(
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
                                        switch (postImgs.length) {
                                          case 0:
                                            text = 'Front pic';
                                            break;
                                          case 1:
                                            text = 'Left pic';
                                            break;
                                          case 2:
                                            text = 'Rear pic';
                                            break;
                                          case 3:
                                            text = 'Right pic';
                                            break;
                                          case 4:
                                            text = 'Dashboard pic';
                                            break;
                                          case 5:
                                            text = 'Number plate pic';
                                            break;
                                        }
                                        await _showPopup(text);
                                        var imgFile =
                                            await ImagePicker.pickImage(
                                          source: ImageSource.camera,
                                          imageQuality: 30,
                                        );
                                        if (imgFile == null) {
                                          return;
                                        }
                                        setState(() {
                                          postImgs.add(imgFile);
                                          postImgUrl.add(base64Encode(
                                              imgFile.readAsBytesSync()));
                                          postImgPathName.add(
                                              imgFile.path.split('/').last);
                                        });
                                      }
                                    },
                                  ),
                          ],
                        ),
                        postImgUrl.isNotEmpty
                            ? GridView(
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
                                  postImgUrl.length,
                                  (index) {
                                    return Container(
                                      child: Image.memory(
                                        Base64Decoder()
                                            .convert(postImgUrl[index]),
                                        fit: BoxFit.cover,
                                        height: 300,
                                        width: 300,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : postImgs.isEmpty
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
                                  color: Color.fromRGBO(112, 112, 112, 1),
                                ),
                              ),
                              SizedBox(width: 15),
                              getPostOdometer == null
                                  ? isPostOdometerSet
                                      ? Expanded(
                                          child: TextField(
                                            controller: postOdometer,
                                            keyboardType: TextInputType.number,
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
                                  : Text(
                                      getPostOdometer,
                                      style: GoogleFonts.cantataOne(
                                        color: Color.fromRGBO(112, 112, 112, 1),
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
                              getPostFuel == null
                                  ? isPostFuelSet
                                      ? Slider(
                                          value: postrating,
                                          onChanged: (newRating) {
                                            setState(() {
                                              postrating = newRating;
                                            });
                                          },
                                          label: '$postrating',
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
                                  : Text(
                                      getPostFuel,
                                      style: GoogleFonts.cantataOne(
                                        color: Color.fromRGBO(112, 112, 112, 1),
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
