import 'package:flutter/material.dart';

class PartnerDetailsScreen extends StatelessWidget {
  static const routeName = '/service-partner-details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Protto Partner Details',
          style: TextStyle(
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ExpansionTile(
              title: Text('Aadhar'),
              children: <Widget>[
                Container(),
              ],
            ),
            ExpansionTile(
              title: Text('Contract'),
              children: <Widget>[
                Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
