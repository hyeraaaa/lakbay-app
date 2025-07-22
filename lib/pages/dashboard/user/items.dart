import 'package:flutter/material.dart';
import '../../../models/item.dart';
import '../../../models/account.dart';
import '../../../pages/dashboard/transaction.dart';
import '../../../models/feedback.dart';
import '../../../services/feedback_service.dart';

class ItemDetailPage extends StatefulWidget {
  final Item item;
  final Account? user;

  const ItemDetailPage({super.key, required this.item, this.user});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int _selectedImageIndex = 0;
  bool _isFavorite = false;
  DateTime? _startDate;
  DateTime? _endDate;
  List<FeedbackEntry> _feedbackList = [];
  double _averageRating = 0.0;
  bool _isLoadingFeedback = true;

  @override
  void initState() {
    super.initState();
    _loadFeedback();
  }

  Future<void> _loadFeedback() async {
    final allFeedback = await FeedbackService.loadFeedback();
    final itemFeedback = allFeedback
        .where((f) => f.itemId == widget.item.id)
        .toList();
    double avg = 0.0;
    if (itemFeedback.isNotEmpty) {
      avg =
          itemFeedback.map((f) => f.rating).reduce((a, b) => a + b) /
          itemFeedback.length;
    }
    setState(() {
      _feedbackList = itemFeedback;
      _averageRating = avg;
      _isLoadingFeedback = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Image Gallery
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.black),
                ),
                onPressed: () {
                  // TODO: Implement share functionality
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.black,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Main Image
                  Container(
                    width: double.infinity,
                    height: 400,
                    child: Image.asset(
                      widget.item.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.car_rental,
                            size: 80,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  // Image Gallery Dots
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedImageIndex == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Product Information
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price per day
                  Text(
                    '₱${widget.item.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    'per day',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Vehicle Name
                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.item.location,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Divider
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  // Owner Information
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[200],
                        child: const Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vehicle Owner',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              'Online • Responds within 1 hour',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline),
                        onPressed: () {
                          // TODO: Implement chat functionality
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Date Selection
                  const Text(
                    'Select Rental Dates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _selectStartDate,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start Date',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _startDate != null
                                      ? _formatDate(_startDate!)
                                      : 'Select date',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: _selectEndDate,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'End Date',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _endDate != null
                                      ? _formatDate(_endDate!)
                                      : 'Select date',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Rental Summary
                  if (_startDate != null && _endDate != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rental Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Duration:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                '${_calculateDays()} days',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Daily Rate:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                '₱${widget.item.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Price:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                '₱${_calculateTotalPrice().toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 24),
                  // Vehicle Description
                  const Text(
                    'Vehicle Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Experience the perfect blend of comfort and style with this premium vehicle. '
                    'Perfect for your travel needs with excellent fuel efficiency and modern features. '
                    'Available for daily rental with flexible pickup and return options.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontFamily: 'Poppins',
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Feedback & Ratings Section
                  const Text(
                    'Feedback & Ratings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_isLoadingFeedback)
                    const Center(child: CircularProgressIndicator())
                  else if (_feedbackList.isEmpty)
                    const Text(
                      'No feedback yet.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  else ...[
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber[700], size: 24),
                        const SizedBox(width: 4),
                        Text(
                          _averageRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${_feedbackList.length} review${_feedbackList.length > 1 ? 's' : ''})',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _feedbackList.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 16),
                      itemBuilder: (context, index) {
                        final feedback = _feedbackList[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            child: const Icon(Icons.person, color: Colors.grey),
                          ),
                          title: Row(
                            children: [
                              ...List.generate(
                                5,
                                (i) => Icon(
                                  i < feedback.rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber[700],
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                feedback.date,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            feedback.comment,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 100), // Space for bottom buttons
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom Action Buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Contact Owner Button
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement contact owner
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contacting owner...'),
                          backgroundColor: Colors.black,
                        ),
                      );
                    },
                    child: const Text(
                      'Contact',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Rent Now Button
              Expanded(
                flex: 2,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_startDate == null || _endDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select rental dates first'),
                            backgroundColor: Colors.black,
                          ),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionPage(
                            item: widget.item,
                            user: widget.user,
                            startDate: _startDate,
                            endDate: _endDate,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Rent Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        // If end date is before start date, reset it
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a start date first'),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!.add(const Duration(days: 1)),
      firstDate: _startDate!.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int _calculateDays() {
    if (_startDate != null && _endDate != null) {
      return _endDate!.difference(_startDate!).inDays;
    }
    return 0;
  }

  double _calculateTotalPrice() {
    return _calculateDays() * widget.item.price.toDouble();
  }
}
