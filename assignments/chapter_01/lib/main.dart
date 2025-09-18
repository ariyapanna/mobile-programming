import 'package:chapter_01/components/article_card.dart';
import 'package:chapter_01/models/article.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReadIT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Article> articles = [
      Article(
        title: "Flutter is Awesome",
        summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        imagePath: "https://yt3.googleusercontent.com/ytc/AIdro_nqx_sCd8ZIeIcodS0sfeMKJ8rVTslmQHUe_udwGNH2Pg=s900-c-k-c0x00ffffff-no-rj",
        author: "John Doe",
        date: "September 1, 2023",
      ),
      Article(
        title: "Go Lang Learning Path",
        summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        imagePath: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRa7KTWoxrEdS5uzTCBc9k7c67FZl2SVv4NxA&s",
        author: "John Doe",
        date: "September 2, 2023",
      ),
      Article(
        title: "Machine Learning from Zero to Hero",
        summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        imagePath: "https://sususehat.id/storage/images/upload/2023/admin/08-Aug/Machine-Learning.jpg",
        author: "John Doe",
        date: "September 3, 2023",
      ),
      Article(
        title: "A Complete Guide to Become a Software Engineer",
        summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        imagePath: "https://www.pointstar.co.id/wp-content/uploads/2024/08/pekerjaan-software-engineer-scaled-e1723779272708.jpg",
        author: "John Doe",
        date: "September 4, 2023",
      )
    ];

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(90), 
            child: SizedBox.expand(
                child: Container(
                    padding: const EdgeInsets.only(top: 40, left: 16, right: 16), 
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    const Text(
                                        "ReadIT",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Times New Roman',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                        ),
                                    ),
                                    IconButton(
                                        icon: const Icon(
                                            Icons.notifications_none, 
                                            color: Colors.white,
                                            size: 26,
                                        ),
                                        onPressed: () {

                                        },
                                    ),
                                ],
                            ),
                        ],
                    )
                ),
            )
        ),
        backgroundColor: Colors.black,
        floatingActionButton: SizedBox(
            width: 65,
            height: 65,
            child: FloatingActionButton(
                backgroundColor: Colors.green,
                child: const Icon(
                    Icons.edit_square,
                    color: Colors.white,
                ),
                onPressed: () {

                },
            ),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 25, left: 16, right: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        "For You",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Times New Roman',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                        ),
                    ),
                    Expanded(
                        child: ListView(
                        children: articles.map((article) => ArticleCard(
                            title: article.title,
                            summary: article.summary,
                            imagePath: article.imagePath,
                            author: article.author,
                            date: article.date
                          )).toList(),
                        ),
                    )
                ],
            )
        )
    );
  }
}