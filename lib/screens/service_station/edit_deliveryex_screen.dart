import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/service_station.dart';

class EditDeliveryexScreen extends StatefulWidget {
  static const routeName = '/service-edit-delivery-ex';

  @override
  _EditDeliveryexScreenState createState() => _EditDeliveryexScreenState();
}

class _EditDeliveryexScreenState extends State<EditDeliveryexScreen> {
  final _form = GlobalKey<FormState>();
  final _focus1 = FocusNode();
  final _focus2 = FocusNode();
  final _focus3 = FocusNode();
  final _focus4 = FocusNode();
  final _focus5 = FocusNode();
  var _editedExecutive;

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final executiveId = ModalRoute.of(context).settings.arguments as String;
      _editedExecutive = DeliveryExecutiveUser(
        id: null,
        name: '',
        userName: '',
        mobile: '',
        aadhar: '',
        password: '',
        assigned: false,
        status: '9',
      );
      if (executiveId != null) {
        _editedExecutive =
            Provider.of<ServiceStation>(context).findById(executiveId);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    if (_editedExecutive.id != null) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ServiceStation>(context, listen: false)
          .updateExecutive(_editedExecutive.id, _editedExecutive);
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ServiceStation>(context, listen: false)
          .addExecutive(_editedExecutive);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Delivery Ex Name',
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.all(24),
              width: double.infinity,
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    Text(
                      'Contact Info',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextFormField(
                      initialValue: _editedExecutive.name,
                      decoration: InputDecoration(labelText: 'Name'),
                      focusNode: _focus1,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_focus2);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedExecutive = DeliveryExecutiveUser(
                          name: value,
                          id: _editedExecutive.id,
                          userName: _editedExecutive.userName,
                          mobile: _editedExecutive.mobile,
                          aadhar: _editedExecutive.aadhar,
                          password: _editedExecutive.password,
                          assigned: _editedExecutive.assigned,
                          status: _editedExecutive.status,
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      initialValue: _editedExecutive.mobile,
                      decoration: InputDecoration(labelText: 'Mobile No.'),
                      focusNode: _focus2,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_focus3);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a mobile number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedExecutive = DeliveryExecutiveUser(
                          name: _editedExecutive.name,
                          id: _editedExecutive.id,
                          userName: _editedExecutive.userName,
                          mobile: value,
                          aadhar: _editedExecutive.aadhar,
                          password: _editedExecutive.password,
                          assigned: _editedExecutive.assigned,
                          status: _editedExecutive.status,
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      initialValue: _editedExecutive.aadhar,
                      decoration: InputDecoration(labelText: 'Aadhar Card No.'),
                      focusNode: _focus3,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_focus4);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide an aadhar number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedExecutive = DeliveryExecutiveUser(
                          name: _editedExecutive.name,
                          id: _editedExecutive.id,
                          userName: _editedExecutive.userName,
                          mobile: _editedExecutive.mobile,
                          aadhar: value,
                          password: _editedExecutive.password,
                          assigned: _editedExecutive.assigned,
                          status: _editedExecutive.status,
                        );
                      },
                    ),
                    SizedBox(height: 40),
                    Text(
                      'App Sign In Info',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextFormField(
                      initialValue: _editedExecutive.userName == null
                          ? ''
                          : _editedExecutive.userName,
                      decoration: InputDecoration(labelText: 'Username'),
                      focusNode: _focus4,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_focus5);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedExecutive = DeliveryExecutiveUser(
                          name: _editedExecutive.name,
                          id: _editedExecutive.id,
                          mobile: _editedExecutive.mobile,
                          aadhar: _editedExecutive.aadhar,
                          userName: value,
                          password: _editedExecutive.password,
                          assigned: _editedExecutive.assigned,
                          status: _editedExecutive.status,
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      initialValue: _editedExecutive.password,
                      decoration: InputDecoration(labelText: 'Password'),
                      focusNode: _focus5,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedExecutive = DeliveryExecutiveUser(
                          name: _editedExecutive.name,
                          id: _editedExecutive.id,
                          mobile: _editedExecutive.mobile,
                          aadhar: _editedExecutive.aadhar,
                          userName: _editedExecutive.userName,
                          password: value,
                          assigned: _editedExecutive.assigned,
                          status: _editedExecutive.status,
                        );
                      },
                    ),
                    SizedBox(height: 75),
                    Container(
                      width: double.infinity,
                      height: 45,
                      child: RaisedButton(
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _saveForm,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
