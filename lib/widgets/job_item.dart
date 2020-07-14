import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JobItem extends StatelessWidget {
  final dynamic service;
  JobItem(this.service);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      title: Text(
        service['type'],
        style: GoogleFonts.cantataOne(
          color: Color.fromRGBO(128, 128, 128, 1),
        ),
      ),
      subtitle: Text(
        service['category'],
        style: GoogleFonts.cantataOne(
          color: Color.fromRGBO(150, 150, 150, 1),
        ),
      ),
      trailing: Container(
        width: 100,
        height: 20,
        child: Text(
          '₹ ' + service['offer'],
          style: GoogleFonts.cantataOne(
            color: Color.fromRGBO(128, 128, 128, 1),
          ),
        ),
      ),
    );
  }
}
