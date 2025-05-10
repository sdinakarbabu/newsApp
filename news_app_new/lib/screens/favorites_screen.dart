import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'news_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorites yet'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final article = snapshot.data![index];
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
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeFromFavorites(article),
                    ),
                    onTap: () {
                      Get.to(() => NewsDetailsScreen(article: article));
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    return favorites.map((article) => json.decode(article) as Map<String, dynamic>).toList();
  }

  Future<void> _removeFromFavorites(Map<String, dynamic> article) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('favorites') ?? [];
      final articleJson = json.encode(article);
      
      if (favorites.contains(articleJson)) {
        favorites.remove(articleJson);
        await prefs.setStringList('favorites', favorites);
        Get.snackbar('Success', 'Article removed from favorites');
        // Refresh the screen
        Get.forceAppUpdate();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove from favorites: $e');
    }
  }
} 