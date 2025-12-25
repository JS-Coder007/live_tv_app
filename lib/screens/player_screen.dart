import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../providers/channel_provider.dart';
import '../models/channel.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  Channel? _currentChannel;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  // Monitor provider for changes in selected channel
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<ChannelProvider>(context);
    if (provider.selectedChannel != _currentChannel && provider.selectedChannel != null) {
      _initializePlayer(provider.selectedChannel!);
    }
  }

  Future<void> _initializePlayer(Channel channel) async {
    setState(() {
      _currentChannel = channel;
      _isLoading = true;
      _error = null;
    });

    // Dispose old controllers
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _videoPlayerController = null;
    _chewieController = null;

    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(channel.streamUrl));
      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        autoPlay: true,
        looping: false,
        isLive: true,
        showControls: true,
        allowFullScreen: true,
        fullScreenByDefault: false,
        
        // Custom Controls can be added here if needed, but Chewie's default are good.
        // We can add Aspect Ratio toggle button in overlay if needed, 
        // but Chewie doesn't have a native aspect ratio toggler in UI. 
        // We will add a floating action button or overlay for Aspect Ratio.
      );

    } catch (e) {
      _error = 'Failed to load stream: ${e.toString()}';
      print('Video Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Toggle Aspect Ratio
  void _cycleAspectRatio() {
    if (_chewieController == null) return;
    
    final current = _chewieController!.aspectRatio;
    double? newRatio;
    
    // Cycle: Default -> 16:9 -> 4:3 -> Fill (Screen Ratio)
    // Note: Chewie aspect ratio null means "fit video".
    // 16/9 = 1.77
    // 4/3 = 1.33
    
    if (current == null || (current - _videoPlayerController!.value.aspectRatio).abs() < 0.1) {
       newRatio = 16/9;
    } else if ((current - 16/9).abs() < 0.1) {
       newRatio = 4/3;
    } else if ((current - 4/3).abs() < 0.1) {
       newRatio = MediaQuery.of(context).size.aspectRatio; // Fill screen roughly
    } else {
       newRatio = _videoPlayerController!.value.aspectRatio; // Reset to original
    }
    
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        aspectRatio: newRatio,
        autoPlay: true,
        isLive: true,
      );
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Aspect Ratio: ${newRatio?.toStringAsFixed(2) ?? "Auto"}'), duration: const Duration(milliseconds: 500)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If no channel selected
    if (_currentChannel == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.tv_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Select a channel to start watching', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Switch to Search Tab (Index 1)
                Provider.of<ChannelProvider>(context, listen: false).setTabIndex(1);
              }, 
              child: const Text('Go to Search')
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Center(
             child: _isLoading 
               ? const CircularProgressIndicator()
               : _error != null
                 ? Text(_error!, style: const TextStyle(color: Colors.red))
                 : _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                    ? Chewie(controller: _chewieController!)
                    : const CircularProgressIndicator(),
          ),
          if (!_isLoading && _error == null)
            Positioned(
              top: 20,
              right: 20,
              child: FloatingActionButton.small(
                onPressed: _cycleAspectRatio,
                child: const Icon(Icons.aspect_ratio),
              ),
            ),
        ],
      ),
    );
  }
}
