import 'package:flutter/material.dart';
import '../main/login.dart';
import 'navbar.dart';

class Profile extends StatefulWidget {
  final String username;

  const Profile({Key? key, required this.username}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _currentIndex = 2;
  String description = "How's your day?"; // Deskripsi awal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil User'),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.pink,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Table(
              columnWidths: {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Username:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          widget.username,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Deskripsi:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          description,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showEditDialog();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              child: Text("Edit Profil"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.pink,
      ),
    );
  }

  // Fungsi untuk menampilkan dialog edit profil
  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Profil"),
          content: TextField(
            onChanged: (value) {
              setState(() {
                description = value;
              });
            },
            decoration: InputDecoration(labelText: "Deskripsi"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Implementasi penyimpanan deskripsi ke server atau penyimpanan lokal
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
