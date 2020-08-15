import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';

import '../../providers/delivery_orders.dart';

class DisplayInspectionImagesScreen extends StatefulWidget {
  static const routeName = '/display-inspection-images';

  @override
  _DisplayInspectionImagesScreenState createState() =>
      _DisplayInspectionImagesScreenState();
}

class _DisplayInspectionImagesScreenState
    extends State<DisplayInspectionImagesScreen> {
  var _isLoading = true;
  var _isInit = true;
  List<String> preImgUrl = [];
  List<String> postImgUrl = [];
  var getPreOdometer;
  var getPostOdometer;
  var getPreFuel;
  var getPostFuel;

  List<String> _names = [
    'Front',
    'Left',
    'Rear',
    'Right',
    'Dash-\nBoard',
    'No.Plate'
  ];

  void _showDialog(int index, String number) {
    showDialog(
      context: context,
      builder: (ctx) {
        return PhotoView.customChild(
          onTapUp: (_, __, ___) {
            Navigator.of(ctx).pop();
          },
          child: number == '1'
              ? Image.memory(
                  Base64Decoder().convert(preImgUrl[index]),
                  fit: BoxFit.cover,
                )
              : Image.memory(
                  Base64Decoder().convert(postImgUrl[index]),
                  fit: BoxFit.cover,
                ),
          childSize: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.5),
          backgroundDecoration: BoxDecoration(),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
          tightMode: true,
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
      print(getPostFuel);
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: Row(
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
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 2,
                    indent: 16,
                    endIndent: 16,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36),
                    child: Text(
                      'Pre Service Inspection',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color.fromRGBO(112, 112, 112, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  preImgUrl.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(horizontal: 38, vertical: 0),
                          child: GridView(
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
                                  child: InkWell(
                                    child: GridTile(
                                      footer: GridTileBar(
                                        backgroundColor:
                                            Color.fromRGBO(220, 220, 220, 0.4),
                                        title: Text(
                                          _names[index],
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      child: Image.memory(
                                        Base64Decoder()
                                            .convert(preImgUrl[index]),
                                        fit: BoxFit.cover,
                                        height: 300,
                                        width: 300,
                                      ),
                                    ),
                                    onTap: () => _showDialog(index, '1'),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 40,
                    margin: EdgeInsets.symmetric(horizontal: 36, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    color: Color.fromRGBO(240, 240, 240, 1),
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
                            ? Text(
                                'not set',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
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
                  Container(
                    width: double.infinity,
                    height: 40,
                    margin: EdgeInsets.symmetric(horizontal: 36, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    color: Color.fromRGBO(240, 240, 240, 1),
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
                            ? Text(
                                'not set',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
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
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36),
                    child: Text(
                      'Pre Delivery Inspection',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color.fromRGBO(112, 112, 112, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  postImgUrl.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(horizontal: 38, vertical: 0),
                          child: GridView(
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
                                  child: InkWell(
                                    child: GridTile(
                                      footer: GridTileBar(
                                        backgroundColor:
                                            Color.fromRGBO(220, 220, 220, 0.4),
                                        title: Text(
                                          _names[index],
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      child: Image.memory(
                                        Base64Decoder()
                                            .convert(postImgUrl[index]),
                                        fit: BoxFit.cover,
                                        height: 300,
                                        width: 300,
                                      ),
                                    ),
                                    onTap: () => _showDialog(index, '2'),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 40,
                    margin: EdgeInsets.symmetric(horizontal: 36, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    color: Color.fromRGBO(240, 240, 240, 1),
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
                            ? Text(
                                'not set',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
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
                  Container(
                    width: double.infinity,
                    height: 40,
                    margin: EdgeInsets.symmetric(horizontal: 36, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    color: Color.fromRGBO(240, 240, 240, 1),
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
                            ? Text(
                                'not set',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
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
                ],
              ),
            ),
    );
  }
}
