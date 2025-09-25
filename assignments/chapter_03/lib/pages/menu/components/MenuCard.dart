import 'package:chapter_03/models/menu.dart';
import 'package:chapter_03/pages/menu/components/DeleteMenuConfirmationDialog.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.onPressed
  });

  final String label;
  final Icon icon;
  final Color foregroundColor;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: icon,
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
        ),
        side: BorderSide.none
      ),
      onPressed: onPressed,
    );
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.menu,
    required this.onDelete
  });

  final Menu menu;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.5, 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                menu.getImageUrl(),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
              ),
            )
          ),
          Expanded( 
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    menu.getName(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF001e31),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  Text(
                    '\$${menu.getPrice().toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  ActionButton(
                    label: 'Delete',
                    icon: const Icon(Icons.delete), 
                    foregroundColor: Colors.white, 
                    backgroundColor: Colors.red, 
                    onPressed: () async {
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (_) => DeleteMenuConfirmationDialog(menu: menu)
                      );

                      if(shouldDelete == true) {
                        onDelete();
                      }
                    }
                  )
                ],
              )
            )
          )
        ],
      )
    );
  } 
}