import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
          'Terms of Service',
          style: TextStyle(
            fontFamily: 'FrederickatheGreat',
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE3F2FD), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.description_outlined,
                          color: Colors.amber.shade700,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Terms of Service',
                          style: TextStyle(
                            fontFamily: 'FrederickatheGreat',
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Last updated: December 2024',
                    style: TextStyle(
                      fontFamily: 'LifeSavers',
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Content Sections
            _buildSection(
              'Acceptance of Terms',
              'By accessing and using our job platform app, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
            ),
            
            _buildSection(
              'Description of Service',
              'Our platform connects job seekers with employers, allowing users to post jobs, apply for positions, and manage their professional profiles. We provide a marketplace for employment opportunities.',
            ),
            
            _buildSection(
              'User Accounts',
              'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account or password.',
            ),
            
            _buildSection(
              'User Conduct',
              'Users agree not to use the service for any unlawful purpose or any purpose prohibited under this clause. You may not use the service in any manner that could damage, disable, overburden, or impair any server.',
            ),
            
            _buildSection(
              'Job Postings and Applications',
              'Employers are responsible for the accuracy of job postings. Job seekers are responsible for the accuracy of their applications. We reserve the right to remove any content that violates our terms.',
            ),
            
            _buildSection(
              'Payment Terms',
              'Some features of our service may require payment. All fees are non-refundable unless otherwise stated. Payment terms and conditions will be clearly displayed before any transaction.',
            ),
            
            _buildSection(
              'Intellectual Property',
              'The service and its original content, features, and functionality are and will remain the exclusive property of our company and its licensors. The service is protected by copyright, trademark, and other laws.',
            ),
            
            _buildSection(
              'Privacy Policy',
              'Your privacy is important to us. Please review our Privacy Policy, which also governs your use of the service, to understand our practices.',
            ),
            
            _buildSection(
              'Prohibited Uses',
              'You may not use our service for any purpose that is unlawful or prohibited by these Terms of Service, or to solicit others to perform or participate in any unlawful acts.',
            ),
            
            _buildSection(
              'Termination',
              'We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.',
            ),
            
            _buildSection(
              'Disclaimer of Warranties',
              'The information on this service is provided on an "as is" basis. To the fullest extent permitted by law, this company excludes all representations, warranties, conditions and terms.',
            ),
            
            _buildSection(
              'Limitation of Liability',
              'In no event shall our company, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential, or punitive damages.',
            ),
            
            _buildSection(
              'Governing Law',
              'These Terms shall be interpreted and governed by the laws of the jurisdiction in which our company operates, without regard to its conflict of law provisions.',
            ),
            
            _buildSection(
              'Changes to Terms',
              'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will try to provide at least 30 days notice prior to any new terms taking effect.',
            ),
            
            _buildSection(
              'Contact Information',
              'If you have any questions about these Terms of Service, please contact us at legal@jobapp.com or through our support channels.',
            ),
            
            const SizedBox(height: 32),
            
            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Text(
                'By using our app, you acknowledge that you have read and understood these terms and agree to be bound by them. These terms constitute a legally binding agreement between you and our company.',
                style: TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3F2FD), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'FrederickatheGreat',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 16,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
