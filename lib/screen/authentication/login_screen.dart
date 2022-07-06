import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theatrol/services/auth_service.dart';
import 'package:theatrol/theme.dart';
import 'package:theatrol/widget/loading_button.dart';

class LoginPage extends StatefulWidget {
  static const id = "login";

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  final GlobalKey<FormState> _fomKey = GlobalKey<FormState>();
  bool _passwordIsVisible = true;
  String _username = '';
  String _password = '';
  var _message = '';
  bool _showProgressIndicator = false;

  final Icon _visble = const Icon(
    Icons.visibility,
    color: primaryColor500,
    size: 25,
  );
  final Icon _hidden = const Icon(
    Icons.visibility_off,
    color: Colors.grey,
    size: 25,
  );

  Widget _buildUsername() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'username',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            enableSuggestions: true,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (v) {
              FocusScope.of(context).nextFocus();
            },
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                labelText: 'Username',
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Username';
              }

              return null;
            },
            onSaved: (String? value) {
              value == null ? _username = "" : _username = value;
            },
          )
        ],
      ),
    );
  }

  Widget _buildPassword() {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Password',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            obscureText: _passwordIsVisible,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (v) {
              FocusScope.of(context).unfocus();
            },
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
                labelText: 'Password',
                border: InputBorder.none,
                fillColor: const Color(0xfff3f3f4),
                filled: true,
                suffixIcon: IconButton(
                    icon: _passwordIsVisible == true ? _hidden : _visble,
                    onPressed: () {
                      setState(() {
                        _passwordIsVisible = !_passwordIsVisible;
                      });
                    })),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                'Please enter Password';
              }
              return null;
            },
            onSaved: (String? value) {
              value == null ? _password = "" : _password = value;
            },
          )
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Text(_message,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red));
  }

  Widget _submitButton(AuthService authenticationService) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (!_fomKey.currentState!.validate()) {
          return;
        }

        _fomKey.currentState!.save();

        setState(() => _showProgressIndicator = true);

        authenticationService
            .login(username: _username.trim(), password: _password.trim())
            .then((value) {
          if (mounted) {
            setState(() {
              _showProgressIndicator = false;

              _message = value ?? '';
            });
          }
          //Navigate to home sreen only if user is Signed In
          if (value == '') {
            if (_username == 'admin') {
              Beamer.of(context).beamToNamed('/add-show');
            } else {
              Beamer.of(context).beamToNamed('/');
            }
          }
        });
      },
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            color: primaryColor500,
          ),
          child: const Text(
            'Login',
            style: TextStyle(color: colorWhite),
          )),
    );
  }

  Widget _usernamePasswordWidget() {
    return Column(
      children: <Widget>[
        _buildUsername(),
        _buildPassword(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final authProvider = context.read<AuthService>();

    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        height: height,
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Theatrol',
                  style: TextStyle(
                      color: primaryColor500,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _fomKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _usernamePasswordWidget(),
                      _buildErrorMessage(),
                      const SizedBox(height: 20),
                      _showProgressIndicator == false
                          ? _submitButton(authProvider)
                          : Row(
                              children: const [
                                LoadingButton(),
                              ],
                            ),

                      // _registerButton()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
