import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
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
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.privacy_tip_outlined,
                          color: Colors.blue.shade700,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Privacy Policy',
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
              'Information We Collect',
              'We collect information you provide directly to us, such as when you create an account, post a job, or apply for a job. This may include your name, email address, phone number, and other contact information.',
            ),
            
            _buildSection(
              'How We Use Your Information',
              'We use the information we collect to provide, maintain, and improve our services, communicate with you, process transactions, and ensure the security of our platform.',
            ),
            
            _buildSection(
              'Information Sharing',
              'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this privacy policy or as required by law.',
            ),
            
            _buildSection(
              'Data Security',
              'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
            ),
            
            _buildSection(
              'Your Rights',
              'You have the right to access, update, or delete your personal information. You can also opt out of certain communications from us.',
            ),
            
            _buildSection(
              'Cookies and Tracking',
              'We use cookies and similar technologies to enhance your experience, analyze usage patterns, and provide personalized content.',
            ),
            
            _buildSection(
              'Third-Party Services',
              'Our app may contain links to third-party websites or services. We are not responsible for the privacy practices of these external sites.',
            ),
            
            _buildSection(
              'Children\'s Privacy',
              'Our services are not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13.',
            ),
            
            _buildSection(
              'Changes to This Policy',
              'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the "Last updated" date.',
            ),
            
            _buildSection(
              'Contact Us',
              'If you have any questions about this privacy policy, please contact us at privacy@jobapp.com or through our support channels.',
            ),
            
            const SizedBox(height: 32),
            
            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Text(
                'By using our app, you agree to the terms outlined in this privacy policy. We are committed to protecting your privacy and ensuring the security of your personal information.',
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
