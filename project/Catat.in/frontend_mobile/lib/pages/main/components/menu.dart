import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const MenuCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

    @override
    Widget build(BuildContext context) {
        return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                    children: [
                        Icon(icon, size: 40, color: Colors.blue),
                        SizedBox(width: 20),
                        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    ],
                    ),
                ),
            ),
        );
    }
}