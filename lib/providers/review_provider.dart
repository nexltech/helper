import 'package:flutter/material.dart';
import '../services/review_api_service.dart';

class ReviewProvider extends ChangeNotifier {
  List<dynamic> _userReviews = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<dynamic> get userReviews => _userReviews;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Set auth token
  String? _authToken;
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Add review
  Future<bool> addReview({
    required int applicationId,
    required int rating,
    required String comment,
  }) async {
    if (_authToken == null) {
      _errorMessage = 'No authentication token available';
      // Use WidgetsBinding to schedule the notifyListeners call after the current build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    // Use WidgetsBinding to schedule the notifyListeners call after the current build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final result = await ReviewApiService.addReview(
        token: _authToken!,
        applicationId: applicationId,
        rating: rating,
        comment: comment,
      );

      _isLoading = false;

      if (result != null) {
        if (result['error'] == true) {
          // Handle error response (including 409 conflict)
          _errorMessage = result['message'] ?? 'Failed to add review';
          notifyListeners();
          return false;
        } else if (result['message'] != null) {
          // Review added successfully
          _errorMessage = null; // Clear any previous errors
          notifyListeners();
          return true;
        } else {
          _errorMessage = 'Failed to add review';
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = 'Failed to add review';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error adding review: $e';
      notifyListeners();
      return false;
    }
  }

  // Get user reviews
  Future<void> getUserReviews(int userId) async {
    if (_authToken == null) {
      _errorMessage = 'No authentication token available';
      // Use WidgetsBinding to schedule the notifyListeners call after the current build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    // Use WidgetsBinding to schedule the notifyListeners call after the current build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final reviews = await ReviewApiService.getUserReviews(
        token: _authToken!,
        userId: userId,
      );

      _isLoading = false;

      if (reviews != null) {
        _userReviews = reviews;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load reviews';
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error loading reviews: $e';
      notifyListeners();
    }
  }

  // Get reviews for a specific user (for profile display)
  Future<void> getReviewsForUser(int userId) async {
    if (_authToken == null) {
      _errorMessage = 'No authentication token available';
      // Use WidgetsBinding to schedule the notifyListeners call after the current build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    // Use WidgetsBinding to schedule the notifyListeners call after the current build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final reviews = await ReviewApiService.getReviewsForUser(
        token: _authToken!,
        userId: userId,
      );

      _isLoading = false;

      if (reviews != null) {
        _userReviews = reviews;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load reviews';
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error loading reviews: $e';
      notifyListeners();
    }
  }

  // Calculate average rating
  double getAverageRating() {
    if (_userReviews.isEmpty) return 0.0;
    
    double totalRating = 0.0;
    for (var review in _userReviews) {
      totalRating += double.tryParse(review['rating'].toString()) ?? 0.0;
    }
    return totalRating / _userReviews.length;
  }

  // Get total number of reviews
  int getTotalReviews() {
    return _userReviews.length;
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear all data
  void clearData() {
    _userReviews = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
