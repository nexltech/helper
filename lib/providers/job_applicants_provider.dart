import 'package:flutter/foundation.dart';
import '../models/applicant_model.dart';
import '../services/crud_job_api_service.dart';

class JobApplicantsProvider extends ChangeNotifier {
  final CrudJobApiService _apiService = CrudJobApiService();
  
  List<Applicant> _applicants = [];
  JobInfo? _jobInfo;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  List<Applicant> get applicants => _applicants;
  JobInfo? get jobInfo => _jobInfo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // Set auth token
  void setAuthToken(String token) {
    _apiService.setAuthToken(token);
  }

  // Get job applicants
  Future<void> getJobApplicants(int jobId) async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await _apiService.getJobApplicants(jobId);
      _applicants = response.applicants;
      _jobInfo = response.job;
      _successMessage = response.message;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Approve applicant
  Future<void> approveApplicant(int applicantId) async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await _apiService.acceptApplication(applicantId);
      
      if (response['message'] != null) {
        _successMessage = response['message'];
        
        // Update local state with the actual status from API response
        final applicantIndex = _applicants.indexWhere((a) => a.id == applicantId);
        if (applicantIndex != -1) {
          // Get the actual status from the API response
          final applicationData = response['application'];
          final actualStatus = applicationData?['status'] ?? 'accepted';
          
          _applicants[applicantIndex] = Applicant(
            id: _applicants[applicantIndex].id,
            userId: _applicants[applicantIndex].userId,
            coverLetter: _applicants[applicantIndex].coverLetter,
            status: actualStatus, // Use the actual status from API
            createdAt: _applicants[applicantIndex].createdAt,
            user: _applicants[applicantIndex].user,
          );
        }
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Reject applicant
  Future<void> rejectApplicant(int applicantId) async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await _apiService.cancelApplication(applicantId);
      
      if (response['message'] != null) {
        _successMessage = response['message'];
        
        // Update local state with the actual status from API response
        final applicantIndex = _applicants.indexWhere((a) => a.id == applicantId);
        if (applicantIndex != -1) {
          // Get the actual status from the API response
          final applicationData = response['application'];
          final actualStatus = applicationData?['status'] ?? 'cancelled';
          
          _applicants[applicantIndex] = Applicant(
            id: _applicants[applicantIndex].id,
            userId: _applicants[applicantIndex].userId,
            coverLetter: _applicants[applicantIndex].coverLetter,
            status: actualStatus, // Use the actual status from API
            createdAt: _applicants[applicantIndex].createdAt,
            user: _applicants[applicantIndex].user,
          );
        }
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Start application (work begins)
  Future<void> startApplication(int applicantId) async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await _apiService.startApplication(applicantId);
      
      if (response['message'] != null) {
        _successMessage = response['message'];
        
        // Update local state with the actual status from API response
        final applicantIndex = _applicants.indexWhere((a) => a.id == applicantId);
        if (applicantIndex != -1) {
          // Get the actual status from the API response
          final applicationData = response['application'];
          final actualStatus = applicationData?['status'] ?? 'in_progress';
          
          _applicants[applicantIndex] = Applicant(
            id: _applicants[applicantIndex].id,
            userId: _applicants[applicantIndex].userId,
            coverLetter: _applicants[applicantIndex].coverLetter,
            status: actualStatus, // Use the actual status from API
            createdAt: _applicants[applicantIndex].createdAt,
            user: _applicants[applicantIndex].user,
          );
        }
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Complete application (mark as completed)
  Future<void> completeApplication(int applicantId) async {
    _setLoading(true);
    _clearMessages();

    try {
      final response = await _apiService.completeApplication(applicantId);
      
      if (response['message'] != null) {
        _successMessage = response['message'];
        
        // Update local state with the actual status from API response
        final applicantIndex = _applicants.indexWhere((a) => a.id == applicantId);
        if (applicantIndex != -1) {
          // Get the actual status from the API response
          final applicationData = response['application'];
          final actualStatus = applicationData?['status'] ?? 'completed';
          
          _applicants[applicantIndex] = Applicant(
            id: _applicants[applicantIndex].id,
            userId: _applicants[applicantIndex].userId,
            coverLetter: _applicants[applicantIndex].coverLetter,
            status: actualStatus, // Use the actual status from API
            createdAt: _applicants[applicantIndex].createdAt,
            user: _applicants[applicantIndex].user,
          );
        }
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
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
