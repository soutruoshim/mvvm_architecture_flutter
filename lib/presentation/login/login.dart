import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import 'login_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginViewModel _viewModel = instance<LoginViewModel>();
  AppPreferences _appPreferences = instance<AppPreferences>();

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _bind() {
    _viewModel.start();
    _userNameController.addListener(() => _viewModel.setUserName(_userNameController.text));
    _passwordController.addListener(() => _viewModel.setPassword(_passwordController.text));

    _viewModel.isUserLoggedInSuccessfullyStreamController.stream
        .listen((token) {
      // navigate to main screen
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        _appPreferences.setUserToken(token);
        _appPreferences.setIsUserLoggedIn();
        resetModules();
        Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
      });
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _viewModel.login();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return  Container(
        padding: EdgeInsets.only(top: AppPadding.p100),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image(image: AssetImage(ImageAssets.splashLogo)),
                SizedBox(height: AppSize.s28),
                Padding(padding: EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outputIsUserNameValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _userNameController,
                        decoration: InputDecoration(
                            hintText: AppStrings.username.tr(),
                            labelText: AppStrings.username.tr(),
                            errorText: (snapshot.data ?? true)
                                ? null
                                : AppStrings.usernameError
                        ),
                      );
                    },
                  ),),
                SizedBox(height: AppSize.s28),
                Padding(padding: EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outputIsPasswordValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordController,
                        decoration: InputDecoration(
                            hintText: AppStrings.password.tr(),
                            labelText: AppStrings.password.tr(),
                            errorText: (snapshot.data ?? true)
                                ? null
                                : AppStrings.passwordError.tr()
                        ),
                      );
                    },
                  ),),
                const SizedBox(height: AppSize.s28),
                Padding(padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                    child: StreamBuilder<bool>(
                    stream: _viewModel.outputIsAllInputsValid
                      , builder: (context, snapshot) {
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s40,
                        child: ElevatedButton(
                            onPressed: (snapshot.data ?? false)
                                ? () {
                              _viewModel.login();
                            }
                                : null,
                            child: Text(AppStrings.login)),
                      );
                    },
                    )
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppPadding.p8,
                    left: AppPadding.p28,
                    right: AppPadding.p28,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, Routes.forgotPasswordRoute);
                        },
                        child: Text(AppStrings.forgetPassword,
                            style: Theme.of(context).textTheme.headlineMedium).tr(),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, Routes.registerRoute);
                        },
                        child: Text(AppStrings.registerText,
                            style: Theme.of(context).textTheme.headlineMedium).tr(),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}
