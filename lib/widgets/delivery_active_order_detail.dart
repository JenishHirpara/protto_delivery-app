import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

//import '../screens/delivery_executive/menu_screen.dart';
import '../screens/delivery_executive/active_order_screen.dart';
import '../providers/delivery_orders.dart';

class DeliveryActiveOrderDetail extends StatelessWidget {
  final int i;
  DeliveryActiveOrderDetail(this.i);

  String _getStatus(DeliveryOrderItem order) {
    if (order.status == '1' || order.status == '2') {
      return 'Service Confirmed';
    } else if (order.status == '3') {
      return 'Picked Up';
    } else if (order.status == '4') {
      return 'Dropped at station';
    } else if (order.status == '5') {
      return 'Service Started';
    } else if (order.status == '6') {
      return 'Service done';
    } else if (order.status == '7' || order.status == '8') {
      return 'Picked from station';
    } else if (order.status == '9') {
      return 'Delivered';
    } else {
      return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    var order = Provider.of<DeliveryOrders>(context).items[i];
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => ActiveOrderScreen(order)));
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: double.infinity,
            //height: order.landmark != '' ? 260 : 245,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                  offset: Offset(0.0, 5.0), //(x,y)
                  blurRadius: 7.0,
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        bottom: 0,
                        top: 16,
                        right: 0,
                      ),
                      child: Text(
                        '${order.customer}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      width: 55,
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Active',
                          style: TextStyle(
                            fontFamily: 'SourceSansProSB',
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Status:',
                            style: TextStyle(
                              fontFamily: 'SourceSansPro',
                              color: Color.fromRGBO(128, 128, 128, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            _getStatus(order),
                            style: TextStyle(
                              fontFamily: 'SourceSansPro',
                              color: Theme.of(context).primaryColor,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Bike: ',
                                style: GoogleFonts.cantataOne(
                                  color: Color.fromRGBO(128, 128, 128, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: '${order.make} ${order.model}',
                                style: GoogleFonts.cantataOne(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: <Widget>[
                          Text(
                            'Booking ID:',
                            style: GoogleFonts.cantataOne(
                              color: Color.fromRGBO(128, 128, 128, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            order.bookingId,
                            style: GoogleFonts.cantataOne(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: <Widget>[
                          Text(
                            'Pickup Date:',
                            style: GoogleFonts.cantataOne(
                              color: Color.fromRGBO(128, 128, 128, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            order.date,
                            style: GoogleFonts.cantataOne(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: <Widget>[
                          Text(
                            'Pickup Time:',
                            style: GoogleFonts.cantataOne(
                              color: Color.fromRGBO(128, 128, 128, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            order.time,
                            style: GoogleFonts.cantataOne(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'PickupAddress: ',
                                style: GoogleFonts.cantataOne(
                                  color: Color.fromRGBO(128, 128, 128, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: '${order.flat}, ${order.address}',
                                style: GoogleFonts.cantataOne(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
