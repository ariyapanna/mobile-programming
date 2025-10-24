import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/common/app_bar.dart';
import 'package:frontend_mobile/pages/config_chart_of_account/config_chart_of_account_page.dart';
import 'package:frontend_mobile/pages/main/components/menu.dart';

class MainPage extends StatelessWidget {
    const MainPage({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: CustomAppBar(title: 'Catat.In - Main Page',),
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.count(
                        crossAxisCount: 1, // bisa diubah jadi 2 kalau mau 2 kolom
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 3, // sesuaikan tinggi card
                        children: [
                            MenuCard(
                                title: 'Create Journal',
                                icon: Icons.book,
                                onTap: () {
                                    // navigasi ke Create Journal
                                },
                            ),
                            MenuCard(
                                title: 'General Ledger',
                                icon: Icons.account_balance,
                                onTap: () {
                                    // navigasi ke General Ledger
                                },
                            ),
                            MenuCard(
                                title: 'Config Chart of Account',
                                icon: Icons.settings,
                                onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => ConfigChartOfAccountPage()),
                                    );
                                },
                            ),
                        ],
                    )
                ),
            ),
        );
    }
}