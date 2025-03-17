import 'dart:async';
import 'dart:ffi';

import 'package:rxdart/rxdart.dart';

import '../../../domain/model/model.dart';
import '../../../domain/usecase/home_usecase.dart';
import '../../base/baseviewmodel.dart';
import '../../common/state_renderer.dart';
import '../../common/state_renderer/state_render_impl.dart';

class HomeViewModel extends BaseViewModel
implements HomeViewModelInputs, HomeViewModelOutputs {
  HomeUseCase _homeUseCase;

  StreamController _bannersStreamController = BehaviorSubject<List<BannerAd>>();
  StreamController _servicesStreamController = BehaviorSubject<List<Service>>();
  StreamController _storesStreamController = BehaviorSubject<List<Store>>();
  final _dataStreamController = BehaviorSubject<HomeViewObject>();

  HomeViewModel(this._homeUseCase);

  @override
  void start() {
    _getHome();
  }

  _getHome() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE));

    (await _homeUseCase.execute(Void)).fold((failure) {
      inputState.add(ErrorState(
          StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message));
    }, (homeObject) {
      inputState.add(ContentState());
      inputHomeData.add(HomeViewObject(homeObject.data.stores,
          homeObject.data.services, homeObject.data.banners));
    });
  }


  @override
  void dispose() {
    _dataStreamController.close();
    super.dispose();
  }

  Sink get inputHomeData => _dataStreamController.sink;

  // outputs
  @override
  Stream<HomeViewObject> get outputHomeData =>
      _dataStreamController.stream.map((data) => data);
}

abstract class HomeViewModelInputs {
  Sink get inputHomeData;
}

abstract class HomeViewModelOutputs {
  Stream<HomeViewObject> get outputHomeData;
}

class HomeViewObject {
  List<Store> stores;
  List<Service> services;
  List<BannerAd> banners;
  HomeViewObject(this.stores, this.services, this.banners);
}