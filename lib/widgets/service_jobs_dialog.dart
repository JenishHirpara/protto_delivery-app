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
              Text(
                'Add Jobs',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, i) => data[i],
                itemCount: data.length,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 40,
                    child: RaisedButton(
                      child: Text(
                        'Add a job',
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.deepOrange,
                      ),
                    ),
                    child: RaisedButton(
                      child: Text(
                        'Done',
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                      onPressed: () => onSave(),
                      color: Colors.white,
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
