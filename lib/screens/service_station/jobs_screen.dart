import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../widgets/service_jobs_dialog.dart';
import '../../providers/service_orders.dart';
import '../../widgets/job_item.dart';
import '../../widgets/job_form.dart';
import '../../models/job.dart';

class JobsScreen extends StatefulWidget {
  static const routeName = '/service-jobs';

  @override
  _JobsScreenState createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  var _isInit = true;
  var _isLoading = false;
  List<JobForm> jobs = [];
  var recommendedJobs;

  Future<void> _openDialog() {
    return showDialog(
      context: context,
      builder: (ctx) => ServiceJobsDialog(jobs),
    );
  }

  void _sendJobs(ServiceOrderItem order) async {
    List<Job> approvedForm = [];
    for (int i = 0; i < jobs.length; i++) {
      if (jobs[i].job.approved) {
        approvedForm.add(jobs[i].job);
      }
    }
    if (approvedForm.length != 0) {
      var _data = [];
      for (int i = 0; i < approvedForm.length; i++) {
        _data.add({
          'part_name': approvedForm[i].name,
          'part_cost': approvedForm[i].price
        });
      }
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ServiceOrders>(context, listen: false)
          .addjob(order.bookingId, approvedForm.length, _data);
      Navigator.of(context).pop();
    }
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final order =
          ModalRoute.of(context).settings.arguments as ServiceOrderItem;
      await Provider.of<ServiceOrders>(context, listen: false).getpartname();
      await Provider.of<ServiceOrders>(context, listen: false)
          .getjobs(order.bookingId);
      await Provider.of<ServiceOrders>(context, listen: false).getservices(
          (ModalRoute.of(context).settings.arguments as ServiceOrderItem)
              .bookingId);
      recommendedJobs = Provider.of<ServiceOrders>(context, listen: false).jobs;
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context).settings.arguments as ServiceOrderItem;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          order.customer,
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
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Brand: ',
                              style: GoogleFonts.cantataOne(
                                color: Color.fromRGBO(128, 128, 128, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              order.make,
                              style: GoogleFonts.cantataOne(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Text(
                              'Model: ',
                              style: GoogleFonts.cantataOne(
                                color: Color.fromRGBO(128, 128, 128, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              order.model,
                              style: GoogleFonts.cantataOne(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Text(
                              'Pickup Time: ',
                              style: GoogleFonts.cantataOne(
                                color: Color.fromRGBO(128, 128, 128, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              order.time,
                              style: GoogleFonts.cantataOne(
                                color: Colors.grey,
                              ),
                            )
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
                        Divider(
                          thickness: 2,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Booked Services',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Color.fromRGBO(100, 100, 100, 1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) => JobItem(
                              Provider.of<ServiceOrders>(context, listen: false)
                                  .services[i]),
                          itemCount:
                              Provider.of<ServiceOrders>(context, listen: false)
                                  .services
                                  .length,
                        ),
                        Text(
                          'Additional Services',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Color.fromRGBO(100, 100, 100, 1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        jobs.length > 0 || recommendedJobs.length > 0
                            ? Column(
                                children: <Widget>[
                                  recommendedJobs.length != 0
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (ctx, i) => ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 0),
                                            title: Text(
                                              recommendedJobs[i].name,
                                              style: GoogleFonts.cantataOne(
                                                color: Color.fromRGBO(
                                                    112, 112, 112, 1),
                                              ),
                                            ),
                                            trailing: Container(
                                              width: 100,
                                              height: 20,
                                              child: Text(
                                                '₹ ${recommendedJobs[i].cost}',
                                                style: GoogleFonts.cantataOne(
                                                  color: Color.fromRGBO(
                                                      112, 112, 112, 1),
                                                ),
                                              ),
                                            ),
                                          ),
                                          itemCount: recommendedJobs.length,
                                        )
                                      : Container(),
                                  jobs.length != 0
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (ctx, i) => ListTile(
                                            contentPadding: EdgeInsets.all(0),
                                            title: Text(
                                              jobs[i].job.name,
                                              style: GoogleFonts.cantataOne(
                                                color: Color.fromRGBO(
                                                    112, 112, 112, 1),
                                              ),
                                            ),
                                            trailing: Container(
                                              width: 104,
                                              height: 20,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    '₹ ${jobs[i].job.price}',
                                                    style:
                                                        GoogleFonts.cantataOne(
                                                      color: Color.fromRGBO(
                                                          112, 112, 112, 1),
                                                    ),
                                                  ),
                                                  Checkbox(
                                                    value: jobs[i].job.approved,
                                                    onChanged: (checked) {
                                                      setState(() {
                                                        jobs[i].job.approved =
                                                            checked;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          itemCount: jobs.length,
                                        )
                                      : Container(),
                                ],
                              )
                            : SizedBox(
                                height: 75,
                                child: Center(
                                  child: Text(
                                    'Please add some jobs',
                                    style: GoogleFonts.cantataOne(
                                      color: Color.fromRGBO(150, 150, 150, 1),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 45,
                          child: RaisedButton(
                            child: Text(
                              'Send',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () => _sendJobs(order),
                            color: Colors.deepOrange,
                            elevation: 0,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 45,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.deepOrange),
                              ),
                              child: RaisedButton(
                                child: Text(
                                  'Add Job',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                                onPressed: _openDialog,
                                color: Colors.white,
                                elevation: 0,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 45,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.deepOrange),
                              ),
                              child: RaisedButton(
                                child: Text(
                                  'Remove Selected',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (jobs.length != 0) {
                                      for (int i = 0; i < jobs.length; i++) {
                                        jobs[i].job.approved = false;
                                      }
                                    }
                                  });
                                },
                                color: Colors.white,
                                elevation: 0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
