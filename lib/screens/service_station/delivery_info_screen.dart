import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:protto_delivery_ex_app/providers/service_station.dart';
import 'package:provider/provider.dart';

import '../../providers/service_orders.dart';

class DeliveryInfoScreen extends StatefulWidget {
  static const routeName = '/service-delivery-info';

  @override
  _DeliveryInfoScreenState createState() => _DeliveryInfoScreenState();
}

class _DeliveryInfoScreenState extends State<DeliveryInfoScreen> {
  var _isInit = true;
  var _isLoading = true;
  final _form = GlobalKey<FormState>();
  var _userName;
  var _id;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<ServiceStation>(context, listen: false)
          .getDeliveryExecutives();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm(ServiceOrderItem order) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ServiceOrders>(context, listen: false)
          .assignDeliveryExecutive(order, _userName, _id);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context).settings.arguments as ServiceOrderItem;
    final availableDeliveryEx =
        Provider.of<ServiceStation>(context, listen: false)
            .item2
            .where((ex) => !ex.assigned)
            .toList();
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
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 9,
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Address: ',
                                        style: GoogleFonts.cantataOne(
                                          color:
                                              Color.fromRGBO(128, 128, 128, 1),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${order.flat}, ${order.address}',
                                        style: GoogleFonts.cantataOne(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            ],
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
                                'Del. Ex:',
                                style: GoogleFonts.cantataOne(
                                  color: Color.fromRGBO(128, 128, 128, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                order.deName == null
                                    ? 'Not assigned'
                                    : order.deName,
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 9,
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Address: ',
                                        style: GoogleFonts.cantataOne(
                                          color:
                                              Color.fromRGBO(128, 128, 128, 1),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${order.flat}, ${order.address}',
                                        style: GoogleFonts.cantataOne(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: <Widget>[
                              Text(
                                'Del. Ex:',
                                style: GoogleFonts.cantataOne(
                                  color: Color.fromRGBO(128, 128, 128, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                order.deName,
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
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Delivery Executive Name',
                            style: TextStyle(
                              color: Color.fromRGBO(112, 112, 112, 1),
                            ),
                          ),
                          Form(
                            key: _form,
                            child: DropdownButtonFormField(
                              items: availableDeliveryEx
                                  .map<DropdownMenuItem>((ex) {
                                return DropdownMenuItem<String>(
                                    child: Text(
                                      ex.userName,
                                      textAlign: TextAlign.left,
                                    ),
                                    value: ex.userName);
                              }).toList(),
                              onChanged: (value) {
                                _userName = value;
                              },
                              onSaved: (value) {
                                _userName = value;
                                _id = Provider.of<ServiceStation>(context,
                                        listen: false)
                                    .item2
                                    .firstWhere((ex) => ex.userName == value)
                                    .id;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: RaisedButton(
                        onPressed: () => _saveForm(order),
                        child: Text(
                          'DONE',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.deepOrange,
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
