class TransactionItem {
  final String id;
  final String title;
  final double amount;
  final String category; // e.g., Food, Transport
  final DateTime date;
  final bool isExpense;

  TransactionItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.isExpense,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'].toString(),
      title: json['title'] ?? 'Untitled',
      amount: (json['amount'] is num) ? (json['amount'] as num).toDouble() : double.tryParse('${json['amount']}') ?? 0.0,
      category: json['category'] ?? 'Misc',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      isExpense: json['isExpense'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'isExpense': isExpense,
    };
  }
}
