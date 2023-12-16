import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book List',
      home: BookListScreen(),
    );
  }
}

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> books;

  @override
  void initState() {
    super.initState();
    books = getBooks();
  }

  Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse('YOUR_API_URL'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load books from server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book List'),
      ),
      body: FutureBuilder<List<Book>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final book = snapshot.data![index];
                return BookCard(book: book);
              },
            );
          } else {
            // Show a loading indicator while waiting for the books
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class Book {
  final int id;
  final String title;
  final String author;
  final String coverLink;
  final double averageRating;

  Book({required this.id, required this.title, required this.author, required this.coverLink, required this.averageRating});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      coverLink: json['cover_link'],
      averageRating: json['average_rating'].toDouble(),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;

  BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookDescriptionScreen(bookId: book.id)),
      ),
      child: Card(
        child: Column(
          children: <Widget>[
            Image.network(book.coverLink),
            ListTile(
              title: Text(book.title),
              subtitle: Text(book.author),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.star, color: Colors.amber),
                  Text(book.averageRating.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookDescriptionScreen extends StatelessWidget {
  final int bookId;

  BookDescriptionScreen({required this.bookId});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement the book description screen
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Description'),
      ),
      body: Center(
        child: Text('Description for book ID $bookId'),
      ),
    );
  }
}