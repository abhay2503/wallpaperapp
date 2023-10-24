import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallpaper/categories.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wallpaper/loadingdialog.dart';
import 'package:wallpaper/sucessdialog.dart';


class Popular extends StatefulWidget {
  const Popular({super.key});

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
   var setas={
    'Home':WallpaperManager.HOME_SCREEN,
     'Lock':WallpaperManager.LOCK_SCREEN,
     'Both':WallpaperManager.BOTH_SCREEN
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WallpaperApp'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('images').where('popular',isEqualTo: true).snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }
            final List<DocumentSnapshot> documents=snapshot.data!.docs;
            return GridView.builder(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0
                ) ,
                itemCount: documents.length,
                itemBuilder: (BuildContext context,int index){
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: GestureDetector(
                      onTap: () async{
                        var actionsheet=CupertinoActionSheet(
                          title: Text('Set As'),
                          actions: [
                            CupertinoActionSheetAction(
                                onPressed: (){
                                  Navigator.of(context).pop('Home');
                                },
                                child: Text('Home')),
                            CupertinoActionSheetAction(
                                onPressed: (){
                                  Navigator.of(context).pop('Lock');
                                },
                                child: Text('Lock')),
                            CupertinoActionSheetAction(
                                onPressed: (){
                                  Navigator.of(context).pop('Both');
                                },
                                child: Text('Both'))
                          ],
                        );
                      var option= await  showCupertinoModalPopup(context: context, builder: (context)=> actionsheet);

                      if(option!=null)
                        {


                          String url=snapshot.data!.docs.elementAt(index)['link'];
                          var cachedImage= await DefaultCacheManager().getSingleFile(url);
                          var croppedImage;
                          if(cachedImage!=null){
                            croppedImage=await ImageCropper().cropImage(
                                sourcePath: cachedImage.path,
                              aspectRatio: CropAspectRatio(
                                  ratioX: MediaQuery.of(context).size.width,
                                  ratioY: MediaQuery.of(context).size.height),
                              uiSettings: [
                                AndroidUiSettings(
                                  toolbarTitle: 'Crop Image',
                                  toolbarColor:Colors.black,
                                  toolbarWidgetColor: Colors.white,
                                  hideBottomControls: true
                                )
                              ]

                            );
                          }

                          if(croppedImage!=null){

                            showDialog(
                                context: context,
                                builder: (c) {
                                  return LoadingDialog(
                                    message: "Loading Data",
                                  );
                                }
                            );

                           bool result=await WallpaperManager.setWallpaperFromFile(cachedImage.path, WallpaperManager.BOTH_SCREEN);
                           if(result!=null){
                             if(result){

                               print(result);
                             }
                           }
                          }

                        }
                      },
                      child: GridTile(
                        child:Container(

                          child: CachedNetworkImage(

                            imageUrl:snapshot.data!.docs.elementAt(index)['link'],
                            imageBuilder: (context,imageProvider){
                             return Container(

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      colorFilter:
                                      ColorFilter.mode(Colors.black54.withOpacity(0.2), BlendMode.colorBurn)),
                                ),
                              );
                            },
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),

                          ),
                        )


                      ),
                    ),
                  );
                });

          },
        ),
      ),
    );
  }
}
