// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String breed;
  final Function onDelete;
  final Function onUpdate;
  final Function onBookmark;
  final bool isAdopted;

  const PetCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.breed,
    required this.onDelete,
    required this.onUpdate,
    required this.onBookmark,
    required this.isAdopted,
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
                    children: [
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
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: onDelete as void Function()?,
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
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
