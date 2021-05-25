import 'package:flutter/material.dart';

import '../../Constants/routes.dart';
import '../../Services/auth.dart';
import '../../States/auth_state.dart';
import '../../States/confirmation_code_state.dart';
import '../../States/password_state.dart';
import '../../Utils/Helpers/not_null.dart';
import '../../Widgets/Auth/auth_button.dart';
import '../../Widgets/Auth/auth_error_message.dart';
import '../../Widgets/Auth/auth_navigation.dart';
import '../../Widgets/Auth/auth_page_title.dart';
import '../../Widgets/text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  ResetPasswordScreen({Key key, @required this.email}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() =>
      _ResetPasswordScreenState(email: email);
}

class _ResetPasswordScreenState extends AuthState<ResetPasswordScreen>
    with
        PasswordState<ResetPasswordScreen>,
        ConfirmationCodeState<ResetPasswordScreen> {
  final AuthService authService = AuthService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email;

  _ResetPasswordScreenState({this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AuthNavigation.from(context),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthPageTitle(name: 'Reset password'),
                  AuthErrorMessage(errorMessage: this.error),
                  Form(
                    key: this.formKey,
                    child: Column(
                      children: [
                        ConfirmationCodeTextField(
                            onChanged: this.updateConfirmationCode),
                        PasswordTextField(onChanged: this.updatePassword)
                      ],
                    ),
                  ),
                  AuthButton(
                    text: 'Continue',
                    formKey: this.formKey,
                    onClick: this.onSubmit,
                    onSuccess: this.onSuccess,
                    onError: this.onError,
                  )
                ].where(notNull).toList()),
          ),
        ));
  }

  Future<String> onSubmit() async {
    return await this
        .authService
        .resetPassword(this.email, this.password, this.confirmationCode);
  }

  void onSuccess() {
    Navigator.pushNamed(context, Routes.LOGIN);
  }
}
