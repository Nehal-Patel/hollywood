import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpaperset/controller/category_controller.dart';
import 'package:wallpaperset/page/favorite/favorite.dart';

import 'category/category_details.dart';

class CustomDrawer extends GetView<CategoryController>{
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Obx(()=>ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: <Widget>[
          // const DrawerHeader(
          //   child: Text(
          //     "Bollywood Actress",
          //   ),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //   ),
          // ),

          Container(
            width: double.maxFinite,
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.purple,
                  Colors.amber
                ]
              )
            ),
          ),
          // SizedBox(height: 10,),
          InkWell(
            onTap:(){
              Get.to(Favorite());
            },
            child: SizedBox(
              height: 40,
              width: 40,
              child: ListTile(
                leading: Container(
                  width: 30,
                  height: 30,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12,width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                title: Text( "Favorite".toUpperCase(),
                  // textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),


              ),
            )
          ),
          SizedBox(height: 10,),
          Divider(),
          MediaQuery.removePadding(context: context,
              removeTop: true,
              child: ListView.builder(
              shrinkWrap: true,
              itemCount:controller.arrOfCategory.length ,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => InkWell(
                onTap: (){

                  controller.currentPage=1;
                  controller.arrOfWallpaper.clear();
                  controller.modelCategory=controller.arrOfCategory[index];
                  controller.getWallpaper();
                  Get.to(const CategoryDetails());

                },
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12,width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),

                      child: CachedNetworkImage(
                        imageUrl: controller.arrOfCategory[index].image,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text( controller.arrOfCategory[index].name.toUpperCase(),
                    // textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),


                ),
              ))),
        ],
      )),
    );
  }

}