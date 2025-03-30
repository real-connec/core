import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Dummy data
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text('Chat with User $index'),
          subtitle: const Text('Last message preview...'),
          onTap: () {
            // Navigate to chat screen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening chat with User $index')),
            );
            // Navigator.pushNamed(context, '/chat', arguments: userId);
          },
        );
      },
    );
  }
}

class AudioCallsScreen extends StatelessWidget {
  const AudioCallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Dummy data
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.call),
          title: Text('Audio Call with User $index'),
          subtitle: const Text('Yesterday'),
          trailing: const Icon(Icons.phone),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Calling User $index...')),
            );
          },
        );
      },
    );
  }
}

class VideoCallsScreen extends StatelessWidget {
  const VideoCallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Dummy data
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.video_call),
          title: Text('Video Call with User $index'),
          subtitle: const Text('Today'),
          trailing: const Icon(Icons.videocam),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Starting video call with User $index...')),
            );
          },
        );
      },
    );
  }
}
