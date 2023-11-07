import 'package:expense_tracker_app/data/hive_database.dart';
import 'package:expense_tracker_app/datetime/date_time_helper.dart';
import 'package:expense_tracker_app/models/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier {
  // list of all expenses
  // all the expense data will go here ...
  List<ExpenseItem> overallExpenseList = [];

  // get the expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // prepare data to display
  // when user starts the app for first time
  final db = HiveDatabase();

  void prepareData() {
    // if data already exists fetch it
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  // add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
    notifyListeners(); // notify when data changed
    db.saveData(overallExpenseList); // save data in the database when updated
  }

  // delete expenses
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners(); // notify when data changed
     db.saveData(overallExpenseList); // save data in the database when updated
  }

  // get weekday (mon, tue, wed) from dateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thurs';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // get the date for the start of the week (sunday)
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get today's date
    DateTime today = DateTime.now();

    // go back from today to find sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  /// Convert overall list of expenses into daily expense summary
  ///
  /// eg.
  ///
  /// overallExpensesList = [
  ///  [food, 2023/06/04, $15]
  /// ]
  ///
  ///  Daily Expenses Summary -:
  ///
  ///  dailyExpenseSummary = [
  ///  [20230604, $10],
  ///  [20230604, $10],
  /// ]
  ///

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      // date (yyyy/mm/dd : amountTotalForDay)
    };
    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }
}
