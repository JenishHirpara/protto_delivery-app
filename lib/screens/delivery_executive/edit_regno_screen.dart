import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/delivery_orders.dart';

class EditRegnoScreen extends StatefulWidget {
  static const routeName = '/edit-regno';

  @override
  _EditRegnoScreenState createState() => _EditRegnoScreenState();
}

class _EditRegnoScreenState extends State<EditRegnoScreen> {
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var dupBikeNumber = TextEditingController();

  void _saveForm(String bikeId, String id) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    await Provider.of<DeliveryOrders>(context, listen: false)
        .editrgno(bikeId, dupBikeNumber.text, id);
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var bikeDetails = ModalRoute.of(context).settings.arguments as List<String>;
    var bikeId = bikeDetails[0];
    var id = bikeDetails[1];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Reg Number',
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 24,
          ),
        ),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(112, 112, 112, 1),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Form(
                  key: _form,
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(20),
                    children: [
                      TextFormField(
                        controller: dupBikeNumber,
                        decoration: InputDecoration(
                          hintText: 'Registration Number',
                          hintStyle: TextStyle(
                            fontFamily: 'SourceSansPro',
                            color: Color.fromRGBO(128, 128, 128, 1),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          filled: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide registration number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 60),
                      Container(
                        //margin: EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        height: 40,
                        child: RaisedButton(
                          onPressed: () => _saveForm(bikeId, id),
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
