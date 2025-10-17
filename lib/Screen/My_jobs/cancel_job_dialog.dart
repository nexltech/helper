import 'package:flutter/material.dart';

class CancelJobDialog extends StatefulWidget {
  final String jobTitle;
  final VoidCallback onConfirm;

  const CancelJobDialog({
    super.key,
    required this.jobTitle,
    required this.onConfirm,
  });

  @override
  State<CancelJobDialog> createState() => _CancelJobDialogState();
}

class _CancelJobDialogState extends State<CancelJobDialog> {
  String? _selectedReason;
  final TextEditingController _commentsController = TextEditingController();
  final List<String> _reasons = [
    'I no longer need the service',
    'I found someone outside Helpr',
    'Other:',
  ];

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Cancel Job',
              style: TextStyle(
                fontFamily: 'HomemadeApple',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            
            // Description
            Text(
              'We understand things don\'t always go as planned. Let us know why you\'re canceling so we can improve your experience in the future.',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            
            // Reason Selection
            Text(
              'Select a reason: (required)',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            
            // Reason Options
            ...List.generate(_reasons.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RadioListTile<String>(
                  value: _reasons[index],
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value;
                    });
                  },
                  title: Text(
                    _reasons[index],
                    style: TextStyle(
                      fontFamily: 'LifeSavers',
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              );
            }),
            
            const SizedBox(height: 16),
            
            // Comments Section
            Text(
              'Comments',
              style: TextStyle(
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
              child: TextField(
                controller: _commentsController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tell us more about your cancellation...',
                  hintStyle: TextStyle(
                    fontFamily: 'LifeSavers',
                    color: Colors.black26,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                  prefixIcon: const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.black26,
                    size: 20,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black26),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedReason != null ? _handleCancel : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedReason != null ? Colors.red : Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _selectedReason != null ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleCancel() {
    if (_selectedReason != null) {
      Navigator.of(context).pop();
      // Show confirmation dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => JobCanceledDialog(
          jobTitle: widget.jobTitle,
          reason: _selectedReason!,
          comments: _commentsController.text,
          onConfirm: widget.onConfirm,
        ),
      );
    }
  }
}

class JobCanceledDialog extends StatelessWidget {
  final String jobTitle;
  final String reason;
  final String comments;
  final VoidCallback onConfirm;

  const JobCanceledDialog({
    super.key,
    required this.jobTitle,
    required this.reason,
    required this.comments,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Job Canceled',
              style: TextStyle(
                fontFamily: 'HomemadeApple',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            
            // Main message
            Text(
              'We\'ve removed this job from your active list. Any involved parties have been notified.',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            
            // What happens next section
            Text(
              'What happens next?',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            
            _buildBulletPoint('If a payment was made, it will be refunded according to our policy.'),
            _buildBulletPoint('If a worker was assigned, they\'ve been notified of the cancellation.'),
            _buildBulletPoint('You can always post a new job when you\'re ready.'),
            
            const SizedBox(height: 20),
            
            // Need help section
            Row(
              children: [
                const Text('🙋‍♂️', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'If this was a mistake or you need assistance, contact us at hellohelpr@gmail.com',
                    style: TextStyle(
                      fontFamily: 'LifeSavers',
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // OK Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm(); // Call the delete API
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                child: Text(
                  'Ok',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontFamily: 'LifeSavers',
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 14,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
