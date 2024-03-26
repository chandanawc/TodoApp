import 'package:flutter/material.dart';
import 'package:todon/models/forexpense.dart';



class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  _ExpenseTrackerScreenState createState() => _ExpenseTrackerScreenState();
}


class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  final List<Expense> expenses = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _addExpense() {
    final String title = _titleController.text;
    final String dateText = _dateController.text;
    final DateTime date = dateText.isNotEmpty
        ? DateTime.parse(dateText)
        : DateTime.now();
    final double amount = double.tryParse(_amountController.text) ?? 0.0;

    if (title.isNotEmpty && amount > 0) {
      final expense = Expense(title, date, amount);

      setState(() {
        expenses.add(expense);
        _titleController.clear();
        _dateController.clear();
        _amountController.clear();
      });
    }
  }

  void _deleteExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
  }

  double _calculateTotalExpenses() {
    double total = 0.0;
    for (var expense in expenses) {
      total += expense.amount;
    }
    return total;
  }
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      _dateController.text = picked.toLocal().toString().split('')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(labelText: 'Date'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.pinkAccent,),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
          ),
          ElevatedButton(
            onPressed: _addExpense,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
            ),
            child: Text('Add Expense'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(expenses[index].title),
                  subtitle: Text(
                    'Date: ${expenses[index].date.toLocal().toString().split(' ')[0]}, Amount: ₹${expenses[index].amount.toStringAsFixed(2)}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red,),
                    onPressed: () => _deleteExpense(index),
                  ),
                );
              },
            ),
          ),
          Text(
            'Total Expenses: ₹${_calculateTotalExpenses().toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

