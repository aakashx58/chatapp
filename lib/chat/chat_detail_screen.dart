import 'package:chat_app/auth/login_screen.dart';
import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatRoomId;

  const ChatDetailScreen({
    super.key,
    required this.chatRoomId,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shree Krishna"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(widget.chatRoomId)
                  .collection("messages")
                  .orderBy("created_at", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final chats = snapshot.data?.docs ?? [];
                  return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: chats.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      bool isSentByMe = user?.uid == chats[index]["sent_by"];

                      return Row(
                        mainAxisAlignment: isSentByMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: !isSentByMe,
                            child: ClipOval(
                              child: Image.network(
                                "https://thumbs.dreamstime.com/b/portrait-attractive-young-woman-who-sitting-cafe-cafe-urban-lifestyle-random-portrait-portrait-attractive-184387752.jpg",
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSentByMe ? Colors.grey : Colors.blue,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(5),
                                topRight: const Radius.circular(5),
                                bottomLeft: isSentByMe
                                    ? const Radius.circular(5)
                                    : const Radius.circular(0),
                                bottomRight: isSentByMe
                                    ? const Radius.circular(0)
                                    : const Radius.circular(5),
                              ),
                            ),
                            child: Text(
                              chats[index]["message"],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Visibility(
                            visible: isSentByMe,
                            child: ClipOval(
                              child: Image.network(
                                "https://www.shutterstock.com/image-photo/young-bearded-hipster-guy-wearing-600w-2201682481.jpg",
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(3),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  )),
                  IconButton(
                    onPressed: () async {
                      final auth = FirebaseAuth.instance.currentUser;
                      if (_messageController.text.isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection("chats")
                            .doc(widget.chatRoomId)
                            .collection("messages")
                            .add({
                          "message": _messageController.text,
                          "created_at": DateTime.now().toString(),
                          "chat_room_id": widget.chatRoomId,
                          "sent_by": auth?.uid,
                        });
                        _messageController.clear();
                      }
                    },
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
