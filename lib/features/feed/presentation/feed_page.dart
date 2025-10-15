
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers.dart';
import '../domain/profile.dart';
import '../providers.dart';
import 'widgets/swipe_deck.dart';
import 'widgets/action_buttons.dart';
import 'widgets/match_dialog.dart';


class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});
  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  int likesLeft = 20; // sinkronkan dgn BE daily limit
  late List<Profile> items;

  @override
  void initState() {
    super.initState();
    items = [
      Profile(
        id: 'u1',
        name: 'Alya',
        age: 24,
        bio: 'Coffee addict, sunrise chaser',
        city: 'Jakarta',
        photos: ['https://picsum.photos/seed/alya/800/1200'],
      ),
      Profile(
        id: 'u2',
        name: 'Raka',
        age: 27,
        bio: 'Runner & ramen enjoyer',
        city: 'Bandung',
        photos: ['https://picsum.photos/seed/raka/800/1200'],
      ),
      Profile(
        id: 'u3',
        name: 'Naya',
        age: 25,
        bio: 'Architect, cat mom',
        city: 'Surabaya',
        photos: ['https://picsum.photos/seed/naya/800/1200'],
      ),
    ];
  }

  bool _demoIsMatch(Profile p) {
    // demo only: deterministic biar gampang ngetest
    return p.name.hashCode % 3 == 0;
  }

  Future<void> _load() async {
    final res = await ref.read(feedFutureProvider.future);
    setState(() {
      items = res;
    });
  }

  Future<void> _like(Profile p) async {
   if (likesLeft <= 0) {
     _showSnack('Daily like habis. Datang lagi besok yaa');
     return;
   }
   setState(() => likesLeft--);
   
   if (_demoIsMatch(p)) {
     // Tampilkan modal match
     if (!mounted) return;
     showDialog(
       context: context,
       barrierDismissible: true,
       builder: (_) => MatchDialog(
         youPhoto: 'https://picsum.photos/seed/you/400/400',
         otherPhoto: p.photos.first,
         otherName: p.name,
         onChat: () {
           Navigator.of(context).pop();
           // TODO: nanti push ke /chats
         },
         onKeepSwiping: () => Navigator.of(context).pop(),
       ),
     );
   }
  }

  Future<void> _pass(Profile p) async {
    await ref.read(feedRepoProvider).sendPass(p.id);
  }
  
  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onLogout = ref.read(logoutActionProvider);
    final totalDaily = 20.0;
    final progress = (likesLeft / totalDaily).clamp(0, 1) as double;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flirto'),
        actions: [
          IconButton(onPressed: onLogout, icon: const Icon(Icons.logout)),
        ],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(42), child: Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(value: progress),
              ),),
              const SizedBox(width: 12),
              Chip(
                label: Text('$likesLeft left'),
                avatar: const Icon(Icons.favorite, size: 16),
              ),
            ],
          ),
        )),
      ),
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
          Padding(padding: const EdgeInsets.only(bottom: 16),
            child: ActionButtons(
              likesLeft: likesLeft,
              onLike: () {
                if (items.isNotEmpty) _like(items.first);
              },
              onPass: () {
                if (items.isNotEmpty) _pass(items.first);
              },
              onSuperLike: () {
                _showSnack('Super like coming soon');
              },
            )
          )
        ],
      )
    );
  }
}