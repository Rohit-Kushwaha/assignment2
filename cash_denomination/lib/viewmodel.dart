import 'package:flutter/material.dart';

class DenominationViewModel {
  final Map<String, ValueNotifier<int>> denominations = {
    '₹ 2000': ValueNotifier<int>(0),
    '₹ 500': ValueNotifier<int>(0),
    '₹ 200': ValueNotifier<int>(0),
    '₹ 100': ValueNotifier<int>(0),
    '₹ 50': ValueNotifier<int>(0),
    '₹ 20': ValueNotifier<int>(0),
    '₹ 10': ValueNotifier<int>(0),
    '₹ 5': ValueNotifier<int>(0),
    '₹ 2': ValueNotifier<int>(0),
    '₹ 1': ValueNotifier<int>(0),
  };

  final Map<String, int> denominationValues = {
    '₹ 2000': 2000,
    '₹ 500': 500,
    '₹ 200': 200,
    '₹ 100': 100,
    '₹ 50': 50,
    '₹ 20': 20,
    '₹ 10': 10,
    '₹ 5': 5,
    '₹ 2': 2,
    '₹ 1': 1,
  };

  void updateDenomination(String key, String input) {
    final quantity = int.tryParse(input) ?? 0;
    denominations[key]?.value = quantity * (denominationValues[key] ?? 0);
  }

  int calculateTotalAmount() {
    int totalAmount = 0;
    denominations.forEach((denomination, notifier) {
      totalAmount += notifier.value;
    });
    return totalAmount;
  }


  void dispose() {
    denominations.forEach((key, notifier) {
      notifier.dispose();
    });
  }
}