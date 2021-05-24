import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/model/emuns.dart';
import 'package:send_me_pic/app/model/user_model.dart';
import 'package:send_me_pic/app/providers/auth_provider.dart';
import 'package:send_me_pic/app/utilities/custom_popup.dart';
import 'package:send_me_pic/app/widgets/loading_small.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  bool isAppleAvailable = false;

  isAppleAvail() async{
    bool cool = false;
    print('Avail');
    cool = await SignInWithApple.isAvailable();
    setState(() {
      isAppleAvailable = cool;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isAppleAvail();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    final double _layerHeight = _size.height / 1.8;

    final auth = Provider.of<AuthProvider>(context);

    void _onTapGoogleBtn() async {

      auth.loginType = LoginType.google;

      try{
        await auth.signInWithGoogle();
      }catch(e){
        CustomPopup(context, title: '', message: e.toString(), primaryBtnTxt: 'OK');
      }

    }

    void _onTapAppleBtn() async {
      auth.loginType = LoginType.apple;

      try{
        await auth.signInWithApple();
      }catch(e){
        CustomPopup(context, title: '', message: e.toString(), primaryBtnTxt: 'OK');
      }

    }

    void _onTapFacebookBtn() async {
      auth.loginType = LoginType.facebook;
      try{
        await auth.facebookSignIn();
      }catch(e){
        CustomPopup(context, title: '', message: e.toString(), primaryBtnTxt: 'OK');
      }
    }

    void dummyLogin() async {

      try{
        auth.logInUser(
            loginType: LoginType.google,
            userProfileImage: "",
            socialID: "115992803687165016150",
            email: "raghdaeltaher85@gmail.com",
            firstName: "Raghda",
            lastName: "Raghda");
      }catch(e){
        print('ERROR: ' + e);
      }

    }

    return Scaffold(
      body: Container(
        color: kSignInBGColor,
        height: double.infinity,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: _size.height/2,
                  child: Image.asset('assets/images/send_me_bg_opeque.png',fit: BoxFit.fitHeight,)),
            ),
            Container(
              alignment: Alignment.topLeft,
              height: _layerHeight,
              padding: EdgeInsets.all(30),
              color: Colors.white.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,color: kPrimaryColor),
                  ),
                  Text(
                    'to your account',
                    style: TextStyle(fontSize: 20,color: kPrimaryColor),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Consumer<AuthProvider>(
                builder: (_, provider, __) {
                  bool isLoading = false;


                  if(provider.loginData != null){
                    var login = provider.loginData.data;

                    switch(provider.loginData.state){
                      case Status.LOADING:
                        isLoading = true;
                        break;
                      case Status.COMPLETED:
                        isLoading = false;
                        provider.updateUser(MyLocalUser(isLogin: true, isFirstTime: false));
                        break;
                      case Status.ERROR:
                        break;
                    }
                  }

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    height: _layerHeight,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          height: 7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: Color(0x1f000000),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: ListView(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                _SignInBtn(
                                  color: kSignInGoogleColor,
                                  text: 'Sign in with Google',
                                  icon: 'assets/images/sign_in_google.png',
                                  onTap: _onTapGoogleBtn,
                                  isLoading: isLoading,
                                  showLoading: auth.loginType == LoginType.google,
                                ),
                                SizedBox(height: 15),
                                _SignInBtn(
                                  color: kSignInFacebookColor,
                                  text: 'Login with Facebook',
                                  icon: 'assets/images/sign_in_facebook.png',
                                  onTap: _onTapFacebookBtn,
                                  isLoading: isLoading,
                                  showLoading: auth.loginType == LoginType.facebook,
                                ),
                                SizedBox(height: 15),
                                if(isAppleAvailable)
                                  _SignInBtn(
                                    color: kSignInAppleColor,
                                    text: 'Sign in with Apple',
                                    icon: 'assets/images/sign_in_apple.png',
                                    onTap: _onTapAppleBtn,
                                    isLoading: isLoading,
                                    showLoading: auth.loginType == LoginType.apple,
                                  ),
                                // SizedBox(height: 15),
                                // _SignInBtn(
                                //   color: kSignInAppleColor,
                                //   text: 'Dummy Login',
                                //   icon: 'assets/images/sign_in_apple.png',
                                //   onTap: dummyLogin,
                                //   isLoading: isLoading,
                                //   showLoading: auth.loginType == LoginType.apple,
                                // ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SignInBtn extends StatelessWidget {
  const _SignInBtn(
      {@required this.color,
      @required this.icon,
      @required this.text,
      @required this.onTap,
        @required this.isLoading,
  @required this.showLoading});

  final Color color;
  final String icon;
  final String text;
  final VoidCallback onTap;
  final bool isLoading;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(10)),
      child: TextButton(
        onPressed: isLoading ? null : onTap ,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              child: Image.asset(
                icon,
                fit: BoxFit.contain,
                // color: Colors.white,
              ),
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            if(showLoading && isLoading)
              Container(
                  margin: EdgeInsets.only(left: 15),
                  height: 10,
                  width: 10,
                  child: LoadingSmall())
          ],
        ),
      ),
    );
  }
}