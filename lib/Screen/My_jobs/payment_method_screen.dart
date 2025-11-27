import 'package:flutter/material.dart';
import 'dart:io';
import 'package:job/Screen/My_jobs/card_details_screen.dart';
import 'package:job/Screen/My_jobs/job_summary_screen.dart';
import 'package:job/services/stripe_service.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String jobTitle;
  final int jobCategoryId;
  final double payment;
  final String address;
  final String dateTime;
  final String jobDescription;
  final File selectedImage;

  const PaymentMethodScreen({
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
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? _selectedPaymentMethod;
  bool _isProcessingPayment = false;

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
            'Choose Payment Method',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          
          // Payment Method Options
          _buildPaymentMethodOption(
            'Stripe Payment',
            'Secure payment with Stripe',
            Icons.credit_card,
            Colors.blue,
            'stripe',
          ),
          const SizedBox(height: 16),
          
          _buildPaymentMethodOption(
            'Credit/Debit Card',
            'Pay with your card',
            Icons.payment,
            Colors.orange,
            'card',
          ),
          const SizedBox(height: 16),
          
          _buildPaymentMethodOption(
            'Apple Pay',
            'Touch ID or Face ID',
            Icons.apple,
            Colors.black,
            'apple_pay',
          ),
          const SizedBox(height: 16),
          
          _buildPaymentMethodOption(
            'Google Pay',
            'Tap to pay',
            Icons.android,
            Colors.green,
            'google_pay',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String value,
  ) {
    final isSelected = _selectedPaymentMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.black26,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'LifeSavers',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'LifeSavers',
                      fontSize: 14,
                      color: isSelected ? color : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (_selectedPaymentMethod != null && !_isProcessingPayment) ? _handleContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedPaymentMethod != null ? Colors.white : Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: _selectedPaymentMethod != null ? Colors.black : Colors.grey,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
        ),
        child: _isProcessingPayment
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : Text(
                'Continue',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _selectedPaymentMethod != null ? Colors.black : Colors.grey,
                ),
              ),
      ),
    );
  }

  void _handleContinue() async {
    if (_selectedPaymentMethod == null) return;

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      if (_selectedPaymentMethod == 'stripe') {
        // Process Stripe payment
        bool paymentSuccess = await StripeService.instance.processPaymentWithDetails(
          amount: widget.payment,
          currency: 'usd',
          customerEmail: 'customer@example.com', // You can get this from user profile
          metadata: {
            'job_title': widget.jobTitle,
            'job_category_id': widget.jobCategoryId.toString(),
            'address': widget.address,
            'date_time': widget.dateTime,
          },
        );

        if (paymentSuccess) {
          // Payment successful - navigate to job summary
          _navigateToJobSummary();
        } else {
          // Payment failed
          _showPaymentErrorDialog('Payment failed. Please try again.');
        }
      } else {
        // For other payment methods, navigate to card details screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardDetailsScreen(
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
    } catch (e) {
      _showPaymentErrorDialog('An error occurred: $e');
    } finally {
      setState(() {
        _isProcessingPayment = false;
      });
    }
  }

  void _navigateToJobSummary() async {
    // Show brief success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Payment successful! Redirecting to job summary...',
          style: TextStyle(fontFamily: 'LifeSavers'),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );

    // Small delay to show success message
    await Future.delayed(const Duration(milliseconds: 1500));

    // Navigate to job summary screen
    if (mounted) {
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

  void _showPaymentErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Payment Error',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(fontFamily: 'LifeSavers'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
