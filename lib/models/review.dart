// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    int id;
    int bookId;
    int userId;
    String komentar;
    int ratingUser;
    DateTime dateAdded;

    Review({
        required this.id,
        required this.bookId,
        required this.userId,
        required this.komentar,
        required this.ratingUser,
        required this.dateAdded,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        bookId: json["book_id"],
        userId: json["user_id"],
        komentar: json["komentar"],
        ratingUser: json["rating_user"],
        dateAdded: DateTime.parse(json["date_added"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "book_id": bookId,
        "user_id": userId,
        "komentar": komentar,
        "rating_user": ratingUser,
        "date_added": "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
    };
}