import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/service_station.dart';
import '../screens/service_station/edit_deliveryex_screen.dart';

class DeliveryExecutiveItem extends StatelessWidget {
  String _getStatus(DeliveryExecutiveUser deliveryEx) {
    if (deliveryEx.status == '1' ||
        deliveryEx.status == '2' ||
        deliveryEx.status == '3') {
      return 'Picking up bike from customer';
    } else if (deliveryEx.status == '4') {
      return 'Dropped at station';
    } else if (deliveryEx.status == '5') {
      return 'Service Started';
    } else if (deliveryEx.status == '6' ||
        deliveryEx.status == '7' ||
        deliveryEx.status == '8') {
      return 'Service done';
    } else {
      return 'Available';
    }
  }

  @override
  Widget build(BuildContext context) {
    final deliveryEx = Provider.of<DeliveryExecutiveUser>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
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
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      deliveryEx.userName,
                      style: GoogleFonts.montserrat(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Assigned Booking: ',
                              style: GoogleFonts.cantataOne(
                                color: Color.fromRGBO(128, 128, 128, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: deliveryEx.assigned
                                  ? '${deliveryEx.customer} - ${deliveryEx.make} ${deliveryEx.model}'
                                  : 'Not assigned',
                              style: GoogleFonts.cantataOne(
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    Container(
                      width: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Status: ',
                              style: GoogleFonts.cantataOne(
                                color: Color.fromRGBO(128, 128, 128, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: _getStatus(deliveryEx),
                              style: GoogleFonts.cantataOne(
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            EditDeliveryexScreen.routeName,
                            arguments: deliveryEx.id,
                          );
                        },
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.phone,
                          color: Colors.grey,
                        ),
                        onTap: () {},
                      ),
                    ],
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
