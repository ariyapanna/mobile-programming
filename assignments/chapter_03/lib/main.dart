import 'dart:async';

import 'package:chapter_03/models/menu.dart';
import 'package:chapter_03/pages/menu/components/AddMenuForm.dart';
import 'package:chapter_03/pages/menu/components/MenuCard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Menu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Poppins'
      ),
      home: const MenuPage(),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key}); 

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool _isLoading = false;
  List<Menu> menu = [
      Menu(
          imageUrl: 'https://assets.tmecosys.com/image/upload/t_web_rdp_recipe_584x480_1_5x/img/recipe/ras/Assets/2caca97b-77f6-48e7-837d-62642c0c9861/Derivates/12591894-e010-4a02-b04e-2627d8374298.jpg',
          name: 'Pizza',
          category: MenuCategory.Food,
          price: 9.99,
      ),
      Menu(
          imageUrl: 'https://www.foodandwine.com/thmb/XE8ubzwObCIgMw7qJ9CsqUZocNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/MSG-Smash-Burger-FT-RECIPE0124-d9682401f3554ef683e24311abdf342b.jpg',
          name: 'Burger',
          category: MenuCategory.Food,
          price: 8.50,
      ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
                'Menus',
                style: TextStyle(
                color: Colors.white
                )
            ),
        ),
        backgroundColor: Theme.of(context).colorScheme.onTertiaryFixed,
      ),
      body: Stack(
        children: [
          GridView.count(
            padding: const EdgeInsets.all(12),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
            children: menu.map((data) => MenuCard(
              menu: data,
              onDelete: () async {
                setState(() {
                  _isLoading = true;
                });

                await Future.delayed(const Duration(seconds: 2));

                setState(() {
                  menu.remove(data);
                  _isLoading = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Menu has been deleted!'),
                  ),
                );
              },
            )).toList(),
          ),
          _isLoading ? Container(
            color: Color.fromARGB(153, 0, 0, 0),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF001e31)
              ),
            ),
          ) : const SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.onTertiaryFixed,
        child: const Icon(
          Icons.add,
          color: Colors.white
        ),
        onPressed: () async {
          final newMenu = await showDialog(
            context: context, 
            builder: (_) => AddMenuForm()
          );

          if(newMenu != null) {
            setState(() {
              _isLoading = true;
            });

            await Future.delayed(const Duration(seconds: 2));

            setState(() {
              menu.add(newMenu);
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('New menu has been added!'),
              ),
            );
          }
        },
      ),
    );
  }
}