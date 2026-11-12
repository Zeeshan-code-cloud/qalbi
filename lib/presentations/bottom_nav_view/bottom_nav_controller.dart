import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:qalbi/presentations/holy_quran/holy_quran_vew.dart';

import '../calender_view/calender_view.dart';
import '../duas_view/duas_view.dart';
import '../home_view/home_view.dart';
import '../setting_view/setting_view.dart';

class BottomNavController extends GetxController{

  RxInt currentIndex = 0.obs;
  List<Widget> pages = [
    const HomeView(),
    const HolyQuranVew(),
      DuasView(),
      CalenderView(),
    const SettingView(),
  ];
}