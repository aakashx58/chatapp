import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  final String? documentId;
  final String? title;

  const AddPage({
    super.key,
    this.documentId,
    this.title,
  });

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _fieldController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.title != null) {
      _fieldController.text = widget.title!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.documentId == null ? "Add" : "Update",
      )),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _fieldController,
              validator: (val) {
                if (val != null && val.length > 1) {
                  return null;
                }
                return "Please enter something";
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user = FirebaseAuth.instance.currentUser;
                    if (widget.documentId == null) {
                      await FirebaseFirestore.instance.collection("Todos").add({
                        "name": _fieldController.text,
                        "created_by": user!.uid,
                      });
                    } else {
                      await FirebaseFirestore.instance
                          .collection("Todos")
                          .doc(widget.documentId)
                          .update({
                        "name": _fieldController.text,
                        "created_by": user!.uid,
                      });
                    }

                    Navigator.pop(AppSettings.navigatorKey.currentContext!);
                  }
                },
                child: Text(
                  widget.documentId == null ? "Add" : "Update",
                ))
          ],
        ),
      ),
    );
  }
}
