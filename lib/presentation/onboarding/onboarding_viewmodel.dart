import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:mvvm_architecture/presentation/base/baseviewmodel.dart';

import '../domain/model.dart';
import '../resources/assets_manager.dart';
import '../resources/strings_manager.dart';

class OnBoardingViewModel extends BaseViewModel
    with OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  final StreamController _streamController =
      StreamController<SliderViewObject>();

  late final List<SliderObject> _list;
  int _currentIndex = 0;

  @override
  int goNext() {
    int nextIndex = _currentIndex++; // +1
    if (nextIndex >= _list.length) {
      _currentIndex = 0; // infinite loop to go to first item inside the slider
    }
    return _currentIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = _currentIndex--; // -1
    if (previousIndex == -1) {
      _currentIndex =
          _list.length - 1; // infinite loop to go to the length of slider list
    }
    return _currentIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _postDataToView();
  }

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    _list = _getSliderData();
    _postDataToView();
  }

  @override
  // TODO: implement inputSliderViewObject
  Sink get inputSliderViewObject => _streamController.sink;

  @override
  // TODO: implement outputSliderViewObject
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((slideViewObject) => slideViewObject);

  // private functions
  List<SliderObject> _getSliderData() => [
    SliderObject(
        AppStrings.onBoardingTitle1.tr(),
        AppStrings.onBoardingSubTitle1.tr(),
        ImageAssets.onboardingLogo1),
    SliderObject(
        AppStrings.onBoardingTitle2.tr(),
        AppStrings.onBoardingSubTitle2.tr(),
        ImageAssets.onboardingLogo2),
    SliderObject(
        AppStrings.onBoardingTitle3.tr(),
        AppStrings.onBoardingSubTitle3.tr(),
        ImageAssets.onboardingLogo3),
    SliderObject(
        AppStrings.onBoardingTitle4.tr(),
        AppStrings.onBoardingSubTitle4.tr(),
        ImageAssets.onboardingLogo4)
      ];
  _postDataToView() {
    inputSliderViewObject.add(
        SliderViewObject(_list[_currentIndex], _list.length, _currentIndex));
  }
}

// inputs mean the orders that our view model will recieve from our view
mixin OnBoardingViewModelInputs {
  int goNext(); // when user clicks on right arrow or swipe left.
  int goPrevious(); // when user clicks on left arrow or swipe right.
  void onPageChanged(int index);
  Sink
      get inputSliderViewObject; // this is the way to add data to the stream .. stream input
}
// outputs mean data or results that will be sent from our view model to our view
mixin OnBoardingViewModelOutputs {
  // will be implement it later
  Stream<SliderViewObject> get outputSliderViewObject;
}

class SliderViewObject {
  SliderObject sliderObject;
  int numOfSlides;
  int currentIndex;
  SliderViewObject(this.sliderObject, this.numOfSlides, this.currentIndex);
}
