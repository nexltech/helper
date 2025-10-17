import 'package:flutter/material.dart';

class JobDetailsEditScreen extends StatefulWidget {
  const JobDetailsEditScreen({super.key});

  @override
  State<JobDetailsEditScreen> createState() => _JobDetailsEditScreenState();
}

class _JobDetailsEditScreenState extends State<JobDetailsEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'Mow Lawn');
  final _descriptionController = TextEditingController(text: 'Need someone to mow my front and back lawn. Should take about 2 hours.');
  final _priceController = TextEditingController(text: '125');
  final _locationController = TextEditingController(text: 'Lafayette, LA');
  
  String _selectedCategory = 'Home Services';
  DateTime _selectedDate = DateTime.now().add(Duration(days: 1));
  TimeOfDay _selectedTime = TimeOfDay(hour: 14, minute: 0);

  final List<String> _categories = [
    'Home Services',
    'Cleaning',
    'Moving',
    'Handyman',
    'Gardening',
    'Pet Care',
    'Other'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Job Details',
          style: TextStyle(
            fontFamily: 'HomemadeApple',
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job Title
                _buildSectionTitle('Job Title'),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _titleController,
                  hintText: 'Enter job title',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a job title';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Description
                _buildSectionTitle('Description'),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _descriptionController,
                  hintText: 'Describe the job details',
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter job description';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Price
                _buildSectionTitle('Price (\$)'),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _priceController,
                  hintText: 'Enter price',
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.attach_money),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Category
                _buildSectionTitle('Category'),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Date and Time
                _buildSectionTitle('Date & Time'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Colors.black54),
                              const SizedBox(width: 12),
                              Text(
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectTime(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, color: Colors.black54),
                              const SizedBox(width: 12),
                              Text(
                                _selectedTime.format(context),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Location
                _buildSectionTitle('Location'),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _locationController,
                  hintText: 'Enter location',
                  prefixIcon: const Icon(Icons.location_on),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 40),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'BioRhyme',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'BioRhyme',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'BioRhyme',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black26),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically save the changes to your backend/database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Job details updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}
