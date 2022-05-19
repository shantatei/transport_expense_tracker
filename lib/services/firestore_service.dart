import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transport_expense_tracker/models/expense.dart';

class FirestoreService {
  addExpense(purpose, mode, cost, travelDate) {
    return FirebaseFirestore.instance.collection('expenses').add({
      'purpose': purpose,
      'mode': mode,
      'cost': cost,
      'travelDate': travelDate
    });
  }

  removeExpense(id) {
    return FirebaseFirestore.instance.collection('expenses').doc(id).delete();
  }

  Stream<List<Expense>> getExpenses() {
    return FirebaseFirestore.instance.collection('expenses').snapshots().map(
        (snapshot) => snapshot.docs
            .map<Expense>((doc) => Expense.fromMap(doc.data(), doc.id))
            .toList());
  }

  editExpense(id, purpose, mode, cost, travelDate) {
    return FirebaseFirestore.instance.collection('expenses').doc(id).set({
      'purpose': purpose,
      'mode': mode,
      'cost': cost,
      'travelDate': travelDate
    });
  }
}
