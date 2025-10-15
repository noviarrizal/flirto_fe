
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
  // Index kartu paling atas
  int _index = 0;

  // posisi drag & animasi balik (ketika tidak melewati threshold)
  Offset _position = Offset.zero;
  late AnimationController _reboundCtrl;
  late Animation<Offset> _reboundAnim;

  static const double _swipeThreshold = 120; //px
  static const double _maxAngle = 0.35; // rad ~ 20 deg
  static const double _nextCardScale = 0.95;
  static const double _nextCardYOffset = 16;

  @override
  void initState() {
    super.initState();
    _reboundCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    )..addListener(() {
      setState(() {
        _position = _reboundAnim.value;
      });
    });
  }

  @override
  void dispose() {
    _reboundCtrl.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails d) {
    _reboundCtrl.stop();
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() {
      _position += d.delta;
    });
  }

  void _onPanEnd(DragEndDetails d, Profile p, Size size) {
    final dx = _position.dx;

    if (dx > _swipeThreshold) {
      // Like
      widget.onLike(p);
      setState(() {
        _index++;
        _position = Offset.zero;
      });
      return;
    }
    if (dx < -_swipeThreshold) { // <-- was >, should be <
      // NOPE
      widget.onPass(p);
      setState(() {
        _index++;
        _position =  Offset.zero;
      });
      return;
    }

    // rebound balik ke tengah
    _reboundAnim = Tween<Offset>(
      begin: _position,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _reboundCtrl, curve: Curves.easeOut));
    _reboundCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    if (_index >= widget.profiles.length) {
      return const Center(child: Text('No more profiles. Come back later!'));
    }

    return LayoutBuilder(
      builder: (_, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final current = widget.profiles[_index];
        final hasNext = _index + 1 < widget.profiles.length;
        final next = hasNext ? widget.profiles[_index + 1] : null;

        // progress geser (untuk animasi label)
        final dragX = _position.dx;
        final likeOpacity = (dragX / _swipeThreshold).clamp(0.0, 1.0);
        final nopeOpacity = (-dragX / _swipeThreshold).clamp(0.0, 1.0);


        // sudut rotasi kartu aktif
        final angle = (dragX / size.width) * _maxAngle;

        return Stack(children: [
        //   Kartu kedua (di bawah) -> shrink + turun dikit, ikut sedikit dengan drag
          if (hasNext)
            Positioned.fill(
                child: Transform.translate(
                    offset: const Offset(0, _nextCardYOffset),
                    child: Transform.scale(
                      scale: _nextCardScale + (0.02 * (dragX.abs() / _swipeThreshold).clamp(0, 1)),
                      child: _ProfileCard(profile: next!, blurBottom: true),
                    ),
                ),
            ),

        //   Kartu paling atas (aktif)
        Positioned.fill(
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: (d) => _onPanEnd(d, current, size),
            child: Transform.translate(
              offset: _position,
              child: Transform.rotate(
                angle: angle,
                alignment: dragX >= 0 ? Alignment.topRight : Alignment.topLeft,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: _ProfileCard(
                        profile: current,
                        blurBottom: true,
                        dragOffset: _position,          // <-- kirim ke card utk parallax
                      ),
                    ),
                    // Badge Like/Nope tetap
                    Positioned(
                      top: 28,
                      right: 24,
                      child: Opacity(
                        opacity: likeOpacity,
                        child: _SwipeBadge(text: 'LIKE', color: Colors.green, alignRight: true),
                      ),
                    ),
                    Positioned(
                      top: 28,
                      left: 24,
                      child: Opacity(
                        opacity: nopeOpacity,
                        child: _SwipeBadge(text: 'NOPE', color: Colors.red, alignRight: false),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        ]);
      },
    );
  }
}

// =====================
// Kartu profil
// =====================
class _ProfileCard extends StatelessWidget {
  final Profile profile;
  final bool blurBottom;
  final Offset? dragOffset;

  const _ProfileCard({
    required this.profile,
    this.blurBottom = false,
    this.dragOffset,
  });

  @override
  Widget build(BuildContext context) {
    // Parallax halus: 4% horizontal, 2% vertical
    final dx = -((dragOffset?.dx ?? 0) * 0.04);  // minus = gerak berlawanan
    final dy = -((dragOffset?.dy ?? 0) * 0.02);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.translate(
            offset: Offset(dx, dy),
            child: Image.network(
              profile.photos.first,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
            ),
          ),
          if (blurBottom)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 140,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
            ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Text(
              '${profile.name}, ${profile.age} -  ${profile.city}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================
// Badge LIKE/NOPE
// =====================
class _SwipeBadge extends StatelessWidget {
  final String text;
  final Color color;
  final bool alignRight;
  const _SwipeBadge({
    required this.text,
    required this.color,
    required this.alignRight,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: alignRight ? -0.15 : 0.15, // sedikit miring
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 3),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.85),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

