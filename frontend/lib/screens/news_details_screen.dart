import 'package:flutter/material.dart';

class NewsDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  NewsDetailsScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              article['description'] ?? 'No description available',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              article['content'] ?? 'No content available',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
} 