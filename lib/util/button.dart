import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DeleteButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFFEF4444),
      ),
      onPressed: onPressed,
      child: const Icon(Icons.delete_rounded),
    );
  }
}

class MapButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MapButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      onPressed: onPressed,
      child: const Icon(Icons.map_rounded),
    );
  }
}

class DetailsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DetailsButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: onPressed,
      child: const Icon(Icons.info_outline_rounded),
    );
  }
}
