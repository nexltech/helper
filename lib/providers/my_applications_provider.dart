import 'package:flutter/material.dart';
import '../models/my_application_model.dart';
import '../services/crud_job_api_service.dart';

class MyApplicationsProvider extends ChangeNotifier {
  final CrudJobApiService _apiService = CrudJobApiService();
  
  List<MyApplication> _applications = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  List<MyApplication> get applications => _applications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // Set auth token
  void setAuthToken(String token) {
    _apiService.setAuthToken(token);
  }

  // Get my applications
  Future<void> getMyApplications() async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await _apiService.getMyApplications();
      _applications = response.data;
      _successMessage = response.message;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Filter applications by status
  List<MyApplication> getApplicationsByStatus(String status) {
    return _applications.where((application) => 
      application.status.toLowerCase() == status.toLowerCase()
    ).toList();
  }

  // Get pending applications
  List<MyApplication> get pendingApplications => 
    getApplicationsByStatus('pending');

  // Get accepted applications
  List<MyApplication> get acceptedApplications => 
    getApplicationsByStatus('accepted');

  // Get rejected applications
  List<MyApplication> get rejectedApplications => 
    getApplicationsByStatus('rejected');

  // Get cancelled applications
  List<MyApplication> get cancelledApplications => 
    getApplicationsByStatus('cancelled');

  // Refresh all data
  Future<void> refreshAllData() async {
    await getMyApplications();
  }

  // Clear messages
  void clearMessages() {
    _clearMessages();
    notifyListeners();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }
}
