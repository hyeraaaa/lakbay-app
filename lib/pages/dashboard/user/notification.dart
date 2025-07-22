import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lakbay_app_1/models/account.dart';
import 'profile.dart';
import 'user.dart';

class NotificationPage extends StatefulWidget {
  final Account? user;
  const NotificationPage({super.key, this.user});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _currentIndex = 1;
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/notification.json',
      );
      final List<dynamic> data = json.decode(response);
      setState(() {
        notifications = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading notifications: $e');
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserDashboardPage(user: widget.user),
        ),
      );
    } else if (index == 1) {
      // Already on Notifications
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(user: widget.user)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification', style: TextStyle(letterSpacing: 2.0)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      backgroundColor: Color(0xFFF5F5F5), // white smoke
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? Center(
              child: Text(
                'No notifications yet.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      notif['title'] ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notif['message'] ?? ''),
                        const SizedBox(height: 4),
                        Text(
                          notif['timestamp'] ?? '',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
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
