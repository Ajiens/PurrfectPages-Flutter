// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

List<Book> bookFromJson(String str) => List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
    String model;
    int pk;
    Fields fields;

    Book({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String title;
    String coverLink;
    String author;
    int ratingCount;
    int reviewCount;
    double averageRating;
    int fiveStarRatings;
    int fourStarRatings;
    int threeStarRatings;
    int twoStarRatings;
    int oneStarRatings;
    int numberOfPages;
    String datePublished;
    String publisher;
    int isbn;
    String description;
    int harga;
    bool isAvailable;

    Fields({
        required this.title,
        required this.coverLink,
        required this.author,
        required this.ratingCount,
        required this.reviewCount,
        required this.averageRating,
        required this.fiveStarRatings,
        required this.fourStarRatings,
        required this.threeStarRatings,
        required this.twoStarRatings,
        required this.oneStarRatings,
        required this.numberOfPages,
        required this.datePublished,
        required this.publisher,
        required this.isbn,
        required this.description,
        required this.harga,
        required this.isAvailable,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        coverLink: json["cover_link"],
        author: json["author"],
        ratingCount: json["rating_count"],
        reviewCount: json["review_count"],
        averageRating: json["average_rating"]?.toDouble(),
        fiveStarRatings: json["five_star_ratings"],
        fourStarRatings: json["four_star_ratings"],
        threeStarRatings: json["three_star_ratings"],
        twoStarRatings: json["two_star_ratings"],
        oneStarRatings: json["one_star_ratings"],
        numberOfPages: json["number_of_pages"],
        datePublished: json["date_published"],
        publisher: json["publisher"],
        isbn: json["isbn"],
        description: json["description"],
        harga: json["harga"],
        isAvailable: json["is_available"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "cover_link": coverLink,
        "author": author,
        "rating_count": ratingCount,
        "review_count": reviewCount,
        "average_rating": averageRating,
        "five_star_ratings": fiveStarRatings,
        "four_star_ratings": fourStarRatings,
        "three_star_ratings": threeStarRatings,
        "two_star_ratings": twoStarRatings,
        "one_star_ratings": oneStarRatings,
        "number_of_pages": numberOfPages,
        "date_published": datePublished,
        "publisher": publisher,
        "isbn": isbn,
        "description": description,
        "harga": harga,
        "is_available": isAvailable,
    };
}
