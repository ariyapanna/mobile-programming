import 'package:chapter_04/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class TransactionProvider extends ChangeNotifier {
  final List<TransactionItem> _items = [];
  bool _loading = false;

  List<TransactionItem> get items => List.unmodifiable(_items);
  bool get loading => _loading;

  // Example GET from a mock API (jsonplaceholder used for demo)
  Future<void> fetchTransactions() async {
    _loading = true;
    notifyListeners();

    try {
      final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=10');
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
        _items.clear();
        for (var post in data) {
          _items.add(TransactionItem(
            id: post['id'].toString(),
            title: post['title'] ?? 'No title',
            amount: ((post['id'] ?? 1) * 10).toDouble(),
            category: (post['id'] % 2 == 0) ? 'Food' : 'Transport',
            date: DateTime.now().subtract(Duration(days: post['id'] ?? 0)),
            isExpense: (post['id'] % 3 != 0),
          ));
        }
      } else {
      }
    } catch (e) {
    }

    _loading = false;
    notifyListeners();
  }

  Future<TransactionItem?> addTransaction(TransactionItem tx, {bool syncToApi = true}) async {
    _items.insert(0, tx);
    notifyListeners();

    if (syncToApi) {
      try {
        final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
        final body = json.encode({
          'title': tx.title,
          'body': 'amount:${tx.amount};category:${tx.category}',
          'userId': 1,
        });
        final res = await http.post(uri, body: body, headers: {'Content-Type': 'application/json'});
        if (res.statusCode == 201) {
          final responseData = json.decode(res.body);

          final newId = responseData['id']?.toString() ?? tx.id;
          final updated = TransactionItem(
            id: newId,
            title: tx.title,
            amount: tx.amount,
            category: tx.category,
            date: tx.date,
            isExpense: tx.isExpense,
          );

          _items[0] = updated;
          notifyListeners();
          return updated;
        }
      } catch (e) {

      }
    }

    return tx;
  }
}