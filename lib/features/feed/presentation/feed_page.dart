
import 'package:flirto_fe/features/feed/domain/profile.dart';
import 'package:flirto_fe/features/feed/presentation/widgets/swipe_deck.dart';
import 'package:flirto_fe/features/feed/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});
  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  int likesLeft = 100; // sinkronkan dgn BE daily limit
  List<Profile> items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await ref.read(feedFutureProvider.future);
    setState(() {
      items = res;
    });
  }

  Future<void> _like(Profile p) async {
    if (likesLeft <= 0) return;
    setState(() => likesLeft--);
    await ref.read(feedRepoProvider).sendLike(p.id);
    // TODO: jika BE mengembalikan `matched=true`, tampilkan dialog "It’s a Match!" dan arahkan ke chat.
  }

  Future<void> _pass(Profile p) async {
    await ref.read(feedRepoProvider).sendPass(p.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flirto')),
      body: Column(
        children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SwipeDeck(
              profiles: items,
              onLike: _like,
              onPass: _pass,
            ),
          )),
        ],
      )
    );
  }
}