import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookSearchScreen extends StatefulWidget {
  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  List<dynamic> _searchResults = [];
  TextEditingController _searchController = TextEditingController();

  void _searchBooks(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    String apiUrl =
        'https://openlibrary.org/search.json?title=${query.replaceAll(' ', '%20')}';
    http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> data = json.decode(response.body);
        _searchResults = data['docs'];
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 218, 167),
      appBar: AppBar(
        title: Text('Book Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) => _searchBooks(query),
              decoration: InputDecoration(
                hintText: 'Search books...',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length > 30 ? 30 : _searchResults.length,
              itemBuilder: (context, index) {
                final bookData = _searchResults[index];
                final title = bookData['title'] ?? 'Title not available';
                final author = bookData['author_name'] != null
                    ? bookData['author_name'][0]
                    : 'Author not available';
                final coverUrl = 'http://covers.openlibrary.org/b/id/${bookData['cover_i']}-L.jpg';

                return Container(
                  padding: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(coverUrl),
                    title: Text(title),
                    subtitle: Text(author),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
