import 'package:codingera2/controllers/banner_controller.dart';
import 'package:codingera2/models/banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BannerProvider extends StateNotifier<List<BannerModel>> {
  BannerProvider():super([]);
  bool _hasFetched = false;


  void addBanner(BannerModel banner){
    state = [...state, banner];
  }

  Future<void> setBanner({required BuildContext context,required WidgetRef ref})async{
    if (_hasFetched) return;
    List<BannerModel> banners = await BannerController().loadBanner(context: context,ref: ref);
    state = banners;
    _hasFetched = true;
  }



}

final bannerProvider = StateNotifierProvider<BannerProvider, List<BannerModel>>((ref) => BannerProvider());