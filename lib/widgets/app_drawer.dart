import 'package:flutter/material.dart';
import 'package:transport_expense_tracker/main.dart';
import 'package:transport_expense_tracker/screens/expense_list_screen.dart';
import 'package:transport_expense_tracker/services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AuthService authService = AuthService();
    
    return Drawer(
      child: Column(children: [
        AppBar(
          title: FittedBox(child: Text('Hello ' + authService.getCurrentUser()!.email! + '!')),
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
