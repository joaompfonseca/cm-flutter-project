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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        minimumSize: const Size(96, 32),
        maximumSize: const Size(96, 32),
        padding: const EdgeInsets.all(0),
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFFEF4444),
      ),
      onPressed: onPressed,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            size: 16,
            Icons.delete_rounded,
          ),
          SizedBox(width: 4),
          Text(
            style: TextStyle(fontSize: 12),
            "Delete",
          ),
        ],
      ),
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        minimumSize: const Size(128, 32),
        maximumSize: const Size(128, 32),
        padding: const EdgeInsets.all(0),
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      onPressed: onPressed,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            size: 16,
            Icons.map_rounded,
          ),
          SizedBox(width: 4),
          Text(
            style: TextStyle(fontSize: 12),
            "Show on Map",
          ),
        ],
      ),
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        minimumSize: const Size(96, 32),
        maximumSize: const Size(96, 32),
        padding: const EdgeInsets.all(0),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: onPressed,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            size: 16,
            Icons.info_outline_rounded,
          ),
          SizedBox(width: 4),
          Text(
            style: TextStyle(fontSize: 12),
            "Details",
          ),
        ],
      ),
    );
  }
}
