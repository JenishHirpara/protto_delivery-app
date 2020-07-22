import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/service_active_order_detail.dart';
import '../../providers/service_orders.dart';

class BookingsScreen extends StatefulWidget {
  static const routeName = '/service-bookings';

  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  var _isInit = true;
  var _isLoading = true;

  Future<void> _refreshPage() async {
    await Provider.of<ServiceOrders>(context, listen: false)
        .fetchAndSetOrders();
    setState(() {});
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<ServiceOrders>(context, listen: false)
          .fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<ServiceOrders>(context, listen: false).items;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Service Bookings',
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
          : RefreshIndicator(
              onRefresh: _refreshPage,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(12),
                  child: Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) => Column(
                        children: <Widget>[
                          ChangeNotifierProvider.value(
                            value: orders[i],
                            child: ServiceActiveOrderDetail(),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                      itemCount: orders.length,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
