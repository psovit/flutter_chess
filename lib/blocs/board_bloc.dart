import 'package:flutter/material.dart';

class BoardBloc {
  void setSelected(int index) {
    _selectedIndexNf.value = index;
  }

  ValueNotifier<int> get selectedIndexNf => _selectedIndexNf;

  final ValueNotifier<int> _selectedIndexNf = ValueNotifier<int>(-1);
}
