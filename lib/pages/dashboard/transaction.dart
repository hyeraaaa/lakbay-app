import 'package:flutter/material.dart';
import '../../../models/item.dart';
import '../../../models/account.dart';

class TransactionPage extends StatefulWidget {
  final Item item;
  final Account? user;
  final DateTime? startDate;
  final DateTime? endDate;

  const TransactionPage({
    Key? key,
    required this.item,
    this.user,
    this.startDate,
    this.endDate,
  }) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  String _selectedPayment = 'GCash';

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}/${date.month}/${date.year}';
  }

  int _calculateDays() {
    if (widget.startDate != null && widget.endDate != null) {
      return widget.endDate!.difference(widget.startDate!).inDays;
    }
    return 0;
  }

  double _calculateTotalPrice() {
    return _calculateDays() * widget.item.price.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 36, color: Colors.black54),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user != null
                                ? '${widget.user!.firstName} ${widget.user!.lastName}'
                                : 'Guest',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            widget.user?.email ?? '-',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Item Details Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        widget.item.image,
                        width: 90,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 90,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.car_rental,
                            size: 32,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₱${widget.item.price} / day',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Location: ${widget.item.location}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.black45,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Start: ${_formatDate(widget.startDate)}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                size: 14,
                                color: Colors.black45,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'End: ${_formatDate(widget.endDate)}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Duration: ${_calculateDays()} days',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Payment Options Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 12),
                    RadioListTile<String>(
                      value: 'GCash',
                      groupValue: _selectedPayment,
                      onChanged: (value) {
                        setState(() {
                          _selectedPayment = value!;
                        });
                      },
                      title: Row(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet,
                            size: 28,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          const Text('GCash', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                    RadioListTile<String>(
                      value: 'PayMaya',
                      groupValue: _selectedPayment,
                      onChanged: (value) {
                        setState(() {
                          _selectedPayment = value!;
                        });
                      },
                      title: Row(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet,
                            size: 28,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          const Text('PayMaya', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                    RadioListTile<String>(
                      value: 'On-site Payment',
                      groupValue: _selectedPayment,
                      onChanged: (value) {
                        setState(() {
                          _selectedPayment = value!;
                        });
                      },
                      title: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 28,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'On-site Payment',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Order Summary Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Summary',
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
                        const Text('Subtotal', style: TextStyle(fontSize: 15)),
                        Text(
                          '₱${_calculateTotalPrice().toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Service Fee', style: TextStyle(fontSize: 15)),
                        Text('₱0', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₱${_calculateTotalPrice().toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80), // For bottom button spacing
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking confirmed with $_selectedPayment!'),
                  ),
                );
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Proceed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
