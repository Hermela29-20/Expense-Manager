import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import '../models/expense_model.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ApiService apiService;
  List<Expense> _cachedExpenses = [];
  ExpenseBloc(this.apiService) : super(ExpenseInitialState()) {
    // Handle Loading
    on<LoadExpensesEvent>((event, emit) async {
      emit(ExpenseLoadingState());
      try {
        _cachedExpenses = await apiService.fetchExpenses();
        emit(ExpenseLoadedState(_cachedExpenses));
      } catch (e) {
        emit(ExpenseErrorState(e.toString()));
      }
    });

    // Handle Adding
    on<AddExpenseEvent>((event, emit) async {
      emit(ExpenseLoadingState());
      try {
        final newExpense = await apiService.addExpense(event.expense);
        _cachedExpenses.add(newExpense);
        emit(ExpenseActionSuccessState('Expense added successfully!'));
        emit(ExpenseLoadedState(_cachedExpenses));
      } catch (e) {
        emit(ExpenseErrorState(e.toString()));
        emit(ExpenseLoadedState(_cachedExpenses)); // Revert to current data
      }
    });

    // Handle Updating
    on<UpdateExpenseEvent>((event, emit) async {
      emit(ExpenseLoadingState());
      try {
        final updatedExpense = await apiService.updateExpense(event.expense);
        int index = _cachedExpenses.indexWhere(
          (e) => e.id == updatedExpense.id,
        );
        if (index != -1) {
          _cachedExpenses[index] = updatedExpense;
        }
        emit(ExpenseActionSuccessState('Expense updated successfully!'));
        emit(ExpenseLoadedState(_cachedExpenses));
      } catch (e) {
        emit(ExpenseErrorState(e.toString()));
        emit(ExpenseLoadedState(_cachedExpenses));
      }
    });

    // Handle Deleting
    on<DeleteExpenseEvent>((event, emit) async {
      emit(ExpenseLoadingState());
      try {
        await apiService.deleteExpense(event.id);
        _cachedExpenses.removeWhere((e) => e.id == event.id);
        emit(ExpenseActionSuccessState('Expense deleted successfully!'));
        emit(ExpenseLoadedState(_cachedExpenses));
      } catch (e) {
        emit(ExpenseErrorState(e.toString()));
        emit(ExpenseLoadedState(_cachedExpenses));
      }
    });
  }
}
