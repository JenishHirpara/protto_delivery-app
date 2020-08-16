import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/delivery_executive.dart';
import 'package:provider/provider.dart';

import '../../providers/delivery_orders.dart';

class DeliveryInfoScreen extends StatefulWidget {
  static const routeName = '/delivery-ex-info';

  @override
  _DeliveryInfoScreenState createState() => _DeliveryInfoScreenState();
}

class _DeliveryInfoScreenState extends State<DeliveryInfoScreen> {
  var _isInit = true;
  var _isLoading = true;
  var dueAmount;
  var status;

  Future<void> _refreshPage() async {
    status = await Provider.of<DeliveryOrders>(context, listen: false)
        .fetchBooking(
            (ModalRoute.of(context).settings.arguments as DeliveryOrderItem)
                .bookingId);
    setState(() {});
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
      dueAmount = double.parse(
              Provider.of<DeliveryOrders>(context, listen: false)
                  .currentTotal) -
          double.parse(
              Provider.of<DeliveryOrders>(context, listen: false).currentPaid);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget _otp(String otp) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshPage,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
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
                            RichText(
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
                                  'Service station: ',
                                  style: GoogleFonts.cantataOne(
                                    color: Color.fromRGBO(128, 128, 128, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  Provider.of<DeliveryExecutive>(context,
                                          listen: false)
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
                            RichText(
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
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      dueAmount == 0.0 && int.parse(status) >= 7
                          ? Text(
                              'Delivery Otp',
                              style: GoogleFonts.montserrat(fontSize: 18),
                            )
                          : Text(
                              'Delivery otp will be generated once the customer pays due amount',
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(128, 128, 128, 1),
                              ),
                              textAlign: TextAlign.center,
                            ),
                      SizedBox(height: 10),
                      dueAmount == 0.0 && int.parse(status) >= 7
                          ? _otp(deliveryOtp)
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
