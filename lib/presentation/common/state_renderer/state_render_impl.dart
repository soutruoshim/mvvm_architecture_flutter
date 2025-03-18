import 'package:easy_localization/easy_localization.dart';

import '../../../data/mapper/mapper.dart';
import '../../resources/strings_manager.dart';
import '../state_renderer.dart';
import 'package:flutter/material.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();
  String getMessage();
}

// Loading State (POPUP, FULL SCREEN)
class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String message;
  LoadingState({required this.stateRendererType, String? message})
      :message = message ?? AppStrings.loading.tr();
  @override
  String getMessage() => message;
  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// error state (POPUP, FULL LOADING)
class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;
  ErrorState(this.stateRendererType, this.message);
  @override
  String getMessage() => message;
  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// success state
class SuccessState extends FlowState {
  String message;
  SuccessState(this.message);
  @override
  String getMessage() => message;
  @override
  StateRendererType getStateRendererType() => StateRendererType.POPUP_SUCCESS;
}

// CONTENT STATE
class ContentState extends FlowState {
  ContentState();
  @override
  String getMessage() => EMPTY;
  @override
  StateRendererType getStateRendererType() => StateRendererType.CONTENT_SCREEN_STATE;
}

// EMPTY STATE
class EmptyState extends FlowState {
  String message;
  EmptyState(this.message);
  @override
  String getMessage() => message;
  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.EMPTY_SCREEN_STATE;
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (this.runtimeType) {
      case LoadingState:
        {
          if (getStateRendererType() == StateRendererType.POPUP_LOADING_STATE) {
            // showing popup dialog
            showPopUp(context, getStateRendererType(), getMessage());
            // return the content ui of the screen
            return contentScreenWidget;
          } else // StateRendererType.FULL_SCREEN_LOADING_STATE
          {
            return StateRenderer(
                stateRendererType: getStateRendererType(),
                message: getMessage(),
                retryActionFunction: retryActionFunction);
          }
        }
      case SuccessState:
        {
          // i should check if we are showing loading popup to remove it before showing success popup
          dismissDialog(context);
          // show popup
          showPopUp(context, StateRendererType.POPUP_SUCCESS, getMessage(), title: AppStrings.success.tr());
          // return content ui of the screen
          return contentScreenWidget;
        }
      case ErrorState:
        {
          dismissDialog(context);
          if (getStateRendererType() == StateRendererType.POPUP_ERROR_STATE) {
            // showing popup dialog
            showPopUp(context, getStateRendererType(), getMessage());
            // return the content ui of the screen
            return contentScreenWidget;
          } else // StateRendererType.FULL_SCREEN_ERROR_STATE
          {
            return StateRenderer(
                stateRendererType: getStateRendererType(),
                message: getMessage(),
                retryActionFunction: retryActionFunction);
          }
        }
      case ContentState:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
      case EmptyState:
        {
          return StateRenderer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              retryActionFunction: retryActionFunction);
        }
      default:
        {
          return contentScreenWidget;
        }
    }
  }

  dismissDialog(BuildContext context) {
    if (_isThereCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }
  _isThereCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  showPopUp(BuildContext context, StateRendererType stateRendererType,
      String message,{String title = EMPTY}) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
              stateRendererType: stateRendererType,
              message: message,
              retryActionFunction: () {},
            )));
  }
}



