import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvvm_architecture/presentation/register/register_viewmodel.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../data/mapper/mapper.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});


  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  RegisterViewModel _viewModel = instance<RegisterViewModel>();
  AppPreferences _appPreferences = instance<AppPreferences>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _userNameTextEditingController = TextEditingController();
  TextEditingController _mobileNumberTextEditingController = TextEditingController();
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();

  ImagePicker picker = instance<ImagePicker>();


  _bind() {
    _viewModel.start();
    _userNameTextEditingController.addListener(() {
      _viewModel.setUserName(_userNameTextEditingController.text);
    });

    _passwordEditingController.addListener(() {
      _viewModel.setPassword(_passwordEditingController.text);
    });
    _emailEditingController.addListener(() {
      _viewModel.setEmail(_emailEditingController.text);
    });

    _mobileNumberTextEditingController.addListener(() {
      _viewModel.setMobileNumber(_mobileNumberTextEditingController.text);
    });

    _viewModel.isUserLoggedInSuccessfullyStreamController.stream
        .listen((isSuccessLoggedIn) {
      // navigate to main screen
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        _appPreferences.setIsUserLoggedIn();
        Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
      });
    });

}

  _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  trailing: Icon(Icons.arrow_forward),
                  leading: Icon(Icons.camera),
                  title: Text(AppStrings.photoGalley),
                  onTap: () {
                    _imageFormGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  trailing: Icon(Icons.arrow_forward),
                  leading: Icon(Icons.camera_alt_rounded),
                  title: Text(AppStrings.photoCamera),
                  onTap: () {
                    _imageFormCamera();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  _imageFormGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  _imageFormCamera() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
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
  Widget _getMediaWidget() {
    return Padding(
      padding: EdgeInsets.only(left: AppPadding.p8, right: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(AppStrings.profilePicture)),
          Flexible(
              child: StreamBuilder<File?>(
                stream: _viewModel.outputIsProfilePictureValid,
                builder: (context, snapshot) {
                  return _imagePickedByUser(snapshot.data);
                },
              )),
          Flexible(child: SvgPicture.asset(ImageAssets.photoCameraIc)),
        ],
      ),
    );
  }

  Widget _imagePickedByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      return Image.file(image);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: AppSize.s0,
        iconTheme: IconThemeData(color: ColorManager.primary),
        backgroundColor: ColorManager.white,
      ),
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return Center(
            child: snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _viewModel.register();
                }) ??
                _getContentWidget(),
          );
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
        padding: EdgeInsets.only(top: AppPadding.p30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image(image: AssetImage(ImageAssets.splashLogo)),
                SizedBox(height: AppSize.s28),
                Padding(
                  padding: EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<String?>(
                    stream: _viewModel.outputErrorUserName,
                    builder: (context, snapshot) {
                      return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _userNameTextEditingController,
                          decoration: InputDecoration(
                              hintText: AppStrings.username,
                              labelText: AppStrings.username,
                              errorText: snapshot.data));
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: AppPadding.p20,
                        left: AppPadding.p28,
                        right: AppPadding.p28,
                        bottom: AppPadding.p12),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: CountryCodePicker(
                              onChanged: (country) {
                                // update view model with the selected code
                                _viewModel
                                    .setCountryCode(country.dialCode ?? EMPTY);
                              },
                              initialSelection: "+855",
                              hideMainText: true,
                              showCountryOnly: true,
                              showOnlyCountryWhenClosed: true,
                              favorite: ["+966", "+02", "+39"],
                            )),
                        Expanded(
                            flex: 3,
                            child: StreamBuilder<String?>(
                              stream: _viewModel.outputErrorMobileNumber,
                              builder: (context, snapshot) {
                                return TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller:
                                    _mobileNumberTextEditingController,
                                    decoration: InputDecoration(
                                        hintText: AppStrings.mobileNumber,
                                        labelText: AppStrings.mobileNumber,
                                        errorText: snapshot.data));
                              },
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppSize.s12),
                Padding(
                  padding: EdgeInsets.only(
                      left: AppPadding.p28,
                      right: AppPadding.p28),
                  child: StreamBuilder<String?>(
                    stream: _viewModel.outputErrorEmail,
                    builder: (context, snapshot) {
                      return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailEditingController,
                          decoration: InputDecoration(
                              hintText: AppStrings.emailHint,
                              labelText: AppStrings.emailHint,
                              errorText: snapshot.data));
                    },
                  ),
                ),
                SizedBox(height: AppSize.s12),
                Padding(
                  padding: EdgeInsets.only(
                      top: AppPadding.p12,
                      left: AppPadding.p28,
                      right: AppPadding.p28),
                  child: StreamBuilder<String?>(
                    stream: _viewModel.outputErrorPassword,
                    builder: (context, snapshot) {
                      return TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordEditingController,
                          decoration: InputDecoration(
                              hintText: AppStrings.password,
                              labelText: AppStrings.password,
                              errorText: snapshot.data));
                    },
                  ),
                ),
                SizedBox(height: AppSize.s12),
                Padding(
                  padding: EdgeInsets.only(
                      top: AppPadding.p12,
                      left: AppPadding.p28,
                      right: AppPadding.p28),
                  child: Container(
                    height: AppSize.s40,
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorManager.lightGrey)),
                    child: GestureDetector(
                      child: _getMediaWidget(),
                      onTap: (){
                        _showPicker(context);
                      },
                    ),
                  ),
                ),
                SizedBox(height: AppSize.s28),
                Padding(
                    padding: EdgeInsets.only(
                        left: AppPadding.p28,
                        right: AppPadding.p28),
                    child: StreamBuilder<bool>(
                      stream: _viewModel.outputIsAllInputsValid,
                      builder: (context, snapshot) {
                        print("snapshot");
                        print(snapshot.data);
                        return SizedBox(
                          width: double.infinity,
                          height: AppSize.s40,
                          child: ElevatedButton(
                              onPressed: (snapshot.data ?? false)
                                  ? () {
                                _viewModel.register();
                              }
                                  : null,
                              child: Text(AppStrings.register)),
                        );
                      },
                    )),
                Padding(
                  padding: EdgeInsets.only(
                    top: AppPadding.p8,
                    left: AppPadding.p28,
                    right: AppPadding.p28,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppStrings.haveAccount,
                        style: Theme.of(context).textTheme.bodyMedium),
                  )
                )
              ],
            ),
          ),
        ));
  }
}
