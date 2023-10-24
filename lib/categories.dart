import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  List<Map<String,String>> items=[
    {
      'img':'img1.jpg',
      'text':'Cars'
    },
    {
      'img':'img2.jpg',
      'text':'Devotional'
    },
    {
      'img':'img3.jpg',
      'text':'Anime'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: ListView.builder(
        scrollDirection:Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical:20,horizontal: 10),
            child: Categoryitem(
                imageurl:items[index]["img"]!,
                name:items[index]["text"]!
            ),
          );

        },
      ),

    );
  }
}

class Categoryitem extends StatelessWidget {
  const Categoryitem({required this.name,required this.imageurl});

  final String name;
  final String imageurl;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        image:DecorationImage(
          image: AssetImage(
            "images/"+imageurl,),
          fit: BoxFit.cover
        )
      ),
      child: Align(
        alignment: Alignment.bottomLeft,

        child: Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22
          ),
        ),
      ),
    );
  }
}

