import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../models/job_model.dart';
import '../../providers/crud_job_provider.dart';
import 'job_category_screen.dart';

class EditJobScreen extends StatefulWidget {
  final JobPost job;

  const EditJobScreen({
    super.key,
    required this.job,
  });

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jobTitleController = TextEditingController();
  final _paymentController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? _selectedCategory;
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _jobTitleController.text = widget.job.jobTitle;
    _paymentController.text = widget.job.payment.toString();
    _addressController.text = widget.job.address;
    _dateTimeController.text = widget.job.dateTime;
    _descriptionController.text = widget.job.jobDescription;
    _selectedCategory = widget.job.category.name;
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _paymentController.dispose();
    _addressController.dispose();
    _dateTimeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Header
                _buildHeader(),
                const SizedBox(height: 24),
                // Main Content Card
                _buildMainCard(),
                const SizedBox(height: 24),
                // Update Button
                _buildUpdateButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 8),
        const Text(
          'Edit Job',
          style: TextStyle(
            fontFamily: 'HomemadeApple',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildMainCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instruction Text
            const Text(
              'Update the job details below.',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            
            // Job Title Field
            _buildInputField(
              label: 'Job Title',
              controller: _jobTitleController,
              icon: Icons.assignment,
              iconColor: Colors.orange,
              labelText: 'Enter job title',
            ),
            const SizedBox(height: 16),
            
            // Job Category Field
            _buildCategoryField(),
            const SizedBox(height: 16),
            
            // Payment Field
            _buildInputField(
              label: 'Payment',
              controller: _paymentController,
              icon: Icons.account_balance_wallet,
              iconColor: Colors.blue,
              labelText: 'Enter payment amount',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            
            // Address Field
            _buildInputField(
              label: 'Address',
              controller: _addressController,
              icon: Icons.location_on,
              iconColor: Colors.red,
              labelText: 'Enter job location',
            ),
            const SizedBox(height: 16),
            
            // Date & Time Field
            _buildInputField(
              label: 'Date & Time',
              controller: _dateTimeController,
              icon: Icons.calendar_today,
              iconColor: Colors.green,
              labelText: 'Select date and time',
              readOnly: true,
              onTap: () => _selectDateTime(),
            ),
            const SizedBox(height: 16),
            
            // Job Description Field
            _buildInputField(
              label: 'Job Description',
              controller: _descriptionController,
              icon: Icons.edit,
              iconColor: Colors.purple,
              labelText: 'Describe the job details',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            
            // Upload Image Field
            _buildImageUploadField(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
    required String labelText,
    TextInputType? keyboardType,
    bool readOnly = false,
    int maxLines = 1,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'LifeSavers',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            maxLines: maxLines,
            onTap: onTap,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(
                color: Colors.black38,
                fontFamily: 'LifeSavers',
              ),
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Job Category',
          style: TextStyle(
            fontFamily: 'LifeSavers',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectCategory(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(Icons.folder, color: Colors.orange, size: 20),
                ),
                Expanded(
                  child: Text(
                    _selectedCategory ?? 'Select category',
                    style: TextStyle(
                      fontFamily: 'LifeSavers',
                      color: _selectedCategory != null ? Colors.black : Colors.black26,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.black26),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Image',
          style: TextStyle(
            fontFamily: 'LifeSavers',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickImageFromGallery(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(Icons.image, color: Colors.blue, size: 20),
                ),
                Expanded(
                  child: Text(
                    _selectedImage == null ? 'Tap to select new image (optional)' : 'New image selected',
                    style: const TextStyle(
                      fontFamily: 'LifeSavers',
                      color: Colors.black26,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.black26, size: 16),
              ],
            ),
          ),
        ),
        if (_selectedImage != null) ...[
          const SizedBox(height: 8),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black26),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleUpdate,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isLoading ? Colors.grey[300] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: _isLoading ? Colors.grey : Colors.black,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : const Text(
                'Update Job',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }

  void _selectCategory() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const JobCategoryScreen(),
      ),
    );
    
    if (result != null && result is String) {
      setState(() {
        _selectedCategory = result;
      });
    }
  }

  void _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      
      if (pickedTime != null) {
        setState(() {
          _dateTimeController.text = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year} at ${pickedTime.format(context)}';
        });
      }
    }
  }

  void _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _handleUpdate() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final jobProvider = Provider.of<CrudJobProvider>(context, listen: false);
        
        await jobProvider.updateJobPost(
          jobId: widget.job.id,
          jobTitle: _jobTitleController.text,
          jobCategoryId: _getCategoryId(_selectedCategory!),
          payment: double.tryParse(_paymentController.text) ?? 0.0,
          address: _addressController.text,
          dateTime: _dateTimeController.text,
          jobDescription: _descriptionController.text,
          image: _selectedImage?.path,
        );

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Job updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating job: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  int _getCategoryId(String categoryName) {
    // Map category names to IDs (this should match your backend)
    switch (categoryName) {
      case 'Home Services':
        return 1;
      case 'Family & Personal Care':
        return 2;
      case 'Lifestyle & Events':
        return 3;
      case 'Business Support':
        return 4;
      case 'Vehicle Services':
        return 5;
      case 'Other':
        return 6;
      default:
        return 1;
    }
  }
}
