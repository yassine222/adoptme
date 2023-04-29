import 'package:adoptme/screens/editPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PetCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String breed;
  final Function diactivate;
  final Function activate;

  final Function onUpdate;
  final Function onBookmark;
  final bool isAdopted;
  final bool isActive;
  final String postStaus;
  final DocumentSnapshot documentSnapshot;

  const PetCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.breed,
    required this.diactivate,
    required this.onUpdate,
    required this.onBookmark,
    required this.isAdopted,
    required this.postStaus,
    required this.isActive,
    required this.activate,
    required this.documentSnapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(breed),
            const SizedBox(height: 8),
            isAdopted
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        "Adopted",
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                      Icon(
                        Icons.check_circle,
                        color: Colors.deepPurple,
                      ),
                    ],
                  )
                : postStaus == "waiting"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            label: const Text("Pending "),
                            onPressed: () {
                              Get.snackbar("Pending",
                                  "Please wait for admin approval of your post. Thank you.",
                                  icon: const Icon(
                                    Icons.warning_amber_rounded,
                                  ),
                                  backgroundColor: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM);
                            },
                            icon: const Icon(
                              Icons.error,
                              size: 35,
                            ),
                          ),
                        ],
                      )
                    : postStaus == "no"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  "Not Approved",
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Get.to(() => EditPost(
                                      documentSnapshot: documentSnapshot));
                                },
                                icon: const Icon(
                                  Icons.replay,
                                  color: Colors.deepPurple,
                                ),
                                label: const Text(
                                  "Repost",
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: isActive
                                    ? diactivate as void Function()?
                                    : activate as void Function()?,
                                icon: isActive
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                color: isActive ? Colors.green : Colors.red,
                              ),
                              IconButton(
                                onPressed: onUpdate as void Function()?,
                                icon: const Icon(Icons.edit),
                                color: Colors.blue,
                              ),
                              IconButton(
                                onPressed: onBookmark as void Function()?,
                                icon: const Icon(Icons.bookmark),
                                color: Colors.green,
                              ),
                            ],
                          ),
          ],
        ),
      ),
    );
  }
}
