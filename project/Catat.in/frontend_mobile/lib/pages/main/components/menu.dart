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

// class Menu extends StatelessWidget {
//     const Menu({ super.key });

//     @override
//     Widget build(BuildContext context) {
//         return GridView.count(
//             crossAxisCount: 1, // bisa diubah jadi 2 kalau mau 2 kolom
//             mainAxisSpacing: 20,
//             crossAxisSpacing: 20,
//             childAspectRatio: 3, // sesuaikan tinggi card
//             children: [
//             MenuCard(
//                 title: 'Create Journal',
//                 icon: Icons.book,
//                 onTap: () {
//                     // navigasi ke Create Journal
//                 },
//             ),
//             MenuCard(
//                 title: 'General Ledger',
//                 icon: Icons.account_balance,
//                 onTap: () {
//                     // navigasi ke General Ledger
//                 },
//             ),
//             MenuCard(
//                 title: 'Config Chart of Account',
//                 icon: Icons.settings,
//                 onTap: () {
//                     // Navigator.push(
//                     //     context,
//                     //     MaterialPageRoute(builder: (_) => {
//                     //         print('tes')
//                     //     }),
//                     // );
//                 },
//             ),
//             ],
//         );
//     }
// }