import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../widgets/delivery_executive_item.dart';
import './edit_deliveryex_screen.dart';
import '../../providers/service_station.dart';

class DeliveryExecutivesScreen extends StatefulWidget {
  static const routeName = '/service-delivery-executive';

  @override
  _DeliveryExecutivesScreenState createState() =>
      _DeliveryExecutivesScreenState();
}

class _DeliveryExecutivesScreenState extends State<DeliveryExecutivesScreen> {
  var _isInit = true;
  var _isLoading = true;
  List<DeliveryExecutiveUser> deliveryEx;
  List<DeliveryExecutiveUser> onDutyDeliveryEx;
  List<DeliveryExecutiveUser> availableDeliveryEx;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<ServiceStation>(context, listen: false)
          .getDeliveryExecutives();
      deliveryEx = Provider.of<ServiceStation>(context, listen: false).item2;
      onDutyDeliveryEx = deliveryEx.where((ex) => ex.assigned).toList();
      availableDeliveryEx = deliveryEx.where((ex) => !ex.assigned).toList();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Delivery Executives',
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
        actions: <Widget>[
          FlatButton(
            child: Icon(
              Icons.add,
              color: Colors.deepOrange,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(EditDeliveryexScreen.routeName);
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            child: Text(
                              'On Duty',
                              style: GoogleFonts.montserrat(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, i) =>
                                  ChangeNotifierProvider.value(
                                value: onDutyDeliveryEx[i],
                                child: Column(
                                  children: <Widget>[
                                    DeliveryExecutiveItem(),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              itemCount: onDutyDeliveryEx.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            child: Text(
                              'Available',
                              style: GoogleFonts.montserrat(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, i) =>
                                  ChangeNotifierProvider.value(
                                value: availableDeliveryEx[i],
                                child: Column(
                                  children: <Widget>[
                                    DeliveryExecutiveItem(),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              itemCount: availableDeliveryEx.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
