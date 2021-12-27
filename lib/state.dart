import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

import 'native.dart';

class BoxState extends ChangeNotifier {
  final List<int> _numbers = [];
  int _clickedIndex = -1;

  BoxState() {
    for (int i = 0; i < 81; i++) {
      _numbers.insert(i, 0);
    }
    notifyListeners();
  }

  List<int> get numbers => _numbers;

  int getNumber(index) {
    return _numbers[index];
  }

  void setNumber(int value) {
    if (_clickedIndex != -1) {
      _numbers[_clickedIndex] = value;
    }
    notifyListeners();
  }

  void clear() {
    _numbers.clear();
    for (int i = 0; i < 81; i++) {
      _numbers.insert(i, 0);
    }
    notifyListeners();
  }

  void cellReset() {
    setNumber(0);
  }

  List<int> getUniqueNumbers(int index) {
    List<int> x = [];

    int col = index % 9;
    int row = index ~/ 9;

    for (int i = 1; i < 10; i++) {
      for (int j = 0; j < 9; j++) {
        if (_numbers[col + 9 * j] == i) {
          if (col + 9 * j != index) {
            x.add(i);
          }
        }
      }
    }

    for (int i = 1; i < 10; i++) {
      for (int j = 0; j < 9; j++) {
        if (_numbers[j + 9 * row] == i) {
          if (j + 9 * row != index) {
            x.add(i);
          }
        }
      }
    }

    int w = row ~/ 3;
    int q = col ~/ 3;
    // col ~/ 3
    // row % 3
    // row ~/3

    for (int k = 1; k < 10; k++) {
      for (int j = 3 * w; j < 3 * (w + 1); j++) {
        for (int i = 3 * q; i < 3 * (q + 1); i++) {
          if (_numbers[i + 9 * j] == k) {
            if (i + 9 * j != index) {
              x.add(k);
            }
          }
        }
      }
    }

    List<int> y = [];
    for (int i = 1; i < 10; i++) {
      y.add(i);
    }

    return y.where((a) => x.where((b) => a == b).toList().isEmpty).toList();
  }

  void setClickedIndex(int index) {
    _clickedIndex = index;
  }

  int get clickedIndex => _clickedIndex;

  bool isColored(int index) {
    if (_clickedIndex != -1) {
      return _numbers[index] == _numbers[_clickedIndex] && _numbers[index] != 0;
    }
    return false;
  }

  void solveSudoku() {
    Pointer<Int32> ptr = malloc.allocate<Int32>(sizeOf<Int32>() * 81);
    for (int i = 0; i < 81; i++) {
      ptr.elementAt(i).value = _numbers[i];
    }
    ptr = solve(ptr, 81);
    for (int i = 0; i < 81; i++) {
      _numbers[i] = ptr.elementAt(i).value;
    }
    malloc.free(ptr);
    notifyListeners();
  }
}

class NumberState extends ChangeNotifier {
  final List<int> _numbers = [];

  List<int> get numbers => _numbers;

  clearNumbers() {
    _numbers.clear();
    notifyListeners();
  }

  addNumber(int number) {
    _numbers.add(number);
    notifyListeners();
  }
}