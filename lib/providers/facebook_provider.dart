import 'package:flutter/foundation.dart';
import '../data/models/facebook_post_model.dart';
import '../data/services/facebook_service.dart';

class FacebookProvider extends ChangeNotifier {
  final FacebookService _facebookService = FacebookService();

  FacebookPostModel? _latestPost;
  List<FacebookPostModel> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;

  FacebookPostModel? get latestPost => _latestPost;
  List<FacebookPostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  Future<void> init() async {
    await fetchLatestPost();
  }


  Future<void> fetchLatestPost() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _latestPost = await _facebookService.getLatestPost();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> fetchPosts({int limit = 5}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _posts = await _facebookService.getPosts(limit: limit);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

 
  Future<void> refresh() async {
    await fetchLatestPost();
  }
}
