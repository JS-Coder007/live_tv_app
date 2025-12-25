import 'dart:convert';

class Channel {
  final String id;
  final String name;
  final String logoUrl;
  final String streamUrl;
  final String category;

  Channel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.streamUrl,
    required this.category,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      streamUrl: json['streamUrl'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'streamUrl': streamUrl,
      'category': category,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Channel &&
      other.streamUrl == streamUrl; // Use streamUrl as unique identifier if id is weak
  }

  @override
  int get hashCode => streamUrl.hashCode;
}
