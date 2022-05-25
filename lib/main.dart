import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transport_expense_tracker/models/expense.dart';
import 'package:transport_expense_tracker/screens/add_expense_screen.dart';
import 'package:transport_expense_tracker/screens/auth_screen.dart';
import 'package:transport_expense_tracker/screens/edit_expense_screen.dart';
import 'package:transport_expense_tracker/screens/expense_list_screen.dart';
import 'package:transport_expense_tracker/services/auth_service.dart';
import 'package:transport_expense_tracker/services/firestore_service.dart';
import 'package:transport_expense_tracker/widgets/app_drawer.dart';
import 'package:transport_expense_tracker/widgets/expenses_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<User?>(
              stream: authService.getAuthUser(),
              builder: (context, snapshot) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      primarySwatch: Colors.blue,
                    ),
                    home: snapshot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : snapshot.hasData
                            ? MainScreen()
                            : AuthScreen(),
                    routes: {
                      AddExpenseScreen.routeName: (_) {
                        return AddExpenseScreen();
                      },
                      ExpenseListScreen.routeName: (_) {
                        return ExpenseListScreen();
                      },
                      EditExpenseScreen.routeName: (_) {
                        return EditExpenseScreen();
                      },
                      AuthScreen.routeName: (_) {
                        return AuthScreen();
                      },
                    });
              }),
    );
  }
}

class MainScreen extends StatefulWidget {
  static String routeName = '/';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    FirestoreService fsService = FirestoreService();
    AuthService authService = AuthService();

    logOut() {
      return authService.logOut().then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Logout successfully!'),
        ));
      }).catchError((error) {
        FocusScope.of(context).unfocus();
        String message = error.toString();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      });
    }

    return StreamBuilder<List<Expense>>(
        stream: fsService.getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            double sum = 0;
            snapshot.data!.forEach((doc) {
              sum += doc.cost;
            });
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text('Transport Expense Tracker'),
                actions: [
                  IconButton(
                      onPressed: () => logOut(), icon: Icon(Icons.logout))
                ],
              ),
              body: Column(
                children: [
                  Image.asset('images/creditcard.png'),
                  Text('Total spent: \$' + sum.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.titleLarge)
                ],
              ),
              drawer: AppDrawer(),
            );
          }
        });
  }
}
