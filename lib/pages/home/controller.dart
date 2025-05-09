import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/models/common/tab_type.dart';
import 'package:PiliPlus/utils/storage.dart';
import '../../http/index.dart';
import '../../utils/feed_back.dart';
import '../common/common_controller.dart';
import '../mine/view.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin, ScrollOrRefreshMixin {
  late List tabs;
  late List tabsCtrList;
  late TabController tabController;

  RxBool isLogin = false.obs;
  RxString userFace = ''.obs;

  StreamController<bool>? searchBarStream;
  late bool hideSearchBar;
  late bool useSideBar;

  late bool enableSearchWord;
  late RxString defaultSearch = ''.obs;
  late int lateCheckSearchAt = 0;

  ScrollOrRefreshMixin get controller {
    final index = tabController.index;
    return tabsCtrList[index]!(
        tag: switch (tabs[index]['type']) {
      TabType.bangumi => TabType.bangumi.name,
      TabType.cinema => TabType.cinema.name,
      _ => null,
    });
  }

  @override
  ScrollController get scrollController => controller.scrollController;

  @override
  void onInit() {
    super.onInit();
    final userInfo = GStorage.userInfo.get('userInfoCache');
    isLogin.value = userInfo != null;
    userFace.value = userInfo != null ? userInfo.face : '';

    hideSearchBar =
        GStorage.setting.get(SettingBoxKey.hideSearchBar, defaultValue: true);
    if (hideSearchBar) {
      searchBarStream = StreamController<bool>.broadcast();
    }

    enableSearchWord = GStorage.setting
        .get(SettingBoxKey.enableSearchWord, defaultValue: true);
    if (enableSearchWord) {
      lateCheckSearchAt = DateTime.now().millisecondsSinceEpoch;
      querySearchDefault();
    }

    useSideBar =
        GStorage.setting.get(SettingBoxKey.useSideBar, defaultValue: false);

    setTabConfig();
  }

  @override
  Future<void> onRefresh() {
    return controller.onRefresh().catchError((e) => debugPrint(e.toString()));
  }

  void setTabConfig() async {
    final defaultTabs = [...tabsConfig];
    final tabbarSort = GStorage.tabbarSort;
    defaultTabs.retainWhere(
        (item) => tabbarSort.contains((item['type'] as TabType).name));
    defaultTabs.sort((a, b) => tabbarSort
        .indexOf((a['type'] as TabType).name)
        .compareTo(tabbarSort.indexOf((b['type'] as TabType).name)));

    tabs = defaultTabs;

    tabsCtrList = tabs.map((e) => e['ctr']).toList();

    tabController = TabController(
      initialIndex: max(0, tabbarSort.indexOf(TabType.rcmd.name)),
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void querySearchDefault() async {
    try {
      var res = await Request().get(Api.searchDefault);
      if (res.data['code'] == 0) {
        defaultSearch.value = res.data['data']['name'];
      }
    } catch (_) {}
  }

  showUserInfoDialog(context) {
    feedBack();
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => const Dialog(
        child: MinePage(),
      ),
    );
  }

  @override
  void onClose() {
    searchBarStream?.close();
    super.onClose();
  }
}
