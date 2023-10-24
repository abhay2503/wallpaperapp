import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  final _firestore=FirebaseFirestore.instance;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MY App'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('click'),
          onPressed: () async{
            CollectionReference users=_firestore.collection('images');

            String link="https://firebasestorage.googleapis.com/v0/b/wallpaper-b6bfe.appspot.com/o/anime%2F9.jpeg?alt=media&token=3cd85441-d3d3-4a29-86f9-8c76d9d5dbe5";
            await users.add({
              'link':link,
              'popular':false,
              'type':'anime'
            }).whenComplete(() =>  {
              showDialog(
                  context: context,
                  builder: (context){
                    return  AlertDialog(
                      title: Center(child: Text('Data Saved', style: TextStyle(
                          fontSize: 30),)),
                      content: Column(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green,
                            size: 130,),
                          SizedBox(height: 12,),
                          Center(child: Text(
                            'Your Data has been saved Successfully',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),)),
                        ],
                      ),
                      actions: [
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                        }, child: Text('Ok'))
                      ],
                    );
                  })
            });

          },
        ),
      ),
    );
  }
}
