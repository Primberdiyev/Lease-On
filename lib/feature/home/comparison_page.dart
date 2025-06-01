import 'package:rentora/feature/models/home_model.dart';

class ComparisonService {
  static final ComparisonService _instance = ComparisonService._internal();
  final List<HomeModel> _comparedHomes = [];

  factory ComparisonService() => _instance;

  ComparisonService._internal();

  List<HomeModel> get comparedHomes => _comparedHomes;

  void addToComparison(HomeModel home) {
    if (!_comparedHomes.contains(home) && _comparedHomes.length < 4) {
      _comparedHomes.add(home);
    }
  }

  void removeFromComparison(HomeModel home) {
    _comparedHomes.remove(home);
  }

  void clearComparison() {
    _comparedHomes.clear();
  }
}
