import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MyLocaleController extends GetxController {
  static SharedPreferences ?sharedPreferences;

  MyLocaleController(SharedPreferences sharedPreferences);

  @override
  void onInit() {
    super.onInit();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Locale get initLang {
    String lang = sharedPreferences?.getString("lang") ?? "en";
    return lang == "ar" ? const Locale("ar") : const Locale("en");
  }

  static void changeLanguage(String newLocale) {
    SharedPreferences sharedPreferences = Get.find();
    Locale locale = Locale(newLocale);
    sharedPreferences.setString("lang", newLocale);
    Get.updateLocale(locale);
  }
}