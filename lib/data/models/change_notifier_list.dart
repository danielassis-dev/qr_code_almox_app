import 'dart:io';

import 'package:flutter/material.dart';

class ChangeNotifierList<T> with ChangeNotifier {
  final List<T> _objects;

  ChangeNotifierList({List<T>? objects}) : _objects = objects ?? <T>[];

  T operator [](int index) => _objects[index]!;

  int get length => _objects.length;

  @mustCallSuper
  void add(T object) {
    final f = [];
    f.add('value');
    _objects.add(object);

    notifyListeners();
  }

  @mustCallSuper
  void addAll(List<T> objects) {
    objects.addAll(objects);
    notifyListeners();
  }

  @mustCallSuper
  void removeAt(int index) {
    _objects.removeAt(index);
    notifyListeners();
  }

  @mustCallSuper
  void clear() {
    _objects.clear();
    notifyListeners();
  }
}

class ChangeNotifierFileList extends ChangeNotifierList<File> {
  ChangeNotifierFileList({List<File>? objects}) : super(objects: objects);

  @override
  void removeAt(int index) async {
    debugPrint('Deleting File');
    await _objects[index].delete();
    debugPrint('File Deleted');
    super.removeAt(index);
  }

  @override
  void clear() async {
    for (var object in _objects) {
      await object.delete();
    }
    super.clear();
  }
}
