import 'package:flutter/material.dart';

typedef VoidCb = void Function();

class ActionButtons extends StatelessWidget {
  final VoidCb onPass;
  final VoidCb onLike;
  final VoidCb? onSuperLike;
  final int likesLeft;

  const ActionButtons({
    super.key,
    required this.onPass,
    required this.onLike,
    this.onSuperLike,
    required this.likesLeft,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = likesLeft <= 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton.filledTonal(
          onPressed: disabled ? null : onPass,
          icon: const Icon(Icons.close),
        ),
        Column(
          children: [
            IconButton.filled(
              onPressed: disabled ? null : onLike,
              icon: const Icon(Icons.favorite),
            ),
            Text(
              '$likesLeft left',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        IconButton.filledTonal(
          onPressed: disabled ? null : onSuperLike,
          icon: const Icon(Icons.star),
        ),
      ],
    );
  }
}
