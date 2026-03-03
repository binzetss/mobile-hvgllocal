import 'package:flutter/material.dart';
import '../../core/config/preload_config.dart';

class DataPreloadService {
  static final DataPreloadService _instance = DataPreloadService._internal();
  factory DataPreloadService() => _instance;
  DataPreloadService._internal();

  bool _isPreloading = false;
  bool _isPreloaded = false;

  bool get isPreloading => _isPreloading;
  bool get isPreloaded => _isPreloaded;

  Future<void> preloadAllData(BuildContext context) async {
    if (_isPreloading || _isPreloaded) {
      return; 
    }

    _isPreloading = true;

    try {

      for (var config in preloadProviders) {
        try {
          debugPrint(' Preloading: ${config.name}');
          await config.preload(context);
          debugPrint(' Loaded: ${config.name}');
        } catch (e) {
          debugPrint(' Error loading ${config.name}: $e');

        }
      }

      _isPreloaded = true;
      debugPrint('All data preloaded successfully!');
    } catch (e) {
      debugPrint('Error preloading data: $e');

    } finally {
      _isPreloading = false;
    }
  }

  void clearAllCache(BuildContext context) {
    debugPrint('Clearing all cache...');
    for (var config in preloadProviders) {
      try {
        config.clearCache(context);
        debugPrint('Cleared cache: ${config.name}');
      } catch (e) {
        debugPrint('Error clearing cache ${config.name}: $e');
      }
    }
    reset();
  }

  void reset() {
    _isPreloading = false;
    _isPreloaded = false;
    debugPrint('Preload service reset');
  }

  Future<void> refreshAllData(BuildContext context) async {
    debugPrint('Refreshing all data...');
    _isPreloaded = false;
    await preloadAllData(context);
  }
}
