import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/delivery_orders.dart';

class PaymentsScreen extends StatefulWidget {
  static const routeName = '/payments';

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  var _isInit = true;
  var _isLoading = true;

  void paidDialog(BuildContext context, DeliveryOrderItem order) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
              'Are you sure you received ₹ ${double.parse(order.total) - double.parse(order.paid)} from the customer?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                var message =
                    await Provider.of<DeliveryOrders>(context, listen: false)
                        .paymentreceived(order.bookingId);
                Navigator.of(ctx).pop();
                if (message == 'payment approved') {
                  showDialog(
                    context: context,
                    builder: (ctx2) {
                      return AlertDialog(
                        title: Text(message),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(ctx2).pop();
                            },
                            child: Text('Okay'),
                          ),
                        ],
                      );
                    },
                  );
                }
                showDialog(
                  context: context,
                  builder: (ctx2) {
                    return AlertDialog(
                      title: Text(message),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(ctx2).pop();
                          },
                          child: Text('Okay'),
                        ),
                      ],
                    );
                  },
                );
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
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<DeliveryOrders>(context, listen: false).fetchBooking(
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
    var total = Provider.of<DeliveryOrders>(context).currentTotal;
    var paid = Provider.of<DeliveryOrders>(context).currentPaid;
    var due = '${double.parse(total) - double.parse(paid)}';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Payments',
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
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    child: ListTile(
                      title: Text(
                        'Amount to be collected:',
                        style: GoogleFonts.montserrat(
                          color: Color.fromRGBO(112, 112, 112, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        '₹ $due',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                    indent: 16,
                    endIndent: 16,
                  ),
                  due == '0.0'
                      ? Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 25,
                            horizontal: 20,
                          ),
                          child: Center(
                            child: Text(
                              'Customer has already paid the amount!',
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(128, 128, 128, 1),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 25,
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Cash on Delivery',
                                style: GoogleFonts.cantataOne(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Please press the paid button if the customer pays cash on delivery.',
                                style: GoogleFonts.cantataOne(
                                  fontSize: 14,
                                  color: Color.fromRGBO(128, 128, 128, 1),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 25),
                              Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: RaisedButton(
                                    color: Colors.white,
                                    child: Text(
                                      'Paid',
                                      style: TextStyle(
                                        fontFamily: 'SourceSansProSB',
                                        fontSize: 15,
                                        color: Color.fromRGBO(112, 112, 112, 1),
                                      ),
                                    ),
                                    onPressed: () => paidDialog(context, order),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  due == '0.0'
                      ? Container()
                      : Divider(
                          color: Colors.black,
                          thickness: 2,
                          indent: 16,
                          endIndent: 16,
                        ),
                  due == '0.0'
                      ? Container()
                      : Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 25,
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Payment Link',
                                style: GoogleFonts.cantataOne(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Send a payment link to the customer.',
                                style: GoogleFonts.cantataOne(
                                  fontSize: 14,
                                  color: Color.fromRGBO(128, 128, 128, 1),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 25),
                              Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: RaisedButton(
                                    color: Colors.white,
                                    child: Text(
                                      'Send Link',
                                      style: TextStyle(
                                        fontFamily: 'SourceSansProSB',
                                        fontSize: 15,
                                        color: Color.fromRGBO(112, 112, 112, 1),
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  due == '0.0'
                      ? Container()
                      : Divider(
                          color: Colors.black,
                          thickness: 2,
                          indent: 16,
                          endIndent: 16,
                        ),
                ],
              ),
            ),
    );
  }
}
