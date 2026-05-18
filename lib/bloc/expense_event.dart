import '../models/expense_model.dart';

abstract class ExpenseEvent {}

class LoadExpensesEvent extends ExpenseEvent {}

class AddExpenseEvent extends ExpenseEvent {
  final Expense expense;
  AddExpenseEvent(this.expense);
}

class UpdateExpenseEvent extends ExpenseEvent {
  final Expense expense;
  UpdateExpenseEvent(this.expense);
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String id;
  DeleteExpenseEvent(this.id);
}
