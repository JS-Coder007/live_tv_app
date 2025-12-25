import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/channel.dart';

class FavoritesService {
  static const String _keyFavorites = 'favorites';

  Future<List<Channel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_keyFavorites);

    if (favoritesJson != null) {
      final List<dynamic> decoded = jsonDecode(favoritesJson);
      return decoded.map((item) => Channel.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> addFavorite(Channel channel) async {
    final prefs = await SharedPreferences.getInstance();
    List<Channel> currentFavorites = await getFavorites();
    
    // Check if already exists
    if (!currentFavorites.any((c) => c.streamUrl == channel.streamUrl)) {
      currentFavorites.add(channel);
      await _saveFavorites(prefs, currentFavorites);
    }
  }

  Future<void> removeFavorite(Channel channel) async {
    final prefs = await SharedPreferences.getInstance();
    List<Channel> currentFavorites = await getFavorites();
    
    currentFavorites.removeWhere((c) => c.streamUrl == channel.streamUrl);
    await _saveFavorites(prefs, currentFavorites);
  }

  Future<bool> isFavorite(Channel channel) async {
     List<Channel> currentFavorites = await getFavorites();
     return currentFavorites.any((c) => c.streamUrl == channel.streamUrl);
  }

  Future<void> _saveFavorites(SharedPreferences prefs, List<Channel> channels) async {
    final String encoded = jsonEncode(channels.map((c) => c.toJson()).toList());
    await prefs.setString(_keyFavorites, encoded);
  }
}
