import 'package:flutter/foundation.dart';

class FilterProvider with ChangeNotifier {
  String _currentFilter = 'all';

  String get currentFilter => _currentFilter;

  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }
}
