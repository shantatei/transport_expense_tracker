import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var form = GlobalKey<FormState>();

  String? purpose;

  String? mode;

  double? cost;

  DateTime? travelDate;

  void saveForm() {
    bool isValid = form.currentState!.validate();
    if (travelDate == null) travelDate = DateTime.now();

    if (isValid) {
      form.currentState!.save();
      print(purpose);
      print(mode);
      print(cost!.toStringAsFixed(2));

      // Hide the keyboard
      FocusScope.of(context).unfocus();

      // Resets the form
      form.currentState!.reset();
      travelDate = null;

      // Shows a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Travel expense added successfully!'),));
    }
  }

  void presentDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 14)),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;
      setState(() {
        travelDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transport Expenses Tracker'),
        actions: [IconButton(onPressed: saveForm, icon: Icon(Icons.save))],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: form,
          child: Column(
            children: [
              DropdownButtonFormField(
                decoration: InputDecoration(
                  label: Text('Mode of Transport'),
                ),
                items: [
                  DropdownMenuItem(child: Text('Bus'), value: 'bus'),
                  DropdownMenuItem(child: Text('Grab'), value: 'grab'),
                  DropdownMenuItem(child: Text('MRT'), value: 'mrt'),
                  DropdownMenuItem(child: Text('Taxi'), value: 'taxi'),
                ],
                validator: (value) {
                  if (value == null)
                    return "Please provide a mode of transport";
                  else
                    return null;
                },
                onChanged: (value) {
                  mode = value as String;
                },
              ),
              TextFormField(
                decoration: InputDecoration(label: Text('Cost')),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null)
                    return "Please provide a travel cost.";
                  else if (double.tryParse(value) == null)
                    return "Please provide a valid travel cost.";
                  else
                    return null;
                },
                onSaved: (value) {
                  cost = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(label: Text('Purpose')),
                validator: (value) {
                  if (value == null)
                    return 'Please provide a purpose.';
                  else if (value.length < 5)
                    return 'Please enter a description that is at least 5 characters.';
                  else
                    return null;
                },
                onSaved: (value) {
                  purpose = value;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(travelDate == null ? 'No Date Chosen': "Picked date: " + DateFormat('dd/MM/yyyy').format(travelDate!)),
                  TextButton(
                      child: Text('Choose Date',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () { presentDatePicker(context); })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
