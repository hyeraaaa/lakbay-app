import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/item.dart';
import '../../../services/item_service.dart';
import '../../../widgets/item_card.dart';
import 'items.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Item> _allItems = [];
  List<Item> _filteredItems = [];
  List<String> _recentSearches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
    _loadRecentSearches();
    // _searchController.addListener(_onSearchChanged); // Remove live search
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    final items = await ItemService.loadItems();
    setState(() {
      _allItems = items;
      _filteredItems = items;
      _isLoading = false;
    });
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _addRecentSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 10) {
        _recentSearches = _recentSearches.sublist(0, 10);
      }
      prefs.setStringList('recent_searches', _recentSearches);
    });
  }

  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches.clear();
      prefs.setStringList('recent_searches', _recentSearches);
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _allItems;
      } else {
        _filteredItems = _allItems.where((item) {
          return item.name.toLowerCase().contains(query) ||
              item.location.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isEmpty) return;
    _addRecentSearch(query.trim());
    final search = query.trim().toLowerCase();
    setState(() {
      _filteredItems = _allItems.where((item) {
        return item.name.toLowerCase().contains(search) ||
            item.location.toLowerCase().contains(search);
      }).toList();
    });
  }

  void _onRecentSearchTap(String query) {
    _searchController.text = query;
    _onSearchSubmitted(query);
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget _buildResults() {
    if (_searchController.text.trim().isEmpty) {
      return const SizedBox.shrink();
    } else if (_filteredItems.isEmpty) {
      return const Center(
        child: Text(
          'No results found.',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else {
      return MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          return ItemCard(
            item: item,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailPage(item: item),
                ),
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.black,
                            size: 32,
                          ),
                          onPressed: () => Navigator.pop(context),
                          splashRadius: 22,
                        ),
                        Expanded(
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 12),
                                  const Icon(
                                    Icons.search,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'Search items...',
                                        hintStyle: TextStyle(
                                          color: Colors.black38,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      textInputAction: TextInputAction.search,
                                      onSubmitted: _onSearchSubmitted,
                                    ),
                                  ),
                                  if (_searchController.text.isNotEmpty)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.black38,
                                      ),
                                      splashRadius: 18,
                                      onPressed: _clearSearch,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_recentSearches.isNotEmpty &&
                      _searchController.text.isEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 0, 8),
                      child: Row(
                        children: [
                          const Text(
                            'Recent Searches',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _clearRecentSearches,
                            child: const Text(
                              'Clear',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_recentSearches.isNotEmpty &&
                      _searchController.text.isEmpty)
                    Container(
                      height: 38,
                      margin: const EdgeInsets.only(left: 8),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _recentSearches.length,
                        separatorBuilder: (context, i) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final search = _recentSearches[i];
                          return ActionChip(
                            label: Text(
                              search,
                              style: const TextStyle(color: Colors.black),
                            ),
                            backgroundColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide.none,
                            ),
                            onPressed: () => _onRecentSearchTap(search),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _buildResults(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
