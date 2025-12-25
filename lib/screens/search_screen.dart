import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/channel_provider.dart';
import '../models/channel.dart';
import '../widgets/channel_list_item.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ChannelProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.channels.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Search Bar
              Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: TextField(
                   decoration: InputDecoration(
                     hintText: 'Search channels...',
                     prefixIcon: const Icon(Icons.search),
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(12),
                     ),
                     filled: true,
                     fillColor: Theme.of(context).colorScheme.surfaceVariant,
                   ),
                   onChanged: (value) => provider.search(value),
                 ),
              ),
              
              // Category Filter
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.categories.length,
                  itemBuilder: (context, index) {
                    final category = provider.categories[index];
                    final isSelected = false; // TODO: Implement category selection state in provider properly to expose it
                    // Actually, we need to access the selectedCategory from provider but I didn't expose a getter for it. 
                    // Let's just use simple chips for now that call filterByCategory.
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(category),
                        onPressed: () => provider.filterByCategory(category),
                      ),
                    );
                  },
                ),
              ),
              const Divider(),

              // Channel List
              Expanded(
                child: provider.channels.isEmpty
                    ? const Center(child: Text('No channels found'))
                    : ListView.builder(
                        itemCount: provider.channels.length,
                        itemBuilder: (context, index) {
                           final channel = provider.channels[index];
                           return ChannelListItem(channel: channel);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
