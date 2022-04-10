import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var docs = streamSnapshot.data?.docs;
        print(docs);
        return Container();
        // return ListView.builder(
        //   reverse: true,
        //   itemCount: documents?.length,
        //   itemBuilder: (ctx, index) => BubbleMessage(
        //     message: documents?[index].data()?['text'],
        //     isMe: documents?[index].data()?['userId'] == user?.uid,
        //     username: documents?[index].data()['username'],
        //     userImageUrl: documents?[index].data()?['userImage'],
        //     key: ValueKey(documents?[index].id),
        //   ),
        // );
      },
    );
  }
}
