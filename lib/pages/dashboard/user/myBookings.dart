import 'package:flutter/material.dart';
import '../../../models/booking.dart';
import '../../../services/booking_service.dart';
import '../../../models/item.dart';
import '../../../services/item_service.dart';

class MyBookingsPage extends StatefulWidget {
  final int initialTabIndex;
  const MyBookingsPage({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Booking> _bookings = [];
  List<Item> _items = [];
  bool _isLoading = true;

  final List<Tab> _tabs = const [
    Tab(text: 'To Pay'),
    Tab(text: 'Completed'),
    Tab(text: 'Refund'),
    Tab(text: 'Rate'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _loadData();
  }

  Future<void> _loadData() async {
    final bookings = await BookingService.loadBookings();
    final items = await ItemService.loadItems();
    setState(() {
      _bookings = bookings;
      _items = items;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.normal,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList('to_pay'),
                _buildBookingList('completed'),
                _buildBookingList('refund'),
                _buildBookingList('rate'),
              ],
            ),
    );
  }

  Widget _buildBookingList(String status) {
    final filtered = _bookings.where((b) => b.status == status).toList();
    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'No ${_capitalize(status)} bookings yet.',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final booking = filtered[index];
        final item = _items.firstWhere(
          (i) => i.id == booking.itemId,
          orElse: () =>
              Item(id: 0, name: 'Unknown', price: 0, location: '', image: ''),
        );
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          leading: item.image.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item.image,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(Icons.directions_car, color: Colors.black, size: 40),
          title: Text(
            item.name,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${item.location}\nDate: ${booking.date}\nPrice: ₱${item.price}\nTotal: ₱${booking.amount}',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
        );
      },
    );
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
