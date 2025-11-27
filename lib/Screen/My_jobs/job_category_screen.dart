import 'package:flutter/material.dart';

class JobCategoryScreen extends StatefulWidget {
  const JobCategoryScreen({super.key});

  @override
  State<JobCategoryScreen> createState() => _JobCategoryScreenState();
}

class _JobCategoryScreenState extends State<JobCategoryScreen> {
  String? _selectedCategory;

  // Hardcoded categories as requested
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Home Services',
      'icon': Icons.home,
      'color': Colors.green,
    },
    {
      'name': 'Family & Personal Care',
      'icon': Icons.people,
      'color': Colors.pink,
    },
    {
      'name': 'Lifestyle & Events',
      'icon': Icons.celebration,
      'color': Colors.purple,
    },
    {
      'name': 'Business Support',
      'icon': Icons.business,
      'color': Colors.blue,
    },
    {
      'name': 'Vehicle Services',
      'icon': Icons.directions_car,
      'color': Colors.red,
    },
    {
      'name': 'Other',
      'icon': Icons.more_horiz,
      'color': Colors.grey,
    },
  ];

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
                // Continue Button
                _buildContinueButton(),
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
          'Job Category',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instruction Text
          const Text(
            'Choose the Right Category for You',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Browse over 200 services and let us match you with the right Helpr.',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          
          // Category List
          ..._categories.map((category) => _buildCategoryItem(category)).toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    final isSelected = _selectedCategory == category['name'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = category['name'];
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey[100] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.black26,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                category['icon'],
                color: category['color'],
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  category['name'],
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.black : Colors.black54,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedCategory != null ? _handleContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedCategory != null ? Colors.white : Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: _selectedCategory != null ? Colors.black : Colors.grey,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
        ),
        child: Text(
          'Continue',
          style: TextStyle(
            fontFamily: 'LifeSavers',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _selectedCategory != null ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    if (_selectedCategory != null) {
      Navigator.of(context).pop(_selectedCategory);
    }
  }
}
