import 'package:get/get.dart';
import 'package:wallpaperset/controller/category_controller.dart';
import 'package:wallpaperset/controller/wallpaper_controller.dart';

class BindingController extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryController(), fenix: true);
    Get.lazyPut(() => WallpaperController(), fenix: true);
  }


}