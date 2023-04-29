import 'package:atomsbox/atomsbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:adoptme/screens/blogDetails.dart';

import '../widgets/loadingwidget.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

List<String> categories = ['ALL', 'Dog', 'Cat', 'Parrot', 'Fish', 'Other'];

final CollectionReference blogStream =
    FirebaseFirestore.instance.collection('Tips');

class _NewsPageState extends State<NewsPage> {
  String _selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tips'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: blogStream.where("isPopular", isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (kDebugMode) {
              print(snapshot.error.toString());
            }
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading2();
          }
          final List<DocumentSnapshot> tips = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppConstants.sm),
                  child: AppCarousel(
                    title: AppText(
                      'Popular',
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w500,
                    ),
                    carouselItems: tips.map((tip) {
                      return AppCardImageOverlay(
                        onTap: () =>
                            Get.to(() => BlogDetails(documentSnapshot: tip)),
                        type: AppCardType.elevated,
                        headline: AppText(
                          tip['headline'],
                          fontSize: 18,
                          maxLines: 2,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        image: AppImage.network(
                          tip['image'],
                          height: size.height * 0.3,
                          width: size.width,
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: _selectedCategory == "Dog"
                        ? blogStream
                            .where("categorie", isEqualTo: "Dog")
                            .snapshots()
                        : _selectedCategory == "Cat"
                            ? blogStream
                                .where("categorie", isEqualTo: "Cat")
                                .snapshots()
                            : _selectedCategory == "Parrot"
                                ? blogStream
                                    .where("categorie", isEqualTo: "Parrot")
                                    .snapshots()
                                : _selectedCategory == "Fish"
                                    ? blogStream
                                        .where("categorie", isEqualTo: "Fish")
                                        .snapshots()
                                    : _selectedCategory == "Other"
                                        ? blogStream
                                            .where("categorie",
                                                isEqualTo: "Other")
                                            .snapshots()
                                        : blogStream.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        if (kDebugMode) {
                          print(snapshot.error.toString());
                        }
                        return const Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Loading2();
                      }
                      final List<DocumentSnapshot> xx = snapshot.data!.docs;
                      return Padding(
                        padding: const EdgeInsets.all(AppConstants.sm),
                        child: AppList.vertical(
                          title: SizedBox(
                            height: 20,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = categories[index];
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Text(
                                      categories[index],
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: _selectedCategory ==
                                                categories[index]
                                            ? Colors.deepPurple
                                            : Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          listItems: xx.map(
                            (xxx) {
                              DateTime date =
                                  (xxx["createdAt"] as Timestamp).toDate();
                              String createdAt =
                                  DateFormat.yMMMMEEEEd().format(date);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() =>
                                        BlogDetails(documentSnapshot: xxx));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          xxx['image'],
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Headline
                                      Text(
                                        xxx['headline'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Author and posted date
                                      Row(
                                        children: [
                                          const Icon(Icons.person, size: 16),
                                          const SizedBox(width: 4),
                                          Text(xxx['author']),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.calendar_today,
                                              size: 16),
                                          const SizedBox(width: 4),
                                          Text(createdAt),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      );
                    }),
              ],
            ),
          );
        },
      ),
    );
  }
}
