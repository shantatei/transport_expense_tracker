import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transport_expense_tracker/models/expense.dart';
import 'package:transport_expense_tracker/providers/all_expenses.dart';
import 'package:transport_expense_tracker/screens/add_expense_screen.dart';
import 'package:transport_expense_tracker/screens/expense_list_screen.dart';
import 'package:transport_expense_tracker/widgets/app_drawer.dart';
import 'package:transport_expense_tracker/widgets/expenses_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AllExpenses>(
          create: (ctx) => AllExpenses(),
        ),
      ],
      child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MainScreen(),
          routes: {
            AddExpenseScreen.routeName: (_) {
              return AddExpenseScreen();
            },
            ExpenseListScreen.routeName: (_) {
              return ExpenseListScreen();
            },
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
  var form = GlobalKey<FormState>();

  String? purpose;

  String? mode;

  double? cost;

  DateTime? travelDate;

  List<Expense> myExpenses = [];

  void removeItem(i) {
    showDialog<Null>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      myExpenses.removeAt(i);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No')),
            ],
          );
        });
  }

  void saveForm() {
    bool isValid = form.currentState!.validate();
    if (travelDate == null) travelDate = DateTime.now();

    if (isValid) {
      form.currentState!.save();
      print(purpose);
      print(mode);
      print(cost!.toStringAsFixed(2));
      myExpenses.insert(
          0,
          Expense(
              purpose: purpose!,
              mode: mode!,
              cost: cost!,
              travelDate: travelDate!));

      // Hide the keyboard
      FocusScope.of(context).unfocus();

      // Resets the form
      form.currentState!.reset();
      travelDate = null;

      // Shows a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Travel expense added successfully!'),
      ));
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
    AllExpenses expenseList = Provider.of<AllExpenses>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Transport Expense Tracker'),
      ),
      body: Column(
        children: [
          Image.asset('images/creditcard.png'),
          Text(
              'Total spent: \$' +
                  expenseList.getTotalSpend().toStringAsFixed(2),
              style: Theme.of(context).textTheme.titleLarge)
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
