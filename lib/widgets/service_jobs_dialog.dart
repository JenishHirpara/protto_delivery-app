import 'package:flutter/material.dart';

import './job_form.dart';
import '../models/job.dart';

class ServiceJobsDialog extends StatefulWidget {
  final List<JobForm> jobs;

  ServiceJobsDialog(this.jobs);
  @override
  _ServiceJobsDialogState createState() => _ServiceJobsDialogState();
}

class _ServiceJobsDialogState extends State<ServiceJobsDialog> {
  List<JobForm> data = [];

  void onSave() {
    if (data.length > 0) {
      var allValid = true;
      data.forEach((form) => allValid = allValid && form.isValid());
      if (allValid) {
        widget.jobs.addAll(data);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Add Jobs',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.deepOrange,
                      ),
                    ),
                    child: RaisedButton(
                      child: Text(
                        'DONE',
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                      onPressed: () => onSave(),
                      color: Colors.white,
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              data.length <= 0
                  ? Center(
                      child: Text('Press the add button to add some jobs'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) => data[i],
                      itemCount: data.length,
                    ),
              SizedBox(height: 30),
              Container(
                width: 150,
                child: RaisedButton(
                  child: Text(
                    'ADD',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.deepOrange,
                  onPressed: () {
                    setState(() {
                      var _job = Job();
                      data.add(JobForm(
                        job: _job,
                      ));
                    });
                  },
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
