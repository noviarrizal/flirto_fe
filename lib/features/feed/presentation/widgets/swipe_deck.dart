
import 'package:flirto_fe/features/feed/domain/profile.dart';
import 'package:flutter/material.dart';

typedef OnSwipe = void Function(Profile p);

enum SwipeDirection { left, right }

class SwipeDeck extends StatefulWidget {
  final List<Profile> profiles;
  final OnSwipe onPass;
  final OnSwipe onLike;
  const SwipeDeck({ super.key, required this.profiles, required this.onPass, required this.onLike });

  @override
  State<SwipeDeck> createState() => _SwipeDeckState();
}

class _SwipeDeckState extends State<SwipeDeck> with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _index = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    if (_index.value >= widget.profiles.length) {
      return const Center(child: Text('No more profiles. Come back later!'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return Stack(children: [
          for (int i = _index.value; i < widget.profiles.length; i++)
            Positioned.fill(child: _buildCard(size, widget.profiles[i], i == _index.value)),
        ]);
      },
    );
  }

  Widget _buildCard(Size size, Profile p, bool isTop) {
    return Draggable(
      feedback: _Card(profile: p),
      childWhenDragging: const SizedBox.shrink(),
      onDragEnd: (d) {
        if (d.offset.dx > 120) { widget.onLike(p); _index.value++; setState(() {}); }
        else if (d.offset.dx < -120) { widget.onPass(p); _index.value++; setState(() {}); }
      },
      child: _Card(profile: p),
    );
  }
}

class _Card extends StatelessWidget {
  final Profile profile;
  const _Card({ required this.profile });
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(profile.photos.first, fit: BoxFit.cover),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
              child: Text('${profile.name}, ${profile.age} - ${profile.city}',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

