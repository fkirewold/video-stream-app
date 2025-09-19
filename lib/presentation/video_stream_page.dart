  
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VideoStreamPage extends StatefulWidget {
  const VideoStreamPage({super.key});

  @override
  State<VideoStreamPage> createState() => _VideoStreamPageState();
}

class _VideoStreamPageState extends State<VideoStreamPage> {
  FirebaseFirestore instance=FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:ElevatedButton(onPressed: ()async{
  await instance.collection("users").add({
    "name":"John Doe",  });
      }, child: Text('Add  User to FireStore',style:TextStyle(color: Colors.green),))
    );
  }
}