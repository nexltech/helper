import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import '../../providers/user_provider.dart';
import '../../services/stripe_service.dart';
import '../jobBoarding/navbar.dart';

class PaymentSetupScreen extends StatefulWidget {
  const PaymentSetupScreen({super.key});

  @override
  State<PaymentSetupScreen> createState() => _PaymentSetupScreenState();
}

class _PaymentSetupScreenState extends State<PaymentSetupScreen> {
  List<SavedCard> _savedCards = [];
  List<PaymentMethod> _paymentMethods = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPaymentData();
  }

  void _loadPaymentData() {
    setState(() {
      _isLoading = true;
    });

    // TODO: Replace with actual API calls
    // For now, using mock data
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _savedCards = _getMockCards();
        _paymentMethods = _getPaymentMethods();
        _isLoading = false;
      });
    });
  }

  List<SavedCard> _getMockCards() {
    return [
      SavedCard(
        id: '1',
        last4: '4242',
        brand: 'Visa',
        expiryMonth: 12,
        expiryYear: 2025,
        isDefault: true,
      ),
      SavedCard(
        id: '2',
        last4: '8888',
        brand: 'Mastercard',
        expiryMonth: 6,
        expiryYear: 2026,
        isDefault: false,
      ),
    ];
  }

  List<PaymentMethod> _getPaymentMethods() {
    final methods = <PaymentMethod>[
      PaymentMethod(
        id: 'stripe',
        name: 'Stripe',
        type: 'stripe',
        isEnabled: true,
        icon: Icons.credit_card,
        color: Colors.blue,
      ),
    ];

    // Add Apple Pay if iOS
    if (Platform.isIOS) {
      methods.add(PaymentMethod(
        id: 'apple_pay',
        name: 'Apple Pay',
        type: 'apple_pay',
        isEnabled: true,
        icon: Icons.apple,
        color: Colors.black,
      ));
    }

    // Add PayPal
    methods.add(PaymentMethod(
      id: 'paypal',
      name: 'PayPal',
      type: 'paypal',
      isEnabled: true,
      icon: Icons.account_balance_wallet,
      color: Colors.blue.shade700,
    ));

    return methods;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () async {
                        _loadPaymentData();
                      },
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Saved Cards Section
                            _buildSavedCardsSection(),
                            const SizedBox(height: 24),
                            // Payment Methods Section
                            _buildPaymentMethodsSection(),
                            const SizedBox(height: 24),
                            // Payment History Section
                            _buildPaymentHistorySection(),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCard,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Payment Setup',
              style: TextStyle(
                fontFamily: 'HomemadeApple',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedCardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Saved Payment Methods',
          style: TextStyle(
            fontFamily: 'HomemadeApple',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        if (_savedCards.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.credit_card, size: 48, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'No saved cards',
                    style: TextStyle(
                      fontFamily: 'LifeSavers',
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ..._savedCards.map((card) => _buildCardItem(card)),
      ],
    );
  }

  Widget _buildCardItem(SavedCard card) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: card.isDefault ? Colors.blue : Colors.grey[200]!,
          width: card.isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Card Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getCardBrandColor(card.brand).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.credit_card,
              color: _getCardBrandColor(card.brand),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Card Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      card.brand,
                      style: const TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (card.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'DEFAULT',
                          style: TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '•••• •••• •••• ${card.last4}',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expires ${card.expiryMonth.toString().padLeft(2, '0')}/${card.expiryYear}',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          // Actions
          PopupMenuButton(
            itemBuilder: (context) => [
              if (!card.isDefault)
                PopupMenuItem(
                  child: const Text('Set as Default'),
                  onTap: () => _setDefaultCard(card),
                ),
              PopupMenuItem(
                child: const Text('Remove'),
                onTap: () => _removeCard(card),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Methods',
          style: TextStyle(
            fontFamily: 'HomemadeApple',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ..._paymentMethods.map((method) => _buildPaymentMethodItem(method)),
      ],
    );
  }

  Widget _buildPaymentMethodItem(PaymentMethod method) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: method.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              method.icon,
              color: method.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.name,
                  style: const TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getPaymentMethodDescription(method.type),
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: method.isEnabled,
            onChanged: (value) => _togglePaymentMethod(method, value),
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Payments',
          style: TextStyle(
            fontFamily: 'HomemadeApple',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.history, size: 48, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No payment history yet',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your payment history will appear here',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getCardBrandColor(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return Colors.blue;
      case 'mastercard':
        return Colors.orange;
      case 'amex':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getPaymentMethodDescription(String type) {
    switch (type) {
      case 'stripe':
        return 'Secure payments via Stripe';
      case 'apple_pay':
        return 'Pay with Touch ID or Face ID';
      case 'paypal':
        return 'Pay with your PayPal account';
      default:
        return 'Payment method';
    }
  }

  void _addNewCard() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment Card'),
        content: const Text('Card addition functionality will be integrated with Stripe API.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to add card screen or show Stripe payment sheet
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Card addition - Coming soon with Stripe integration'),
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _setDefaultCard(SavedCard card) {
    setState(() {
      for (var c in _savedCards) {
        c.isDefault = c.id == card.id;
      }
    });
    // TODO: Call API to set default card
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Default card updated')),
    );
  }

  void _removeCard(SavedCard card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Card'),
        content: Text('Are you sure you want to remove ${card.brand} ending in ${card.last4}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _savedCards.removeWhere((c) => c.id == card.id);
              });
              Navigator.pop(context);
              // TODO: Call API to remove card
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Card removed')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _togglePaymentMethod(PaymentMethod method, bool value) {
    setState(() {
      method.isEnabled = value;
    });
    // TODO: Call API to update payment method preference
  }
}

class SavedCard {
  final String id;
  final String last4;
  final String brand;
  final int expiryMonth;
  final int expiryYear;
  bool isDefault;

  SavedCard({
    required this.id,
    required this.last4,
    required this.brand,
    required this.expiryMonth,
    required this.expiryYear,
    this.isDefault = false,
  });
}

class PaymentMethod {
  final String id;
  final String name;
  final String type;
  bool isEnabled;
  final IconData icon;
  final Color color;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    required this.isEnabled,
    required this.icon,
    required this.color,
  });
}

