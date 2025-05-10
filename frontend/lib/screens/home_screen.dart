import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'news_details_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatelessWidget {
  final RxList<dynamic> news = <dynamic>[].obs;
  final RxString selectedCategory = ''.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Fetch news when the screen loads
    fetchNews('');
    
    return Scaffold(
      appBar: AppBar(
        title: Text('News Aggregator'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Get.to(() => FavoritesScreen());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    fetchNews(searchController.text);
                  },
                ),
              ),
              onSubmitted: (value) {
                fetchNews(value);
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip(''),
                _buildCategoryChip('business'),
                _buildCategoryChip('sports'),
                _buildCategoryChip('technology'),
                _buildCategoryChip('entertainment'),
                _buildCategoryChip('health'),
                _buildCategoryChip('science'),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (news.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return RefreshIndicator(
                onRefresh: () async {
                  fetchNews(searchController.text);
                },
                child: ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                    final article = news[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text(
                          article['title'] ?? 'No title',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(article['description'] ?? 'No description'),
                            SizedBox(height: 4),
                            Text(
                              'Source: ${article['source']['name'] ?? 'Unknown'}',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.favorite_border),
                          onPressed: () => _addToFavorites(article),
                        ),
                        onTap: () {
                          Get.to(() => NewsDetailsScreen(article: article));
                        },
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChoiceChip(
        label: Text(category.isEmpty ? 'All' : category),
        selected: selectedCategory.value == category,
        onSelected: (selected) {
          selectedCategory.value = category;
          fetchNews('');
        },
      ),
    );
  }

  void fetchNews(String query) async {
    try {
      String url = 'http://localhost:3000/api/news';
      if (query.isNotEmpty) {
        url = 'http://localhost:3000/api/news/search?q=$query';
      } else if (selectedCategory.value.isNotEmpty) {
        url = 'http://localhost:3000/api/news/category/${selectedCategory.value}';
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['articles'] != null) {
          news.value = data['articles'];
        } else {
          Get.snackbar('Error', 'No articles found');
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch news: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server: $e');
    }
  }

  Future<void> _addToFavorites(Map<String, dynamic> article) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('favorites') ?? [];
      
      // Check if article is already in favorites
      final articleJson = json.encode(article);
      if (!favorites.contains(articleJson)) {
        favorites.add(articleJson);
        await prefs.setStringList('favorites', favorites);
        Get.snackbar('Success', 'Article added to favorites');
      } else {
        Get.snackbar('Info', 'Article already in favorites');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add to favorites: $e');
    }
  }
} 