import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/channel.dart';
import '../providers/channel_provider.dart';
import '../screens/main_screen.dart'; // Import to assess navigation context if needed, but better to use a global key or callback.
// Actually, we can just find the MainScreen state or use a provider to signal tab switch.
// But explicit tab switching usually requires access to the TabController or the storage of the index in a provider.
// Let's assume the user manually switches or we implement a navigation service.
// OR: We can use a `NavigationProvider`?
// Simpler: Just rely on updating the `selectedChannel` and showing a SnackBar "Channel Selected", or find the MainScreenState.
// For now, let's just update the provider. The user can switch to the Player tab. 
// OR: We can pop if we are in search, but search is a root tab.
// I will implement a global event or just let the user click "Watching".
// Wait, UX wise, tapping a channel should play it immediately.
// I will assume there is a way to switch tabs.

class ChannelListItem extends StatelessWidget {
  final Channel channel;

  const ChannelListItem({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChannelProvider>(context); // Listen to changes
    final isFavorite = provider.isFavorite(channel);

    return ListTile(
      leading: Container(
         width: 50,
         height: 50,
         decoration: BoxDecoration(
           color: Theme.of(context).colorScheme.surfaceVariant,
           borderRadius: BorderRadius.circular(8),
         ),
         child: channel.logoUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: channel.logoUrl,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => const Icon(Icons.tv),
                  placeholder: (context, url) => const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : const Icon(Icons.tv),
      ),
      title: Text(
        channel.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        channel.category,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7)),
      ),
      trailing: IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : null,
        ),
        onPressed: () {
          provider.toggleFavorite(channel);
        },
      ),
      onTap: () {
        provider.selectChannel(channel);
        provider.setTabIndex(0); // Switch to Watching tab
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // Optional: show snackbar if needed, but switching is clear enough
      },
    );
  }
}
