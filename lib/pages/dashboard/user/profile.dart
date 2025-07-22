import 'package:flutter/material.dart';
import 'package:lakbay_app_1/models/account.dart';
import 'user.dart';
import 'notification.dart';
import '../../../models/item.dart';
import '../../../services/item_service.dart';
import '../../../widgets/item_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'myBookings.dart';
import 'items.dart';

class ProfilePage extends StatelessWidget {
  final Account? user;
  const ProfilePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 2;
    void _onTabTapped(int index) {
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserDashboardPage(user: user),
          ),
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage(user: user)),
        );
      } else if (index == 2) {
        // Already on Profile
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(letterSpacing: 2.0)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          if (user != null)
            IconButton(
              icon: Icon(Icons.logout, color: Colors.black),
              onPressed: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                );
                if (shouldLogout == true) {
                  // TODO: Implement actual logout logic, e.g., clear user session and navigate to login
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
            ),
        ],
      ),
      backgroundColor: Color(0xFFF5F5F5), // white smoke
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null)
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, size: 32, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${user!.firstName} ${user!.lastName}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user!.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            // Quick action cards for car rental statuses
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 4.0,
                          bottom: 4.0,
                          top: 4.0,
                        ),
                        child: Text(
                          'My Bookings',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ProfileActionMini(
                              icon: Icons.payment,
                              label: 'To Pay',
                              iconSize: 22,
                              textSize: 12,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MyBookingsPage(initialTabIndex: 0),
                                  ),
                                );
                              },
                            ),
                            _ProfileActionMini(
                              icon: Icons.check_circle_outline,
                              label: 'Completed',
                              iconSize: 22,
                              textSize: 12,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MyBookingsPage(initialTabIndex: 1),
                                  ),
                                );
                              },
                            ),
                            _ProfileActionMini(
                              icon: Icons.attach_money,
                              label: 'Refund',
                              iconSize: 22,
                              textSize: 12,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MyBookingsPage(initialTabIndex: 2),
                                  ),
                                );
                              },
                            ),
                            _ProfileActionMini(
                              icon: Icons.star_rate,
                              label: 'Rate',
                              iconSize: 22,
                              textSize: 12,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MyBookingsPage(initialTabIndex: 3),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // More Activities section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 4.0,
                          bottom: 4.0,
                          top: 4.0,
                        ),
                        child: Text(
                          'More Activities',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      // Change activities to a row
                      Row(
                        children: [
                          Expanded(
                            child: _ProfileActivityRect(
                              icon: Icons.replay,
                              label: 'Book Again',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Book Again tapped')),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ProfileActivityRect(
                              icon: Icons.history,
                              label: 'Recently Viewed',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Recently Viewed tapped'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Support section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 4.0,
                          bottom: 4.0,
                          top: 4.0,
                        ),
                        child: Text(
                          'Support',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      _ProfileActivityRect(
                        icon: Icons.chat_bubble_outline,
                        label: 'Chat with Lakbay',
                        borderless: true,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Chat with Lakbay tapped')),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Divider(
                          height: 1,
                          color: Colors.grey.shade300,
                          thickness: 0.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _ProfileActivityRect(
                        icon: Icons.help_outline,
                        label: 'Help Centre',
                        borderless: true,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Help Centre tapped')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'You may also like',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<Item>>(
                future: ItemService.loadItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error loading items'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No items found'));
                  }
                  final items = snapshot.data!;
                  return MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ItemCard(
                        item: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ItemDetailPage(item: item, user: user),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class _ProfileActionMini extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double iconSize;
  final double textSize;
  const _ProfileActionMini({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconSize = 22,
    this.textSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: iconSize, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProfileActivityRect extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool borderless;
  const _ProfileActivityRect({
    required this.icon,
    required this.label,
    required this.onTap,
    this.borderless = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          border: borderless
              ? null
              : Border.all(color: Colors.grey.shade300, width: 1.2),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
