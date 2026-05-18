class Expense {
  final String? id;
  final String title;
  final double amount;
  final String category;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
  });

  // Convert JSON map from API to Expense Object
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id']?.toString(),
      title: json['title'] ?? '',

      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      category: json['category'] ?? 'General',
    );
  }

  // Convert Expense Object to JSON map for API requests
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'amount': amount,
      'category': category,
    };
  }
}
