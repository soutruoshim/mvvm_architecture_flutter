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

  HomeViewModel(this._homeUseCase);

  @override
  void start() {
    // TODO: implement start
    _getHome();
  }

  @override
  void dispose() {
    _bannersStreamController.close();
    _servicesStreamController.close();
    _storesStreamController.close();
    super.dispose();
  }
  @override
  Sink get inputBanners => _bannersStreamController.sink;

  @override
  Sink get inputServices => _servicesStreamController.sink;

  @override
  Sink get inputStores => _storesStreamController.sink;

  // outputs
  @override
  Stream<List<BannerAd>> get outputBanners =>
      _bannersStreamController.stream.map((banners) => banners);

  @override
  Stream<List<Service>> get outputServices =>
      _servicesStreamController.stream.map((services) => services);

  @override
  Stream<List<Store>> get outputStores =>
      _storesStreamController.stream.map((stores) => stores);

  _getHome() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE));

    (await _homeUseCase.execute(Void)).fold((failure) {
      inputState.add(ErrorState(
          StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message));
    }, (homeObject) {
      inputState.add(ContentState());
      inputBanners.add(homeObject.data.banners);
      inputServices.add(homeObject.data.services);
      inputStores.add(homeObject.data.stores);
    });
  }
}

abstract class HomeViewModelInputs {
  Sink get inputStores;

  Sink get inputServices;

  Sink get inputBanners;
}

abstract class HomeViewModelOutputs {
  Stream<List<Store>> get outputStores;

  Stream<List<Service>> get outputServices;

  Stream<List<BannerAd>> get outputBanners;
}