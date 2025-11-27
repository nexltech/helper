import 'package:flutter/material.dart';
import '../services/crud_job_api_service.dart';
import '../models/job_model.dart';

class CrudJobProvider extends ChangeNotifier {
  final CrudJobApiService _apiService = CrudJobApiService();
  
  // State variables
  List<JobPost> _jobs = [];
  JobPost? _selectedJob;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  Map<int, String> _appliedJobs = {}; // jobId -> status

  // Getters
  List<JobPost> get jobs => _jobs;
  JobPost? get selectedJob => _selectedJob;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  Map<int, String> get appliedJobs => _appliedJobs;

  // Set auth token
  void setAuthToken(String token) {
    _apiService.setAuthToken(token);
  }

  // Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // Check if job is applied
  bool isJobApplied(int jobId) {
    return _appliedJobs.containsKey(jobId);
  }

  // Get application status for a job
  String? getApplicationStatus(int jobId) {
    return _appliedJobs[jobId];
  }

  // 1. Create Job Post
  Future<void> createJobPost({
    required String jobTitle,
    required int jobCategoryId,
    required double payment,
    required String address,
    required String dateTime,
    required String jobDescription,
    String? image,
  }) async {
    _isLoading = true;
    clearMessages();
    notifyListeners();

    try {
      final response = await _apiService.createJobPost(
        jobTitle: jobTitle,
        jobCategoryId: jobCategoryId,
        payment: payment,
        address: address,
        dateTime: dateTime,
        jobDescription: jobDescription,
        image: image,
      );

      if (response['message'] != null) {
        _successMessage = response['message'];
        
        // Add the new job to the list if data is provided
        if (response['data'] != null) {
          final newJob = JobPost.fromJson(response['data']);
          _jobs.insert(0, newJob); // Add to beginning of list
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. Update Job Post
  Future<void> updateJobPost({
    required int jobId,
    String? jobTitle,
    int? jobCategoryId,
    double? payment,
    String? address,
    String? dateTime,
    String? jobDescription,
    String? image,
  }) async {
    _isLoading = true;
    clearMessages();
    notifyListeners();

    try {
      final response = await _apiService.updateJobPost(
        jobId: jobId,
        jobTitle: jobTitle,
        jobCategoryId: jobCategoryId,
        payment: payment,
        address: address,
        dateTime: dateTime,
        jobDescription: jobDescription,
        image: image,
      );

      if (response['message'] != null) {
        _successMessage = response['message'];
        
        // Update the job in the list if data is provided
        if (response['data'] != null) {
          final updatedJob = JobPost.fromJson(response['data']);
          final index = _jobs.indexWhere((job) => job.id == jobId);
          if (index != -1) {
            _jobs[index] = updatedJob;
          }
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 3. Delete Job Post
  Future<void> deleteJobPost(int jobId) async {
    _isLoading = true;
    clearMessages();
    notifyListeners();

    try {
      final response = await _apiService.deleteJobPost(jobId);

      if (response['message'] != null) {
        _successMessage = response['message'];
        
        // Remove the job from the list
        _jobs.removeWhere((job) => job.id == jobId);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 4. Get All Jobs
  Future<void> getAllJobs() async {
    _isLoading = true;
    clearMessages();
    notifyListeners();

    try {
      final jobsData = await _apiService.getAllJobs();
      _jobs = jobsData.map((jobData) => JobPost.fromJson(jobData)).toList();
      _successMessage = 'Jobs fetched successfully';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 5. Get Job by ID
  Future<void> getJobById(int jobId) async {
    _isLoading = true;
    clearMessages();
    notifyListeners();

    try {
      final jobData = await _apiService.getJobById(jobId);
      _selectedJob = JobPost.fromJson(jobData);
      _successMessage = 'Job fetched successfully';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 6. Refresh all data
  Future<void> refreshAllData() async {
    await getAllJobs();
  }

  // 7. Get jobs by category
  List<JobPost> getJobsByCategory(int categoryId) {
    return _jobs.where((job) => int.parse(job.jobCategoryId) == categoryId).toList();
  }

  // 8. Get jobs by user
  List<JobPost> getJobsByUser(String userId) {
    return _jobs.where((job) => job.userId == userId).toList();
  }

  // 9. Search jobs
  List<JobPost> searchJobs(String query) {
    return _jobs.where((job) => 
      job.jobTitle.toLowerCase().contains(query.toLowerCase()) ||
      job.jobDescription.toLowerCase().contains(query.toLowerCase()) ||
      job.address.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // 10. Apply for Job
  Future<void> applyForJob({
    required int jobId,
    required String coverLetter,
    required List<String> availability,
  }) async {
    print('CrudJobProvider: Starting apply for job...');
    _isLoading = true;
    clearMessages();
    notifyListeners();

    try {
      print('CrudJobProvider: Calling API service...');
      final response = await _apiService.applyForJob(
        jobId: jobId,
        coverLetter: coverLetter,
        availability: availability,
      );

      print('CrudJobProvider: API response received: $response');

      if (response['message'] != null) {
        _successMessage = response['message'];
        print('CrudJobProvider: Success message set: ${_successMessage}');
        
        // Track the applied job with its status
        if (response['application'] != null) {
          final application = response['application'];
          final status = application['status'] ?? 'pending';
          _appliedJobs[jobId] = status;
          print('CrudJobProvider: Job $jobId marked as applied with status: $status');
        }
      } else {
        _successMessage = 'Application submitted successfully!';
        print('CrudJobProvider: Default success message set');
        // Still track as applied even if no application data
        _appliedJobs[jobId] = 'pending';
      }
    } catch (e) {
      print('CrudJobProvider: Error occurred: $e');
      
      // Handle duplicate application gracefully
      if (e.toString().contains('409') || e.toString().contains('already applied')) {
        _appliedJobs[jobId] = 'pending'; // Mark as applied locally
        _successMessage = 'You have already applied for this job. Waiting for response.';
        print('CrudJobProvider: Duplicate application handled gracefully');
      } else {
        _errorMessage = e.toString();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
      print('CrudJobProvider: Loading finished, notifying listeners');
    }
  }

  // 11. Get Active Jobs
  Future<void> getActiveJobs() async {
    _isLoading = true;
    clearMessages();
    notifyListeners();

    try {
      final jobsData = await _apiService.getActiveJobs();
      _jobs = jobsData.map((jobData) => JobPost.fromJson(jobData)).toList();
      _successMessage = 'Active jobs fetched successfully';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 12. Start Application
  Future<void> startApplication(int applicationId) async {
    print('CrudJobProvider: Starting application $applicationId...');
    _isLoading = true;
    clearMessages();
    notifyListeners();

    try {
      print('CrudJobProvider: Calling start application API...');
      final response = await _apiService.startApplication(applicationId);

      print('CrudJobProvider: Start application response received: $response');

      if (response['message'] != null) {
        _successMessage = response['message'];
        print('CrudJobProvider: Success message set: ${_successMessage}');
        
        // Update job status if provided in response
        if (response['job_status'] != null) {
          final jobStatus = response['job_status'];
          print('CrudJobProvider: Job status updated to: $jobStatus');
        }
      } else {
        _successMessage = 'Work started successfully!';
        print('CrudJobProvider: Default success message set');
      }
    } catch (e) {
      print('CrudJobProvider: Error starting application: $e');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
      print('CrudJobProvider: Start application finished, notifying listeners');
    }
  }
}
