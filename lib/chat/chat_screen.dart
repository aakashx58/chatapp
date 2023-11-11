import 'package:chat_app/auth/login_screen.dart';
import 'package:chat_app/chat/chat_detail_screen.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/profile/profile_screen.dart';
import 'package:chat_app/utils/app_functuins.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).push(
                CupertinoPageRoute(builder: (context) => ProfileScreen()));
          },
          child: ClipOval(
            child: Image.network(
              "https://www.shutterstock.com/image-photo/guy-on-background-sky-600w-497596165.jpg",
              height: 0.1 * size.width,
              width: 0.1 * size.width,
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(AppSettings.navigatorKey.currentContext!)
                    .pushAndRemoveUntil(
                        CupertinoPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where(
              "uid",
              isNotEqualTo: user?.uid,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data?.docs ?? [];
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    String loggedinUserUid = user!.uid;
                    String otherUserUid = users[index]['uid'];
                    String chatRoomId =
                        createChatRoom(loggedinUserUid, otherUserUid);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          chatRoomId: chatRoomId,
                        ),
                      ),
                    );
                  },
                  title: Text(
                    users[index]['name'],
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
