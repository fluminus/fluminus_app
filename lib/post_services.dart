import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Photos>> fetchPhotos() async {
  final response = await http.get("https://jsonplaceholder.typicode.com/photos");
  if(response.statusCode == 200) {
    return photosFromJson(response.body);
  } else {
    throw Exception('fail');
  }
}

main(List<String> args) async {
  final response = 
    await http.get("https://jsonplaceholder.typicode.com/photos");
  final photos = photosFromJson(response.body);
  print(photos[0].thumbnailUrl);
}

List<Photos> photosFromJson(String str) {
    final jsonData = json.decode(str);
    return new List<Photos>.from(jsonData.map((x) => Photos.fromJson(x)));
}

String photosToJson(List<Photos> data) {
    final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
    return json.encode(dyn);
}

class Photos {
    int albumId;
    int id;
    String title;
    String url;
    String thumbnailUrl;

    Photos({
        this.albumId,
        this.id,
        this.title,
        this.url,
        this.thumbnailUrl,
    });

    factory Photos.fromJson(Map<String, dynamic> json) => new Photos(
        albumId: json["albumId"],
        id: json["id"],
        title: json["title"],
        url: json["url"],
        thumbnailUrl: json["thumbnailUrl"],
    );

    Map<String, dynamic> toJson() => {
        "albumId": albumId,
        "id": id,
        "title": title,
        "url": url,
        "thumbnailUrl": thumbnailUrl,
    };
}