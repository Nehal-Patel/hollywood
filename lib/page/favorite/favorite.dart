import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:wallpaperset/controller/category_controller.dart';
import 'package:wallpaperset/page/favorite/favorite_details.dart';

class Favorite extends GetView<CategoryController> {
  Favorite(){
    controller.getFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: Icon(Icons.arrow_back,color: Colors.white,),
          ),
          title: Text(
            "favorite".toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 16),
          child: controller.arrOfFavorite.isEmpty?Center(
            child: Text(
              "No Favorite Wallpaper Found",
              style: TextStyle(color: Colors.black),
            ),
          ):GridView.count(
            controller: controller.scrollController,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1 / 1.5,
            children:
            List.generate(controller.arrOfFavorite.length, (index) {
              return Stack(
                children: [
                  InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl:
                        controller.arrOfFavorite[index].thumbnail,
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                        height: double.maxFinite,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      ),
                    ),
                    onTap: () async {
                      controller.selected.value = index;
                      controller.checkFavorite(index);
                      var result =await Get.to(FavoriteDetails());
                      controller.getFavorite();
                    },
                  ),
                ],
              );
            }),
          ),
        )));
  }
}
