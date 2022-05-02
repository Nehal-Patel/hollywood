import 'package:flutter/material.dart';
const String GET_CATEGORY="https://codinghouse.in/wallpaper/api/getCategory?type=2&page=";
// const String GET_CATEGORY="http://benzatineinfotech.com/celebritywallpapers/test/2/";
const String GET_WALLPAPER="https://codinghouse.in/wallpaper/api/getWallpaper?";
// const String GET_WALLPAPER_BY_CATEGORY="http://benzatineinfotech.com/celebritywallpapers/test2/";
const String GET_POPULAR="https://codinghouse.in/wallpaper/api/getPopular?type=2&page=";
// const String GET_POPULAR="http://benzatineinfotech.com/celebritywallpapers/popularimages/1/";

int categoryClickCount=0;

int totalClickCount=0;
bool isReachToDownloadLimit=false;

String bannerId="ca-app-pub-7606304676433349/1618340404";
String interstitialId="ca-app-pub-7606304676433349/1426768711";
// String rewardId="ca-app-pub-7606304676433349/6604173856";

//test ads id
// String bannerId="ca-app-pub-3940256099942544/6300978111";
// String interstitialId="ca-app-pub-3940256099942544/1033173712";
// String rewardId="ca-app-pub-3940256099942544/5224354917";


void showToast(BuildContext context,String text){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: new Text(text),
  ));
}