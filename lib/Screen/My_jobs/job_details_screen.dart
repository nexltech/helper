import 'package:flutter/material.dart';
import '../../models/job_model.dart';

class JobDetailsScreen extends StatelessWidget {
  final JobPost job;

  const JobDetailsScreen({
    super.key,
    required this.job,
  });

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
                _buildHeader(context),
                const SizedBox(height: 24),
                // Job Details Card
                _buildJobDetailsCard(),
                const SizedBox(height: 24),
                // Job Description Card
                _buildDescriptionCard(),
                const SizedBox(height: 24),
                // Job Image Card
                if (job.image != null && job.image!.isNotEmpty)
                  _buildImageCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 8),
        const Text(
          'Job Details',
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

  Widget _buildJobDetailsCard() {
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
          // Job Title
          Text(
            job.jobTitle,
            style: const TextStyle(
              fontFamily: 'FrederickaTheGreat',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          
          // Job Details
          _buildDetailRow(Icons.folder, 'Category', job.category.name, Colors.orange),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.account_balance_wallet, 'Payment', '\$${job.payment}', Colors.green),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.location_on, 'Location', job.address, Colors.red),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.calendar_today, 'Date & Time', job.dateTime, Colors.blue),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.person, 'Posted by', job.user?.name ?? 'User ID: ${job.userId}', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'LifeSavers',
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
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
          const Text(
            'Job Description',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(
              job.jobDescription,
              style: const TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard() {
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
          const Text(
            'Job Image',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: job.image!.startsWith('http')
                  ? Image.network(
                      job.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      job.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}