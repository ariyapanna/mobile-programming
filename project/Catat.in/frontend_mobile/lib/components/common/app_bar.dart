import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
    const CustomAppBar({super.key, required this.title});

    final String title;

    @override
    Size get preferredSize => Size.fromHeight(kToolbarHeight);

    @override
    Widget build(BuildContext context) {
    return AppBar(
            title: Text(
            title,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blueAccent,
            iconTheme: IconThemeData(color: Colors.white),
        );
    }
}