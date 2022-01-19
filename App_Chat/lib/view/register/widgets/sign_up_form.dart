import 'package:chat/utils/failure.dart';
import 'package:chat/utils/functions.dart';
import 'package:chat/view/register/bloc/account_bloc.dart';
import 'package:chat/view/utils/device_config.dart';
import 'package:chat/view/widgets/button_widget.dart';
import 'package:chat/view/widgets/input_field.dart';
import 'package:chat/view/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key key,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm>
    with AutomaticKeepAliveClientMixin {
  String username, email, password;
  final _formKey = GlobalKey<FormState>();
  Failure failure;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    DeviceData deviceData = DeviceData.init(context);

    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) => _mapStateToActions(state),
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) => Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: deviceData.screenWidth * 0.11,
                    right: deviceData.screenWidth * 0.11,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InputField(inputIcon: Icon(Icons.person),
                        inputType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.words,
                        inputTitle: "Tên người dùng",
                        hintText: "Nhập tên người dùng",
                        onSaved: (value) {
                          username = value;
                        },
                      ),
                      SizedBox(height: deviceData.screenHeight * 0.02),
                      InputField(inputIcon: Icon(Icons.mail_outline),
                        inputTitle: "Email",
                        inputType: TextInputType.emailAddress,
                        hintText: "Nhập email",
                        onSaved: (value) {
                          email = value;
                        },
                        errorText:
                            failure is EmailException ? failure.code : null,
                      ),
                      SizedBox(height: deviceData.screenHeight * 0.02),
                      InputField(inputIcon: Icon(Icons.lock_outline),
                        inputTitle: "Mật khẩu",
                        obscureText: true,
                        hintText: "Nhập mật khẩu",
                        onSaved: (value) {
                          password = value;
                        },
                        errorText:
                            failure is PasswordException ? failure.code : null,
                      ),
                      SizedBox(height: deviceData.screenHeight * 0.02),
                      InputField(inputIcon: Icon(Icons.lock_outline_sharp),
                        inputTitle: "Xác nhận mật khẩu",
                        obscureText: true,
                        hintText: "Nhập lại mật khẩu",
                        isLastField: true,
                        onValidator: (value) {
                          if (password != value) {
                            return 'Mật khẩu không khớp';
                          }
                          return null;
                        },
                        onSubmitted: (value) {
                          _onSubmit();
                        },
                      ),
                      SizedBox(height: deviceData.screenHeight * 0.03),
                      RoundedButton(
                          text: "Đăng ký",
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _onSubmit();
                          })
                    ],
                  ),
                ),
              ),
            ),
            loading
                ? Padding(
                    padding:
                        EdgeInsets.only(bottom: deviceData.screenHeight * 0.3),
                    child: Center(child: const CircleProgress()),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      BlocProvider.of<AccountBloc>(context).add(
          SignupEvent(email: email, password: password, username: username));
    }
  }

  void _mapStateToActions(AccountState state) {
    failure = NoException();
    loading = false;
    if (Functions.modalIsShown) {
      Navigator.pop(context);
      Functions.modalIsShown = false;
    }
    if (state is SignupFailed) {
      failure = state.failure;
      if (state.failure is BottomPlacedException) {
        Functions.showBottomMessage(context, failure.code);
      }
    } else if (state is SignupLoading) {
      Functions.showBottomMessage(context, "Đăng ký ... ",
          isDismissible: false);
      loading = true;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
