import 'package:flutter/material.dart';
import 'package:transport_expense_tracker/main.dart';
import 'package:transport_expense_tracker/screens/expense_list_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text("Hello Friend!"),
          automaticallyImplyLeading: false,
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () =>
              Navigator.of(context).pushReplacementNamed(MainScreen.routeName),
        ),
        Divider(height: 3, color: Colors.blueGrey),
        ListTile(
          leading: Icon(Icons.monetization_on),
          title: Text('My Expenses'),
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(ExpenseListScreen.routeName),
        ),
        Divider(height: 3, color: Colors.blueGrey),
      ]),
    );
  }
}
