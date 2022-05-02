import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpaperset/page/wallpaper_details.dart';
import 'package:wallpaperset/utils/constant.dart';
import '../../controller/category_controller.dart';

class CategoryDetails extends GetView<CategoryController> {
  const CategoryDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          controller.modelCategory!.name.toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Obx(
        () => controller.isWallpaperLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 1,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: GridView.count(
                      controller: controller.scrollController,
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1 / 1.5,
                      children: List.generate(controller.arrOfWallpaper.length,
                          (index) {
                        return Container(
                          // color: Colors.black,
                          child: Stack(
                            children: [
                              InkWell(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: controller
                                        .arrOfWallpaper[index].thumbnail,
                                    fit: BoxFit.cover,
                                    width: double.maxFinite,
                                    height: double.maxFinite,
                                    placeholder: (context, url) => const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                onTap: () {
                                  controller.isPopular.value = false;
                                  controller.selected.value = index;
                                  controller.checkFavorite(index);
                                  Get.to(WallpaperDetails());
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  )),
                  controller.isLoadingMore.value
                      ? Padding(padding: EdgeInsets.only(bottom: 15),child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 1,
                    ),
                  ),)
                      : SizedBox.shrink()
                ],
              ),
      ),
      bottomNavigationBar: AdmobBanner(
        adUnitId: bannerId,
        adSize: controller.bannerSize,
        listener: (AdmobAdEvent event, Map<String, dynamic>? args) {},
        onBannerCreated: (AdmobBannerController controller) {},
      ),
    );
  }
}
