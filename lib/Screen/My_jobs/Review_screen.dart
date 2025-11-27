import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/review_provider.dart';
import '../../providers/user_provider.dart';

class ReviewScreen extends StatefulWidget {
  final int applicationId;
  final String jobTitle;
  
  const ReviewScreen({
    super.key,
    required this.applicationId,
    required this.jobTitle,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _commentController = TextEditingController();

  double _punctualityRating = 0.0;
  double _qualityRating = 0.0;
  double _communicationRating = 0.0;
  double _professionalismRating = 0.0;
  double _overallRating = 0.0;

  Widget _buildHorizontalRatingRow({
    required String label,
    required double rating,
    required Function(double) onRate,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                return IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 15,
                  onPressed: () => onRate(index + 1.0),
                  icon: Icon(
                    rating >= index + 1 ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ReviewProvider>(
          builder: (context, reviewProvider, child) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: true,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  iconTheme: const IconThemeData(color: Colors.black),
                  title: const SizedBox(),
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(color: Colors.white),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Center(
                        child: Text(
                          'Leave a Review',
                          style: TextStyle(
                            fontFamily: 'HomemadeApple',
                            fontSize: 28,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Job: ${widget.jobTitle}',
                          style: TextStyle(
                            fontFamily: 'LifeSavers',
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tell us how it went. Your feedback helps others in the community.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildHorizontalRatingRow(
                    label: 'Punctuality',
                    rating: _punctualityRating,
                    onRate: (val) => setState(() => _punctualityRating = val),
                  ),
                  _buildHorizontalRatingRow(
                    label: 'Work Quality',
                    rating: _qualityRating,
                    onRate: (val) => setState(() => _qualityRating = val),
                  ),
                  _buildHorizontalRatingRow(
                    label: 'Communication',
                    rating: _communicationRating,
                    onRate: (val) => setState(() => _communicationRating = val),
                  ),
                  _buildHorizontalRatingRow(
                    label: 'Professionalism',
                    rating: _professionalismRating,
                    onRate: (val) =>
                        setState(() => _professionalismRating = val),
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      'How was your overall experience?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              _overallRating = index + 1.0;
                            });
                          },
                          icon: Icon(
                            _overallRating >= index + 1
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Icon(Icons.comment,
                                  color: Color(0xFFB3AEE2), size: 20),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 0,
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: const Text(
                            'Comments',
                            style: TextStyle(
                              fontFamily: 'LifeSavers',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: reviewProvider.isLoading ? null : _submitReview,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: reviewProvider.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.black),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Error message display
                  if (reviewProvider.errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Text(
                        reviewProvider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ]),
              ),
            ),
          ],
        );
      },
    ),
  ));
  }

  Future<void> _submitReview() async {
    // Validate ratings
    if (_overallRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide an overall rating'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Get user provider to set auth token
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    
    if (userProvider.user?.token != null) {
      reviewProvider.setAuthToken(userProvider.user!.token!);
    }

    // Submit review
    final success = await reviewProvider.addReview(
      applicationId: widget.applicationId,
      rating: _overallRating.toInt(),
      comment: _commentController.text.trim(),
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      // Check if it's a conflict error (review already exists)
      final errorMessage = reviewProvider.errorMessage ?? 'Failed to submit review';
      final isConflictError = errorMessage.toLowerCase().contains('already reviewed') || 
                              errorMessage.toLowerCase().contains('already exists');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isConflictError 
              ? 'Review has already been added for this application'
              : errorMessage
          ),
          backgroundColor: isConflictError ? Colors.orange : Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
      
      // If it's a conflict error, also show a dialog for better UX
      if (isConflictError) {
        _showReviewExistsDialog();
      }
    }
  }

  void _showReviewExistsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Review Already Exists',
                style: const TextStyle(
                  fontFamily: 'HomemadeApple',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: const Text(
          'You have already submitted a review for this application. Each application can only be reviewed once.',
          style: TextStyle(
            fontFamily: 'LifeSavers',
            fontSize: 16,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                fontFamily: 'LifeSavers',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
