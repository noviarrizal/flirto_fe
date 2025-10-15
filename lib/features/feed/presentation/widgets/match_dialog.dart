
import 'package:flutter/material.dart';

class MatchDialog extends StatelessWidget {
  final String youPhoto;
  final String otherPhoto;
  final String otherName;
  final VoidCallback onChat;
  final VoidCallback onKeepSwiping;

  const MatchDialog({
    super.key,
    required this.youPhoto,
    required this.otherPhoto,
    required this.otherName,
    required this.onChat,
    required this.onKeepSwiping,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("It's a Match!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Avatar(url: youPhoto),
                const SizedBox(width: 16),
                _Avatar(url: otherPhoto),
              ],
            ),
            const SizedBox(height: 12),
            Text("Kamu and $otherName saling suka!",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            FilledButton(onPressed: onChat, child: const Text("Mulai Chat"),
            ),
            const SizedBox(height: 8,),
            TextButton(onPressed: onKeepSwiping, child: const Text("Lanjut Swipe"),
            )
          ],
        )
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String url;
  const _Avatar({ required this.url });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 44,
      backgroundImage: NetworkImage(url),
      onBackgroundImageError: (_, __) {},
    );
  }
}