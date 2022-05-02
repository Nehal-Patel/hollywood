import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpaperset/controller/category_controller.dart';
import 'package:wallpaperset/utils/constant.dart';

import 'category_details.dart';

class Category extends GetView<CategoryController> {

  late AdmobInterstitial interstitialAd;
  bool isAdsLaded=false;
  int currentIndex=0;

  Category(){
    loadAds();
  }

  @override
  Widget build(BuildContext context) {
    loadAds();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Container(
              width: double.maxFinite,
              // padding:
              // const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                // border: Border.all(color: Colors.grey,width: 1)
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextField(
                        onChanged: (String value) {
                          controller.searchText.value = value;
                          controller.searchCategory();
                        },
                        decoration: const InputDecoration(
                          hintText: "Search Categories",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Categories",
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 2.0,
                wordSpacing: 2,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() => controller.isCategoryLoading.value
                    ? Center(
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  ),
                )
                    : controller.searchText.isEmpty
                    ? GridView.count(
                  shrinkWrap: true,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1 / 1.4,
                  // physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: List.generate(
                      controller.arrOfCategory.length,
                          (index) => InkWell(
                        onTap: () {
                          currentIndex=index;
                          if(categoryClickCount==3){
                            categoryClickCount=0;
                            if(isAdsLaded){
                              interstitialAd.show();
                            }else{
                              onClickCategory(index);
                            }
                          }else{
                            categoryClickCount=categoryClickCount+1;
                            onClickCategory(index);
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: controller
                                    .arrOfCategory[index].image,
                                width: double.maxFinite,
                                height: double.maxFinite,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                const Center(
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
                              // Image.network(
                              //   controlleradmob
                              //       .arrOfCategory[index].image,
                              //   fit: BoxFit.cover,
                              // ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                // heightFactor: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  child: Container(
                                    // color: Colors.white,
                                    width: double.maxFinite,
                                    height: 36,
                                    child: Text(
                                      controller
                                          .arrOfCategory[index].name
                                          .toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        shadows: [
                                          // Shadow(
                                          //     color: Colors
                                          //         .black
                                          //         .withOpacity(
                                          //             0.3),
                                          //     offset:
                                          //         const Offset(
                                          //             15, 15),
                                          //     blurRadius: 15),
                                        ],
                                        fontSize: 12,
                                        color: Colors.white,
                                        letterSpacing: 2.0,
                                        wordSpacing: 2,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                )
                    : GridView.count(
                  shrinkWrap: true,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1 / 1.4,
                  // physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: List.generate(
                      controller.arrOfSearchCategory.length,
                          (index) => InkWell(
                        onTap: () {
                          currentIndex=index;
                          if(categoryClickCount==3){
                            categoryClickCount=0;
                            if(isAdsLaded){
                              interstitialAd.show();
                            }else{
                              onClickCategory(index);
                            }
                          }else{
                            categoryClickCount=categoryClickCount+1;
                            onClickCategory(index);
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: controller
                                    .arrOfSearchCategory[index].image,
                                width: double.maxFinite,
                                height: double.maxFinite,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                const Center(
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
                              // Image.network(
                              //   controlleradmob
                              //       .arrOfCategory[index].image,
                              //   fit: BoxFit.cover,
                              // ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                // heightFactor: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  child: Container(
                                    // color: Colors.white,
                                    width: double.maxFinite,
                                    height: 36,
                                    child: Text(
                                      controller
                                          .arrOfSearchCategory[index]
                                          .name
                                          .toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        shadows: [
                                          // Shadow(
                                          //     color: Colors
                                          //         .black
                                          //         .withOpacity(
                                          //             0.3),
                                          //     offset:
                                          //         const Offset(
                                          //             15, 15),
                                          //     blurRadius: 15),
                                        ],
                                        fontSize: 12,
                                        color: Colors.white,
                                        letterSpacing: 2.0,
                                        wordSpacing: 2,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                )),
              ))
        ],
      ),
      bottomNavigationBar: AdmobBanner(
        adUnitId: "ca-app-pub-3940256099942544/6300978111",
        adSize: controller.bannerSize,
        listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        },
        onBannerCreated: (AdmobBannerController controller) {
        },
      ),
    );
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic>? args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        isAdsLaded=true;
        break;
      case AdmobAdEvent.opened:
        break;
      case AdmobAdEvent.closed:
        onClickCategory(currentIndex);
        break;
      case AdmobAdEvent.failedToLoad:
        isAdsLaded=false;
        break;
      case AdmobAdEvent.rewarded:
        break;
      default:
    }
  }

  Future<void> loadAds() async {
    await Admob.requestTrackingAuthorization();

    interstitialAd = AdmobInterstitial(
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );
    interstitialAd.load();
  }

  void onClickCategory(int index){
    controller.currentPage = 1;
    controller.arrOfWallpaper.clear();
    if(controller.searchText.isEmpty){
      controller.modelCategory =
      controller.arrOfCategory[index];
    }else{
      controller.modelCategory =
      controller.arrOfSearchCategory[index];
    }
    controller.getWallpaper();
    Get.to(const CategoryDetails());
  }
}
