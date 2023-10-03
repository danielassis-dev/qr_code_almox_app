import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class ChangeNotifierList<T> with ChangeNotifier implements List<T> {
  final List<T> _objects;

  ChangeNotifierList({List<T>? objects}) : _objects = objects ?? <T>[];

  @override
  T operator [](int index) => elementAt(index);

  @override
  int get length => _objects.length;

  @override
  bool get isEmpty => _objects.isEmpty;

  @override
  bool get isNotEmpty => _objects.isNotEmpty;

  @override
  @mustCallSuper
  void add(T object) {
    final f = [];
    f.add('value');
    _objects.add(object);
    notifyListeners();
  }

  @override
  @mustCallSuper
  void insert(int index, T element) {
    _objects.insert(index, element);
    notifyListeners();
  }

  @override
  @mustCallSuper
  void addAll(Iterable<T> objects) {
    _objects.addAll(objects);
    notifyListeners();
  }

  @override
  @mustCallSuper
  T removeAt(int index) {
    final returnBuffer = _objects.removeAt(index);
    notifyListeners();
    return returnBuffer;
  }

  @override
  @mustCallSuper
  void clear() {
    _objects.clear();
    notifyListeners();
  }

  @override
  bool any(bool Function(T element) test) => _objects.any(test);

  @override
  List<R> cast<R>() => _objects.cast<R>();

  @override
  bool contains(Object? element) => _objects.contains(element);

  @override
  elementAt(int index) => _objects.elementAt(index);

  @override
  bool every(bool Function(T element) test) => _objects.every(test);

  @override
  T get first => _objects.first;

  @override
  T firstWhere(bool Function(T element) test, {Function()? orElse}) =>
      _objects.firstWhere(test);

  @override
  Iterable<T> followedBy(Iterable<T> other) => _objects.followedBy(other);

  @override
  void forEach(void Function(T element) action) {
    for (T element in this._objects) {
      action(element);
    }
    notifyListeners();
  }

  @override
  Iterator<T> get iterator => _objects.iterator;

  @override
  String join([String separator = ""]) => _objects.join(separator);

  @override
  get last => _objects.last;

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) =>
      _objects.lastWhere(test, orElse: orElse);

  @override
  T get single => _objects.single;

  @override
  void operator []=(int index, T value) {
    _objects[index] = value;
    notifyListeners();
  }

  @override
  void fillRange(int start, int end, [fillValue]) {
    _objects.fillRange(start, end, fillValue);
    notifyListeners();
  }

  @override
  set first(value) {
    _objects.first = value;
    notifyListeners();
  }

  @override
  int indexOf(element, [int start = 0]) => _objects.indexOf(element, start);

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _objects.insertAll(index, iterable);
    notifyListeners();
  }

  @override
  set last(value) {
    _objects.last = value;
    notifyListeners();
  }

  @override
  int lastIndexOf(element, [int? start]) =>
      _objects.lastIndexOf(element, start);

  @override
  set length(int newLength) {
    _objects.length = newLength;
    notifyListeners();
  }

  @override
  bool remove(Object? value) {
    final returnBuffer = _objects.remove(value);
    notifyListeners();
    return returnBuffer;
  }

  @override
  removeLast() {
    final aux = _objects.removeLast();
    notifyListeners();
    return aux;
  }

  @override
  void removeRange(int start, int end) {
    _objects.removeRange(start, end);
    notifyListeners();
  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacements) {
    _objects.replaceRange(start, end, replacements);
    notifyListeners();
  }

  @override
  void setAll(int index, Iterable<T> iterable) {
    _objects.setAll(index, iterable);
    notifyListeners();
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _objects.setRange(start, end, iterable, skipCount);
    notifyListeners();
  }

  @override
  void shuffle([Random? random]) {
    _objects.shuffle(random);
    notifyListeners();
  }

  @override
  Iterable<R> expand<R>(Iterable<R> Function(T element) toElements) =>
      _objects.expand(toElements);

  @override
  R fold<R>(R initialValue, R Function(R previousValue, T element) combine) =>
      _objects.fold(initialValue, combine);

  @override
  Iterable<R> map<R>(R Function(T e) toElement) => _objects.map(toElement);

  @override
  T reduce(T Function(T value, T element) combine) => _objects.reduce(combine);

  @override
  ChangeNotifierList<T> operator +(List<T> other) {
    _objects.addAll(other);
    return this;
  }

  @override
  Map<int, T> asMap() => _objects.asMap();

  @override
  Iterable<T> getRange(int start, int end) => _objects.getRange(start, end);

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) =>
      _objects.indexWhere(test, start);

  @override
  int lastIndexWhere(bool Function(T element) test, [int? start]) =>
      _objects.lastIndexWhere(test, start);

  @override
  void removeWhere(bool Function(T element) test) {
    _objects.removeWhere(test);
    notifyListeners();
  }

  @override
  void retainWhere(bool Function(T element) test) {
    _objects.retainWhere(test);
    notifyListeners();
  }

  @override
  Iterable<T> get reversed => _objects.reversed;

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) =>
      _objects.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => _objects.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) =>
      _objects.skipWhile(test);

  @override
  void sort([int Function(T a, T b)? compare]) {
    _objects.sort(compare);
    notifyListeners();
  }

  @override
  List<T> sublist(int start, [int? end]) => _objects.sublist(start, end);

  @override
  Iterable<T> take(int count) => _objects.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) =>
      _objects.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => _objects.toList(growable: growable);

  @override
  Set<T> toSet() => _objects.toSet();

  @override
  Iterable<T> where(bool Function(T element) test) => _objects.where(test);

  @override
  whereType<R>() => _objects.whereType<R>();
}

class ChangeNotifierFileList extends ChangeNotifierList<File> {
  ChangeNotifierFileList({List<File>? objects}) : super(objects: objects);

  @override
  @Deprecated("""
  [removeAt] is being deprecated in favor of [removeFileAt] (with [Future<void>]
  return type, waiting for the file to be deleted; see [removeFileAt] for more
  information). [removeAt] needs to exist for the superclass
  [ChangeNotifierList] to function.""")
  // ignore: must_call_super
  File removeAt(int index) {
    super.removeAt(index);
    throw UnsupportedError(
        """[removeAt] is being deprecated in favor of [removeFileAt] (with [Future<void>]
  return type, waiting for the file to be deleted; see [removeFileAt] for more
  information). [removeAt] needs to exist for the superclass
  [ChangeNotifierList] to function.""");
  }

  Future<void> removeFileAt(int index) async {
    await _objects.removeAt(index).delete();
    notifyListeners();
  }

  @override
  Future<void> clear() async {
    for (var object in _objects) {
      await object.delete();
    }
    super.clear();
  }
}
