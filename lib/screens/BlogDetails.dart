// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'package:adoptme/main.dart';
import 'package:adoptme/widgets/inputField.dart';
import 'package:atomsbox/atomsbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/theme_helper.dart';

class BlogDetails extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const BlogDetails({
    Key? key,
    required this.documentSnapshot,
  }) : super(key: key);

  @override
  State<BlogDetails> createState() => _BlogDetailsState();
}

class _BlogDetailsState extends State<BlogDetails> {
  final TextEditingController commentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _ownerImage;

  String? _ownerName;
  @override
  void initState() {
    getUserPostData(user!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date =
        (widget.documentSnapshot["createdAt"] as Timestamp).toDate();
    return Scaffold(
        appBar: AppBar(
          actions: [
            AppIconButton(
              onPressed: () {},
              child: const Icon(Icons.bookmark),
            ),
            AppIconButton(
              onPressed: () {},
              child: const Icon(Icons.share),
            ),
            const SizedBox(width: 16.0),
          ],
        ),
        extendBody: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadius),
                  child: AppImage.network(
                    widget.documentSnapshot["image"],
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 8.0),
                AppText.bodyLarge(
                  widget.documentSnapshot["headline"],
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 18,
                    ),
                    AppText.bodyMedium(
                      widget.documentSnapshot["author"],
                      maxLines: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                AppText.bodySmall(DateFormat.yMMMMEEEEd().format(date)),
                const SizedBox(height: 8.0),
                Column(
                  children: [
                    AppText.bodyMedium(
                      widget.documentSnapshot["content"],
                      fontSize: 15,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Form(
                          key: _formKey,
                          child: InputField(
                            title: 'Comments:',
                            controller: commentController,
                            hint: 'Add a comment',
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a comment';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        IconButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FirebaseFirestore.instance
                                  .collection('Tips')
                                  .doc(widget.documentSnapshot.id)
                                  .collection("comments")
                                  .add({
                                'id': user!.uid,
                                'content': commentController.text.trim(),
                                'username': _ownerName,
                                'image': _ownerImage,
                                'createdAt': Timestamp.now(),
                              });
                            }
                            commentController.clear();
                          },
                          icon: Icon(Icons.send),
                          color: Colors.deepPurple,
                        )
                      ],
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Tips')
                      .doc(widget.documentSnapshot.id)
                      .collection("comments")
                      .orderBy("createdAt", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('Loading comments...');
                    }
                    final List<DocumentSnapshot> comments = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (BuildContext context, int index) {
                        final DocumentSnapshot comment = comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(comment["image"]),
                          ),
                          title: Text(
                            comment['username'],
                            style: TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            comment['content'],
                          ),
                          trailing: comment["id"] == user!.uid
                              ? IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('Tips')
                                        .doc(widget.documentSnapshot.id)
                                        .collection("comments")
                                        .doc(comment.id)
                                        .delete();
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Colors.red,
                                  ))
                              : null,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }

  getUserPostData(String userID) async {
    final postRef =
        FirebaseFirestore.instance.collection('UserProfile').doc(userID);
    final postDoc = await postRef.get();

    if (postDoc.exists) {
      final data = postDoc.data();
      setState(() {
        _ownerImage = data!['image'];
        _ownerName = data['fullname'];
      });
    } else {
      throw Exception('Post with ID $userID does not exist.');
    }
  }
}
