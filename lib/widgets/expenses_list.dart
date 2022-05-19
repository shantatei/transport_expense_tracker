import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transport_expense_tracker/models/expense.dart';
import 'package:transport_expense_tracker/screens/edit_expense_screen.dart';
import 'package:transport_expense_tracker/services/firestore_service.dart';

class ExpensesList extends StatefulWidget {
  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  FirestoreService fsService = FirestoreService();

  void removeItem(String id) {
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
                      fsService.removeExpense(id);
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
        stream: fsService.getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            return ListView.separated(
              itemBuilder: (ctx, i) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(snapshot.data![i].mode),
                  ),
                  title: Text(snapshot.data![i].purpose),
                  subtitle: Text(snapshot.data![i].cost.toStringAsFixed(2)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      removeItem(snapshot.data![i].id);
                    },
                  ),
                  onTap: () => Navigator.pushNamed(
                      context, EditExpenseScreen.routeName,
                      arguments: snapshot.data![i]),
                );
              },
              itemCount: snapshot.data!.length,
              separatorBuilder: (ctx, i) {
                return Divider(height: 3, color: Colors.blueGrey);
              },
            );
          }
        });
  }
}
