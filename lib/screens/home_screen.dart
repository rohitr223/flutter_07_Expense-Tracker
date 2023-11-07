import 'package:expense_tracker_app/components/expense_summary.dart';
import 'package:expense_tracker_app/components/expense_tile.dart';
import 'package:expense_tracker_app/data/expense_data.dart';
import 'package:expense_tracker_app/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // controller for name
  final newExpenseNameController = TextEditingController();
  // controller for amount
  final newExpenseAmountController = TextEditingController();

  // when our app loads for first time
  @override
  void initState() {
    super.initState();

    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // expense name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: 'Expense Name',
              ),
              maxLength: 15,
            ),
            // expense amount
            TextField(
              controller: newExpenseAmountController,
              decoration: const InputDecoration(
                hintText: 'Expense Amount',
              ),
              maxLength: 5,
              // number keypad with decimal
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            color: Colors.green,
            onPressed: save,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // cancel button
          MaterialButton(
            color: Colors.red,
            onPressed: cancel,
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  // save
  void save() {
    /*
      Added an if check because if the amount textfield is blank then our 
      app will throw an error because text-controller cannot be null.
      That's why we added an if check to ensure that the amount has to 
      be filled compulsory.
     */
    if (newExpenseAmountController.text == '') {
      return; // don't return anything
    } else {
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        // removes ',' from the user input if user adds it
        // since double cannot have values like 2,00,000 we have to remove the ','
        // in order to convert it to 200000
        // to achieve it we add .replaceAll() method
        // even if the user enters '/ - ,' characters it will be omitted and our app will not crash.
        // here '|' acts as OR operator so you can pass multiple characters you want to remove from
        // the string.
        amount: newExpenseAmountController.text.replaceAll(RegExp(", | / | -"), ''),
        dateTime: DateTime.now(),
      );
      // add  the new expense
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
      Navigator.pop(context); // close the AlertDialog/
      clear(); // clear the text in textfield's
    }
  }

  // cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear the textfield controllers after saving
  void clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 88, 77, 218),
          title: const Text(
            'Expense Tracker',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 88, 77, 218),
          onPressed: addNewExpense,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 20),
            // weekly summary
            ExpenseSummary(
              startOfWeek: value.startOfWeekDate(),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Your Expenses :',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
            // expense list
            ListView.builder(
              // since we are using ListView inside a ListView
              // we have to change the settings i.e. shrinkWrap, physics
              // scrolling is disabled
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getAllExpenseList().length,
              itemBuilder: (context, index) => ExpenseTile(
                name: value.getAllExpenseList()[index].name,
                amount: value.getAllExpenseList()[index].amount,
                dateTime: value.getAllExpenseList()[index].dateTime,
                deleteTapped: (p0) => deleteExpense(
                  value.getAllExpenseList()[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
