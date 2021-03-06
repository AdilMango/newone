// ignore_for_file: unused_field, non_constant_identifier_names, missing_return

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilminneed/helper/resources/images.dart';
import 'package:ilminneed/helper/resources/strings.dart';
import 'package:ilminneed/src/ui_helper/colors.dart';
import 'package:ilminneed/src/ui_helper/textFieldStyle.dart';
import 'package:ilminneed/src/ui_helper/text_styles.dart';
import 'package:ilminneed/src/widgets/button.dart';
import 'package:ilminneed/src/widgets/header_text.dart';
import 'package:ilminneed/src/widgets/hint_text.dart';
import 'package:get/get.dart';
import 'package:ilminneed/src/controller/globalctrl.dart' as ctrl;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final GlobalKey<FormState> _formKey  = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _loading = false;
  bool _obscureText = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleSignInAuthentication googleAuth;
  GoogleSignInAccount _currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  _register() async {
    if(!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() { _loading = true;});
    var res = await ctrl.requestwithoutheader({'name': _name.text,'email': _email.text,'password': _password.text}, 'register/user');
    setState(() { _loading = false; });
    if (res != null && res['error'] == null) {
      await ctrl.toastmsg(res['message'], 'long');
      Get.offAllNamed('/signIn');
    } else {
      setState(() { _loading = false; });
      await ctrl.toastmsg(res['message'], 'long');
    }
  }

  Future<void> _googlelogin() async {
    ctrl.toastmsg('fetching info...','long');
    try {
      await _googleSignIn.signIn().then((value) {
        print(value);
        value.authentication.then((valueq) {
          Map<String, dynamic> decodedToken = JwtDecoder.decode(valueq.idToken);
          print(decodedToken.toString());
          print(decodedToken['email'].toString());
          //_showmsg(decodedToken.toString());
          if(decodedToken['email'].toString() != '' && decodedToken['email'].toString() != null){
            setState(() {
              _loading = true;
            });
//            email_ctrl.text = decodedToken['email'].toString();
//            name_ctrl.text = decodedToken['name'].toString();
//            password_ctrl.text = decodedToken['iat'].toString();
           // _createaccount();
          }
        });
      });
    } catch (error) {
      setState(() {
        _loading = false;
      });
      print(error.toString());
      ctrl.toastmsg('Error. Please try again','long');
    }
  }


  Widget SocialMediaButton(String svgAsset, String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: socialButtonDecoration(),
      width: MediaQuery.of(context).size.width / 2.5,
      height: 50,
      child: Row(
        children: [
          SvgPicture.asset(
            svgAsset,
            height: 25,
            width: 25,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: buttonTextStyle().copyWith(color: konDarkColorB1),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return LoadingOverlay(
      isLoading: _loading,
      color: Colors.white,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: konLightColor2,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 20, bottom: 8, left: 8, right: 8),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      signIn,
                    ),
                    HeaderTextWidget(label: SIGN_UP),
                    HintWidget(
                      label: SIGN_UP_HINT,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: TextFormField(
                        controller: _name,
                        validator: (String value) {
                          if(value.isEmpty){
                            return 'Name is required.';
                          }
                        },
                        style: mediumTextStyle().copyWith(color: konDarkColorB1),
                        decoration: textFormFieldInputDecoration('name'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: TextFormField(
                        controller: _email,
                        validator: (String value) {
                          if(value.isEmpty){
                            return 'Email is required';
                          }
                          if(!RegExp("^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*").hasMatch(value)){
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                        style: mediumTextStyle().copyWith(color: konDarkColorB1),
                        decoration: textFormFieldInputDecoration('email'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: TextFormField(
                        controller: _password,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscureText,
                        validator: (String value) {
                          if(value.isEmpty){
                            return 'Password is required';
                          }
                          if(value.length <= 6){
                            return 'Password should be minimum 6 characters';
                          }
                        },
                        style: mediumTextStyle().copyWith(color: konDarkColorB1),
                        decoration: textFormFieldInputDecoration('password')
                            .copyWith(suffixIcon: InkWell(onTap: (){  setState(() {
                          _obscureText = !_obscureText;
                        });},child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off))),
                      ),
                    ),
                    InkWell(
                      onTap: _register,
                      child: ButtonWidget(
                        value: SIGN_UP,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 1.5,
                            width: MediaQuery.of(context).size.width / 4,
                            color: konLightColor3,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              SIGN_UP_OPTION,
                              style:
                                  smallTextStyle().copyWith(color: konLightColor3),
                            ),
                          ),
                          Container(
                            height: 1.5,
                            width: MediaQuery.of(context).size.width / 4,
                            color: konLightColor3,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 25, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(onTap:(){ _googlelogin(); }, child: SocialMediaButton(google, GOOGLE)),
                          InkWell(onTap:(){ ctrl.toastmsg('Coming soon', 'short'); }, child: SocialMediaButton(facebook, FACEBOOK)),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Get.offAllNamed('/signIn');
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ALREADY_MEMBER,
                              style: smallTextStyle().copyWith(color: konDarkColorB1),
                            ),
                            Text(
                              SIGN_IN,
                              style: buttonTextStyle().copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationColor: konPrimaryColor1,
                                  color: konPrimaryColor1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
