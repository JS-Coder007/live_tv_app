import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/channel.dart';

class M3UService {
  // Using the raw link for stability
  static const String playlistUrl = 'https://iptv-org.github.io/iptv/index.m3u';

  Future<List<Channel>> fetchChannels() async {
    try {
      final response = await http.get(Uri.parse(playlistUrl));

      if (response.statusCode == 200) {
        return parseM3U(response.body);
      } else {
        throw Exception('Failed to load playlist');
      }
    } catch (e) {
      throw Exception('Error fetching playlist: $e');
    }
  }

  List<Channel> parseM3U(String content) {
    final List<Channel> channels = [];
    final lines = LineSplitter.split(content).toList();
    
    String? name;
    String? logoUrl;
    String? category;
    String? id;

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();

      if (line.startsWith('#EXTINF:')) {
        // Parse metadata
        // Example: #EXTINF:-1 tvg-id="CNN.us" tvg-name="CNN" tvg-logo="..." group-title="News",CNN
        
        // Extract Logo
        final logoMatch = RegExp(r'tvg-logo="([^"]*)"').firstMatch(line);
        logoUrl = logoMatch?.group(1) ?? '';

        // Extract Group/Category
        final groupMatch = RegExp(r'group-title="([^"]*)"').firstMatch(line);
        category = groupMatch?.group(1) ?? 'Uncategorized';

        // Extract ID (optional)
        final idMatch = RegExp(r'tvg-id="([^"]*)"').firstMatch(line);
        id = idMatch?.group(1) ?? '';

        // Extract Name (after last comma)
        final nameParts = line.split(',');
        if (nameParts.isNotEmpty) {
          name = nameParts.last.trim();
        }
      } else if (line.isNotEmpty && !line.startsWith('#')) {
        // This is the URL line
        if (name != null && name.isNotEmpty) {
           channels.add(Channel(
             id: id ?? name, // Fallback ID
             name: name,
             logoUrl: logoUrl ?? '',
             streamUrl: line,
             category: category ?? 'Uncategorized',
           ));
        }
        // Reset for next channel
        name = null;
        logoUrl = null;
        category = null;
        id = null;
      }
    }
    return channels;
  }
}
