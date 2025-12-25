import 'package:flutter/material.dart';
import '../models/channel.dart';
import '../services/m3u_service.dart';
import '../services/favorites_service.dart';

class ChannelProvider with ChangeNotifier {
  final M3UService _m3uService = M3UService();
  final FavoritesService _favoritesService = FavoritesService();

  List<Channel> _allChannels = [];
  List<Channel> _displayedChannels = [];
  List<Channel> _favoriteChannels = [];
  Channel? _selectedChannel;
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Channel> get channels => _displayedChannels;
  List<Channel> get favorites => _favoriteChannels;
  Channel? get selectedChannel => _selectedChannel;
  bool get isLoading => _isLoading;
  List<String> get categories => ['All', ..._allChannels.map((c) => c.category).toSet().toList()..sort()];

  ChannelProvider() {
    fetchChannels();
    loadFavorites();
  }

  Future<void> fetchChannels() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allChannels = await _m3uService.fetchChannels();
      _filterChannels();
    } catch (e) {
      print('Error fetching channels: $e');
      // Ideally set an error state
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFavorites() async {
    _favoriteChannels = await _favoritesService.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(Channel channel) async {
    if (await _favoritesService.isFavorite(channel)) {
      await _favoritesService.removeFavorite(channel);
    } else {
      await _favoritesService.addFavorite(channel);
    }
    await loadFavorites();
  }

  void selectChannel(Channel channel) {
    _selectedChannel = channel;
    notifyListeners();
  }

  bool isFavorite(Channel channel) {
    return _favoriteChannels.any((c) => c.streamUrl == channel.streamUrl);
  }

  void search(String query) {
    _searchQuery = query;
    _filterChannels();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _filterChannels();
  }

  void _filterChannels() {
    _displayedChannels = _allChannels.where((channel) {
      final matchesSearch = channel.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || channel.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    notifyListeners();
  }
}
