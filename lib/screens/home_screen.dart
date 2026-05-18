import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/expense_card.dart';
import 'manage_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch initial list when screen loads
    context.read<ExpenseBloc>().add(LoadExpensesEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseActionSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ExpenseErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            if (state is ExpenseLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ExpenseLoadedState) {
              if (state.expenses.isEmpty) {
                return const Center(child: Text('No expenses recorded yet.'));
              }

              return ListView.builder(
                itemCount: state.expenses.length,
                itemBuilder: (context, index) {
                  final expense = state.expenses[index];
                  return ExpenseCard(
                    expense: expense,
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ExpenseBloc>(),
                            child: ManageExpenseScreen(expense: expense),
                          ),
                        ),
                      );
                    },
                    onDelete: () {
                      context.read<ExpenseBloc>().add(
                        DeleteExpenseEvent(expense.id!),
                      );
                    },
                  );
                },
              );
            }
            return const Center(
              child: Text('Welcome! Press refresh or fetch expenses.'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<ExpenseBloc>(),
                child: const ManageExpenseScreen(),
              ),
            ),
          );
        },
      ),
    );
  }
}
