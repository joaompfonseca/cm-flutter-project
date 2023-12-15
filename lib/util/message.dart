import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text)),
  );
}

Future<bool?> showDialogMessage(
  BuildContext context,
  String title,
  String description,
  String cancelText,
  String okText,
) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: Text(title),
      content: Text(description),
      actions: [
        // Ok Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            minimumSize: const Size(48, 32),
            maximumSize: const Size(48, 32),
            padding: const EdgeInsets.all(0),
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            style: const TextStyle(fontSize: 12),
            okText,
          ),
        ),
        // Cancel Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            minimumSize: const Size(48, 32),
            maximumSize: const Size(48, 32),
            padding: const EdgeInsets.all(0),
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            style: const TextStyle(fontSize: 12),
            cancelText,
          ),
        ),
      ],
    ),
  );
}
