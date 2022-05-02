import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaperset/database/db.dart';
import 'package:wallpaperset/model/model_category.dart';
import 'package:wallpaperset/model/model_favorite.dart';
import 'package:wallpaperset/model/model_wallpaper.dart';
import 'package:wallpaperset/page/category/category_details.dart';
import 'package:wallpaperset/utils/constant.dart';

class CategoryController extends GetxController {
  RxBool isCategoryLoading = false.obs;
  RxBool isPopularLoading = false.obs;
  RxList arrOfCategory = <ModelCategory>[].obs;
  RxList arrOfPopular = <ModelWallpaper>[].obs;

  RxList arrOfSearchCategory = <ModelCategory>[].obs;
  RxList arrOfFavorite = <ModelFavorite>[].obs;
  late final String image;
  late final String targetingInfo;

  ModelCategory? modelCategory;
  late AdmobBannerSize bannerSize;

  late SqliteService sqliteService;
  final ScrollController scrollController = ScrollController();
  final ScrollController categoryScrollController = ScrollController();
  int currentPage = 1;
  int currentPopularPage = 1;

  RxList arrOfWallpaper = <ModelWallpaper>[].obs;
  RxBool isWallpaperLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  var pageController = PageController(viewportFraction: 1 / 5);
  var largePageController = PageController();
  RxInt selected = 0.obs;
  RxBool isFavorite = false.obs;

  RxString searchText = "".obs;
  RxBool isPopular = false.obs;

  int categoryPage = 1;
  RxBool hasNextCategory = false.obs;
  RxBool hasNextWallpaper = false.obs;

  @override
  void onInit() {
    super.onInit();
    sqliteService = SqliteService();

    Admob.requestTrackingAuthorization();
    bannerSize = AdmobBannerSize.BANNER;

    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (hasNextWallpaper.value) {
          getWallpaper();
        }
      }
    });

    categoryScrollController.addListener(() {
      if (categoryScrollController.offset >=
              categoryScrollController.position.maxScrollExtent &&
          !categoryScrollController.position.outOfRange) {
        if (hasNextCategory.value) getCategory();
      }
    });
    getCategory();
    getPopular();
    getFavorite();
  }

  Future<void> getCategory() async {
    if (categoryPage == 1) {
      isCategoryLoading.value = true;
      isLoadingMore.value = false;
      currentPopularPage = 1;
      currentPage = 1;
    }

    http.Response response =
    await http.get(Uri.parse(GET_CATEGORY + categoryPage.toString()));

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData['status'] == 1) {
        arrOfCategory.addAll((responseData['category'] as List)
            .map((data) => ModelCategory.fromJson(data as Map<String, dynamic>))
            .toList());
        if (responseData['hasNext']) {
          hasNextCategory.value = true;
          categoryPage = categoryPage + 1;
        } else {
          hasNextCategory.value = false;
        }
        debugPrint('Size Of Category Array:' + arrOfCategory.length.toString());
      }

      isCategoryLoading.value = false;
    } else {
      isCategoryLoading.value = false;
      debugPrint('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> getWallpaper() async {
    if (currentPage == 1) {
      isWallpaperLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    http.Response response = await http.get(Uri.parse(GET_WALLPAPER +
        "categoryId=" +
        modelCategory!.id.toString() +
        "&page=" +
        currentPage.toString() +
        ""));

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 1) {
        arrOfWallpaper.addAll((responseData['wallpaper'] as List)
            .map(
                (data) => ModelWallpaper.fromJson(data as Map<String, dynamic>))
            .toList());

        if (responseData['hasNext']) {
          hasNextWallpaper.value = true;
          currentPage = currentPage + 1;
        } else {
          hasNextWallpaper.value = false;
        }

        debugPrint('Size Of Wallpaper: ' + arrOfWallpaper.length.toString());
      }

      isWallpaperLoading.value = false;
      isLoadingMore.value = false;
    } else {
      isWallpaperLoading.value = false;
      isLoadingMore.value = false;
      debugPrint('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> getPopular() async {
    if (currentPopularPage == 1) {
      isPopularLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    http.Response response =
        await http.get(Uri.parse(GET_POPULAR + currentPopularPage.toString()));
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData['status'] == 1) {
        arrOfPopular.addAll((responseData['wallpaper'] as List)
            .map(
                (data) => ModelWallpaper.fromJson(data as Map<String, dynamic>))
            .toList());

        if (responseData['hasNext']) {
          hasNextWallpaper.value = true;
          currentPopularPage = currentPopularPage + 1;
        } else {
          hasNextWallpaper.value = false;
        }
      }

      isPopularLoading.value = false;
      isLoadingMore.value = false;
    } else {
      isPopularLoading.value = false;
      isLoadingMore.value = false;
      debugPrint('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> checkFavorite(int index) async {
    selected.value = index;
    isFavorite.value = await sqliteService.isFavorite(isPopular.value
        ? arrOfPopular[selected.value].id.toString()
        : arrOfWallpaper[selected.value].id.toString());
    debugPrint("IsFavorite = " + isFavorite.toString());
  }

  Future<void> updateFavorite(int index) async {
    isFavorite.value =
        await sqliteService.isFavorite(arrOfFavorite[index].id.toString());
  }

  Future<void> getFavorite() async {
    arrOfFavorite.value = await sqliteService.getAllFavorite();
    arrOfFavorite.toList().reversed;
  }

  void searchCategory() {
    arrOfSearchCategory.clear();
    for (int i = 0; i < arrOfCategory.length; i++) {
      if (arrOfCategory[i]
          .name
          .toString()
          .toLowerCase()
          .contains(searchText.toLowerCase())) {
        arrOfSearchCategory.add(arrOfCategory[i]);
      }
    }
  }
}
