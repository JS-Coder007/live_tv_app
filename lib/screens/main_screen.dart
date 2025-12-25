import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/channel_provider.dart';
import 'player_screen.dart'; // Placeholder
import 'search_screen.dart'; // Placeholder
import 'favorites_screen.dart'; // Placeholder
import 'about_screen.dart'; // Placeholder

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Tabs
  // 0: Player (Currently Watching)
  // 1: Search
  // 2: Favorites
  
  final List<Widget> _screens = [
    const PlayerScreen(),
    const SearchScreen(),
    const FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Watch tab index from provider
    final currentIndex = context.watch<ChannelProvider>().currentTabIndex;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live TV'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          )
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          context.read<ChannelProvider>().setTabIndex(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.play_circle_outline),
            selectedIcon: Icon(Icons.play_circle_filled),
            label: 'Watching',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'My Channels',
          ),
        ],
      ),
    );
  }
}
