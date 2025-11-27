import 'package:flutter/material.dart';
import 'dart:io';
import 'package:job/Screen/My_jobs/job_summary_screen.dart';

class CardDetailsScreen extends StatefulWidget {
  final String jobTitle;
  final int jobCategoryId;
  final double payment;
  final String address;
  final String dateTime;
  final String jobDescription;
  final File selectedImage;

  const CardDetailsScreen({
    super.key,
    required this.jobTitle,
    required this.jobCategoryId,
    required this.payment,
    required this.address,
    required this.dateTime,
    required this.jobDescription,
    required this.selectedImage,
  });

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final _cvvController = TextEditingController();
  
  bool _saveCard = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _cvvController.dispose();
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
                // Credit Card Display
                _buildCreditCard(),
                const SizedBox(height: 24),
                // Form Fields
                _buildFormFields(),
                const SizedBox(height: 24),
                // Save Card Checkbox
                _buildSaveCardCheckbox(),
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
          'Payment',
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

  Widget _buildCreditCard() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B73FF), Color(0xFF9B59B6)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stripe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: 30,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.credit_card,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Card Number
            Text(
              _cardNumberController.text.isEmpty 
                ? '**** **** **** 2345' 
                : _cardNumberController.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const Spacer(),
            
            // Card Holder and Expiry
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Card Holder Name',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _nameController.text.isEmpty 
                        ? 'James Copper' 
                        : _nameController.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Expiry Date',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${_monthController.text.isEmpty ? "20" : _monthController.text}/${_yearController.text.isEmpty ? "30" : _yearController.text}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
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
            // Name on Card
            _buildInputField(
              label: 'Name on card',
              controller: _nameController,
              icon: Icons.person,
              hintText: 'Enter cardholder name',
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),
            
            // Card Number
            _buildInputField(
              label: 'Card number',
              controller: _cardNumberController,
              icon: Icons.credit_card,
              hintText: 'Enter card number',
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),
            
            // Month/Year and CVV Row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildInputField(
                    label: 'Month/Year',
                    controller: _monthController,
                    icon: Icons.calendar_today,
                    hintText: 'MM/YY',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    label: 'CVV',
                    controller: _cvvController,
                    icon: Icons.lock,
                    hintText: 'CVV',
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    ValueChanged<String>? onChanged,
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
            obscureText: obscureText,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontFamily: 'LifeSavers',
                color: Colors.black26,
              ),
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(icon, color: Colors.blue, size: 20),
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

  Widget _buildSaveCardCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _saveCard,
          onChanged: (value) {
            setState(() {
              _saveCard = value ?? false;
            });
          },
          activeColor: Colors.blue,
        ),
        const Text(
          'Save card for future purchases',
          style: TextStyle(
            fontFamily: 'LifeSavers',
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.black, width: 1),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
        ),
        child: const Text(
          'Continue',
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

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobSummaryScreen(
            jobTitle: widget.jobTitle,
            jobCategoryId: widget.jobCategoryId,
            payment: widget.payment,
            address: widget.address,
            dateTime: widget.dateTime,
            jobDescription: widget.jobDescription,
            selectedImage: widget.selectedImage,
          ),
        ),
      );
    }
  }
}
