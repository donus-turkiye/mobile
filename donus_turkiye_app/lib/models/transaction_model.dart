// lib/models/transaction_model.dart

import 'package:flutter/material.dart';

enum TransactionType {
  earn, // Geri dönüşümden kazanılan puanlar
  spend, // Market harcaması
  withdraw // TL'ye çevirme işlemi
}

class TransactionModel {
  final String id;
  final DateTime date;
  final double amount;
  final TransactionType type;
  final String description;

  TransactionModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.type,
    required this.description,
  });

  // İşlem tipine göre simge getir
  IconData get icon {
    switch (type) {
      case TransactionType.earn:
        return Icons.arrow_downward;
      case TransactionType.spend:
        return Icons.shopping_cart;
      case TransactionType.withdraw:
        return Icons.arrow_upward;
    }
  }

  // İşlem tipine göre renk getir
  Color get color {
    switch (type) {
      case TransactionType.earn:
        return Colors.green;
      case TransactionType.spend:
        return Colors.orange;
      case TransactionType.withdraw:
        return Colors.red;
    }
  }

  // Tarih formatını oluştur
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Bugün';
    } else if (dateToCheck == yesterday) {
      return 'Dün';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
