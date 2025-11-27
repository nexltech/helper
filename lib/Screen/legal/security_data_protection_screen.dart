import 'package:flutter/material.dart';

class SecurityDataProtectionScreen extends StatelessWidget {
  const SecurityDataProtectionScreen({super.key});

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
          'Security & Data Protection',
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
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.security_outlined,
                          color: Colors.red.shade700,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Security & Data Protection',
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
              'Data Encryption',
              'All data transmitted between your device and our servers is encrypted using industry-standard SSL/TLS protocols. This ensures that your personal information remains secure during transmission.',
            ),
            
            _buildSection(
              'Secure Storage',
              'Your personal data is stored on secure servers with multiple layers of protection, including encryption at rest, access controls, and regular security audits.',
            ),
            
            _buildSection(
              'Authentication & Access Control',
              'We implement multi-factor authentication and role-based access controls to ensure that only authorized personnel can access your data. All access is logged and monitored.',
            ),
            
            _buildSection(
              'Regular Security Audits',
              'Our systems undergo regular security assessments and penetration testing by third-party security experts to identify and address potential vulnerabilities.',
            ),
            
            _buildSection(
              'Data Minimization',
              'We collect and process only the minimum amount of personal data necessary to provide our services. We regularly review and purge unnecessary data.',
            ),
            
            _buildSection(
              'User Data Rights',
              'You have the right to access, rectify, erase, or port your personal data. You can also object to processing or request restriction of processing of your data.',
            ),
            
            _buildSection(
              'Data Breach Response',
              'In the unlikely event of a data breach, we will notify affected users and relevant authorities within 72 hours, as required by applicable data protection laws.',
            ),
            
            _buildSection(
              'Third-Party Security',
              'We carefully vet all third-party service providers and ensure they meet our security standards. All data sharing agreements include strict security requirements.',
            ),
            
            _buildSection(
              'Secure Development',
              'Our development team follows secure coding practices and conducts regular security training. All code changes undergo security review before deployment.',
            ),
            
            _buildSection(
              'Incident Response',
              'We maintain a comprehensive incident response plan to quickly detect, contain, and remediate any security incidents that may affect user data.',
            ),
            
            _buildSection(
              'Compliance Standards',
              'Our security practices comply with industry standards including ISO 27001, SOC 2, and applicable data protection regulations such as GDPR and CCPA.',
            ),
            
            _buildSection(
              'User Security Features',
              'We provide security features such as two-factor authentication, login notifications, and the ability to review and revoke app permissions.',
            ),
            
            _buildSection(
              'Data Retention',
              'We retain your personal data only for as long as necessary to provide our services or as required by law. Data is securely deleted when no longer needed.',
            ),
            
            _buildSection(
              'International Transfers',
              'When transferring data internationally, we ensure adequate protection through standard contractual clauses or other appropriate safeguards.',
            ),
            
            _buildSection(
              'Security Monitoring',
              'We continuously monitor our systems for suspicious activity and maintain 24/7 security operations to protect against threats.',
            ),
            
            _buildSection(
              'Contact Security Team',
              'If you have security concerns or need to report a security incident, please contact our security team at security@jobapp.com immediately.',
            ),
            
            const SizedBox(height: 32),
            
            // Security Tips Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.green.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Security Tips for Users',
                        style: TextStyle(
                          fontFamily: 'FrederickatheGreat',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '• Use strong, unique passwords for your account\n• Enable two-factor authentication when available\n• Keep your app updated to the latest version\n• Be cautious of phishing attempts and suspicious links\n• Log out from shared devices\n• Report any suspicious activity immediately',
                    style: TextStyle(
                      fontFamily: 'LifeSavers',
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: const Text(
                'Your security and privacy are our top priorities. We continuously work to maintain the highest standards of data protection and security for all our users.',
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
