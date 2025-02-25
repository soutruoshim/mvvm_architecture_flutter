import 'package:flutter/material.dart';
import 'package:mvvm_architecture/presentation/register/register_viewmodel.dart';

import '../../app/di.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});


  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  RegisterViewModel _viewModel = instance<RegisterViewModel>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _userNameTextEditingController =
  TextEditingController();
  TextEditingController _mobileNumberTextEditingController =
  TextEditingController();
  TextEditingController _userEmailEditingController = TextEditingController();
  TextEditingController _userPasswordEditingController =
  TextEditingController();

  _bind() {
    _viewModel.start();
    _userNameTextEditingController.addListener(() {
      _viewModel.setUserName(_userNameTextEditingController.text);
    });

    _userPasswordEditingController.addListener(() {
      _viewModel.setPassword(_userPasswordEditingController.text);
    });

    _userEmailEditingController.addListener(() {
      _viewModel.setEmail(_userEmailEditingController.text);
    });

    _mobileNumberTextEditingController.addListener(() {
      _viewModel.setMobileNumber(_mobileNumberTextEditingController.text);
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
    return Center();
  }
}
