import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../models/job.dart';
import '../providers/service_orders.dart';

class JobForm extends StatefulWidget {
  final Job job;
  final state = _JobFormState();

  JobForm({Key key, this.job}) : super(key: key);
  @override
  _JobFormState createState() => state;
  bool isValid() => state.validate() && job.name != null;
}

class _JobFormState extends State<JobForm> {
  final _form = GlobalKey<FormState>();

  bool validate() {
    var valid = _form.currentState.validate();
    if (valid) {
      _form.currentState.save();
    }
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          // DropdownButtonFormField(
          //   isExpanded: true,
          //   decoration: InputDecoration(labelText: 'Job Name'),
          //   items: Provider.of<ServiceOrders>(context, listen: false)
          //       .partNames
          //       .map<DropdownMenuItem>((value) {
          //     return DropdownMenuItem<String>(
          //       child: Text(value),
          //       value: value,
          //     );
          //   }).toList(),
          //   onChanged: (_) {},
          //   onSaved: (value) {
          //     widget.job.name = value;
          //   },
          //   validator: (value) {
          //     if (value == null) {
          //       return 'Please enter a job name';
          //     }
          //     return null;
          //   },
          // ),
          SearchableDropdown.single(
            isExpanded: true,
            items: Provider.of<ServiceOrders>(context, listen: false)
                .partNames
                .map<DropdownMenuItem>((value) {
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
            validator: (value) {
              if (value == null) {
                return 'Please enter a job name';
              }
              return null;
            },
            value: widget.job.name,
            hint: "Job Name",
            searchHint: "Select one",
            onChanged: (value) {
              setState(() {
                widget.job.name = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Job Price'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please provide a price';
              }
              return null;
            },
            onSaved: (value) {
              widget.job.price = value;
            },
          ),
        ],
      ),
    );
  }
}
