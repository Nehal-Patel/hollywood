import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpaperset/controller/category_controller.dart';
import 'package:wallpaperset/page/custom_drawer.dart';
import 'package:wallpaperset/page/setting/setting.dart';
import 'package:wallpaperset/page/wallpaper_details.dart';
import 'package:wallpaperset/utils/constant.dart';

import 'category/category.dart';
import 'category/category_details.dart';

class Home extends GetView<CategoryController> {
  late AdmobInterstitial interstitialAd;
  bool isAdsLaded = false;
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  Home() {
    loadAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _key,
      body: Obx(() => Stack(
            children: [
              Container(
                color: Colors.white,
                child: Image.asset(
                  "assets/logo.jpg",
                  height: 250,
                  width: double.maxFinite,
                  fit: BoxFit.fill,
                ),
              ),
              ListView(
                shrinkWrap: true,
                controller:
                controller.categoryScrollController,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.only(left: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            child: IconButton(
                              onPressed: () {
                                _key.currentState!.openDrawer();
                              },
                              icon: const Icon(Icons.menu),
                              padding: const EdgeInsets.all(2),
                              // color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //   // width: 60,
                      //   // height: 60,
                      //   margin: const EdgeInsets.only(right: 16),
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //     child: Material(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(8),
                      //       child: IconButton(
                      //         onPressed: () {
                      //           Get.to(SettingTab());
                      //           // _key.currentState!.openDrawer();
                      //         },
                      //         icon: const Icon(Icons.more_vert_rounded),
                      //         padding: const EdgeInsets.all(2),
                      //         // color: Colors.white,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Text(
                        "Looking for high quality free wallpapers ? "
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          letterSpacing: 2.0,
                          wordSpacing: 2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(Category());
                    },
                    child: Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Search Categories",
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                      color: Colors.white,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "Popular",
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.0,
                              wordSpacing: 2,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          height: 210,
                          child: controller.isPopularLoading.value
                              ? Center(
                                  child: CircularProgressIndicator(strokeWidth: 1,color: Colors.black,),
                                )
                              : ListView.builder(
                                  itemCount: controller.arrOfPopular.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          right: 16, left: index == 0 ? 16 : 0),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: InkWell(
                                            child: CachedNetworkImage(
                                              imageUrl: controller
                                                  .arrOfPopular[index].image!,
                                              width: 150,
                                              height: 210,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.black,
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                            onTap: () {
                                              controller.isPopular.value = true;
                                              controller.selected.value = index;
                                              Get.to(WallpaperDetails());
                                              controller.pageController
                                                  .animateToPage(index,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.ease);
                                            },
                                          )),
                                    );
                                  },
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: controller.isCategoryLoading.value
                              ? Container(
                            width: Get.width,
                            height: Get.height*0.30,
                            child: Center(
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                ),
                              ),
                            ),
                          )
                              : GridView.count(

                                  shrinkWrap: true,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 1 / 1.4,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  children: List.generate(
                                      controller.arrOfCategory.length,
                                      (index) => InkWell(
                                            onTap: () {
                                              currentIndex = index;
                                              if (categoryClickCount == 3) {
                                                categoryClickCount = 0;
                                                if (isAdsLaded) {
                                                  interstitialAd.show();
                                                } else {
                                                  onClickCategory(index);
                                                }
                                              } else {
                                                categoryClickCount =
                                                    categoryClickCount + 1;
                                                onClickCategory(index);
                                              }

                                              controller.currentPage = 1;
                                              controller.arrOfWallpaper.clear();
                                              controller.modelCategory =
                                                  controller
                                                      .arrOfCategory[index];
                                              controller
                                                  .getWallpaper();
                                              Get.to(const CategoryDetails());
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: controller
                                                        .arrOfCategory[index]
                                                        .image,
                                                    width: double.maxFinite,
                                                    height: double.maxFinite,
                                                    repeat:
                                                        ImageRepeat.noRepeat,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) =>
                                                            const Center(
                                                      child: SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.black,
                                                          strokeWidth: 2,
                                                        ),
                                                      ),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                  // Image.network(
                                                  //   controlleradmob
                                                  //       .arrOfCategory[index].image,
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    // heightFactor: double.infinity,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: 18,
                                                      ),
                                                      child: Container(
                                                        // color: Colors.white,
                                                        width: double.maxFinite,
                                                        height: 36,
                                                        child: Text(
                                                          controller
                                                              .arrOfCategory[
                                                                  index]
                                                              .name
                                                              .toUpperCase(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            shadows: [
                                                              Shadow(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.3),
                                                                  offset:
                                                                      const Offset(
                                                                          15,
                                                                          15),
                                                                  blurRadius:
                                                                      15),
                                                            ],
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                            letterSpacing: 2.0,
                                                            wordSpacing: 2,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                ),
                        )
                      ],
                    ),
                  ),
                  controller.hasNextCategory.value?Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 1,
                    ),
                  ):Container(
                    height: 40,
                    child: Center(
                      child: Text("Nothing to load more"),
                    ),
                  )
                ],
              ),
            ],
          )),
      drawer: const CustomDrawer(),
      bottomNavigationBar: AdmobBanner(
        adUnitId: bannerId,
        adSize: controller.bannerSize,
        listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
          // handleEvent(event, args, 'Banner');
        },
        onBannerCreated: (AdmobBannerController controller) {},
      ),
    );
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic>? args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        isAdsLaded = true;
        break;
      case AdmobAdEvent.opened:
        break;
      case AdmobAdEvent.failedToLoad:
        isAdsLaded = false;
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

  void onClickCategory(int index) {
    controller.currentPage = 1;
    controller.arrOfWallpaper.clear();
  }
}
