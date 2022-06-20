import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReadPageStateChangeNotifier extends ChangeNotifier {
  bool _isSearching = false;
  bool _isServerUpload = false;
  bool _isFiltering = false;
  bool _isFabOpen = false;
  String _searchText = "";

  get isSearching => _isSearching;
  set setIsSearch(bool data) {
    _isSearching = data;
    notifyListeners();
  }

  get isServerUpload => _isServerUpload;
  set setIsServerUpload(bool data) {
    _isServerUpload = data;
    notifyListeners();
  }

  get isFiltering => _isFiltering;
  set setIsFiltering(bool data) {
    _isFiltering = data;
    notifyListeners();
  }

  get searchText => _searchText;
  set setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  get isFabOpen => _isFabOpen;
  set setIsFabOpen(bool data) {
    _isFabOpen = data;
    notifyListeners();
  }

  void notifyLisenerManually() {
    notifyListeners();
  }
}

final readPageStateProvider =
    ChangeNotifierProvider<ReadPageStateChangeNotifier>(
  (ref) => ReadPageStateChangeNotifier(),
);
