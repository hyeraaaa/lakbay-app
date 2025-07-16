import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../models/item.dart';
import '../../../services/item_service.dart';
import '../../../widgets/item_card.dart';
import '../../../widgets/advertisement_card.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  List<Item> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final loadedItems = await ItemService.loadItems();
      setState(() {
        items = loadedItems;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lakbay', style: TextStyle(letterSpacing: 2.0)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: Colors.black),
            onPressed: () {
              // TODO: Implement search action
            },
          ),
          IconButton(
            icon: Icon(Icons.chat, color: Colors.black),
            onPressed: () {
              // TODO: Implement chat action
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFF5F5F5), // white smoke
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Cars',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemCount: items.length + 1, // +1 for advertisement card
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // First item is the advertisement card
                          return const AdvertisementCard(
                            onTap: null, // TODO: Implement advertisement tap
                          );
                        } else {
                          // Regular item cards (adjust index for items list)
                          final item = items[index - 1];
                          return ItemCard(
                            item: item,
                            onTap: () {
                              // TODO: Navigate to item details
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected: ${item.name}'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
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
        // TODO: Implement navigation logic and state management
      ),
    );
  }
}
