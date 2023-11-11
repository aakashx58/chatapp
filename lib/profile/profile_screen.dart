import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/profile/edit_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  // getCurrentUser() async {
  //   var user = FirebaseAuth.instance.currentUser;

  //   userData = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(user?.uid)
  //       .get();
  //   isLoading = false;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  // var userData;
  // bool isLoading = true;

  @override
  void initState() {
    // getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Builder(builder: (context) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: userData["image"],
                          height: 0.4 * size.width,
                          width: 0.4 * size.width,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return const Icon(Icons.person);
                          },
                          placeholder: (context, url) =>
                              const Icon(Icons.person_off),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      userData['name'],
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      userData['email'],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.edit),
                            Text("Edit profile"),
                          ],
                        )),
                  ]);
            });
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
