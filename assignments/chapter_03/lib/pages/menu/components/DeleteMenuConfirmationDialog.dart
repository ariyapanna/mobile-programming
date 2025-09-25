import 'package:chapter_03/models/menu.dart';
import 'package:flutter/material.dart';

class DeleteMenuConfirmationDialog extends StatelessWidget {
    const DeleteMenuConfirmationDialog({
        super.key,
        required this.menu,
    });

    final Menu menu;

    @override
    Widget build(BuildContext context) {
        return AlertDialog(
            title: const Text("Delete Menu Confirmation"),
            content: Text("Are you sure you want to delete ${menu.name}?"),
            actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                ),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Delete"),
                ),
            ],
        );
    }
}