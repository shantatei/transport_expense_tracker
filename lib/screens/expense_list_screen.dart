import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transport_expense_tracker/providers/all_expenses.dart';
import 'package:transport_expense_tracker/screens/add_expense_screen.dart';
import 'package:transport_expense_tracker/widgets/app_drawer.dart';
import 'package:transport_expense_tracker/widgets/expenses_list.dart';

class ExpenseListScreen extends StatefulWidget {
  static String routeName = '/expense-list';

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  @override
  Widget build(BuildContext context) {
    AllExpenses expenseList = Provider.of<AllExpenses>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Expenses'),
      ),
      body: Container(
          alignment: Alignment.center,
          child: expenseList.getMyExpenses().length > 0
              ? ExpensesList()
              : Column(
                  children: [
                    SizedBox(height: 20),
                    Image.asset('images/empty.png', width: 300),
                    Text('No expenses yet, add a new one today!',
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                )),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AddExpenseScreen.routeName);
          },
          child: Icon(Icons.add)),
    );
  }
}
