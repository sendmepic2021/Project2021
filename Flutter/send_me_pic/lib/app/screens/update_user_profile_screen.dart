import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/model/user_pref.dart';
import 'package:send_me_pic/app/providers/user_profile_provider.dart';
import 'package:send_me_pic/app/services/image_picker_service.dart';
import 'package:send_me_pic/app/services/image_service.dart';
import 'package:send_me_pic/app/utilities/custom_popup.dart';
import 'package:send_me_pic/app/utilities/network_image.dart';
import 'package:send_me_pic/app/widgets/loading_small.dart';
import 'package:send_me_pic/app/utilities/extensions.dart';

class UpdateUserProfileScreen extends StatefulWidget {
  @override
  _UpdateUserProfileScreenState createState() =>
      _UpdateUserProfileScreenState();
}

class _UpdateUserProfileScreenState extends State<UpdateUserProfileScreen> {
  bool _isProfilePrivate = false;

  PickImage imgPicker;

  bool isLoading = false;

  String profileUrl =
      'https://st4.depositphotos.com/4329009/19956/v/600/depositphotos_199564354-stock-illustration-creative-vector-illustration-default-avatar.jpg';

  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController emailController;
  TextEditingController mobileController;
  TextEditingController privateNameController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    mobileController = TextEditingController();
    privateNameController = TextEditingController();

    _getImgUrl();

    getLocalData();

    imgPicker = PickImage(
        context: context,
        updateFile: () {
          setState(() {});
        });

    imgPicker.maxWidth = 180.0;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final userProvider =
          Provider.of<UserProfileProvider>(context, listen: false);

      final userData = userProvider.user.data.data;

      firstNameController.text = userData.firstName ?? "";
      lastNameController.text = userData.lastName ?? "";
      emailController.text = userData.email ?? "";
      mobileController.text = userData.mobile ?? "";
      privateNameController.text = userData.publicName ?? "Anonymous Name";

      print("public_name: " + userData.publicName);

    });
  }

  Future getLocalData() async{

    var local = await UserPreferences().getUser();

    setState(() {
      _isProfilePrivate = local.isPrivateProfile == 1;
    });

  }

  Future _getImgUrl() async {
    var user = await UserPreferences().getUser();

    setState(() {
      profileUrl = kImgBaseURL + user.userImage;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    privateNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: kSignInBGColor,
      body: Consumer<UserProfileProvider>(
        builder: (_, provider, __) {
          var updatedUser = provider.updatedUser;

          switch (updatedUser.state) {
            case Status.LOADING:
              isLoading = true;
              break;
            case Status.COMPLETED:
              isLoading = false;
              break;
            case Status.ERROR:
              isLoading = false;
              break;
          }

          return buildStack(context);
        },
      ),
    );
  }

  Widget buildStack(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          bottom: _size.height / 2,
          child: Image.asset('assets/images/send_me_bg_opeque.png',fit: BoxFit.fitHeight,),
        ),
        SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    top: 60,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                        decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30)),
                    )),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: imgPicker.selectImage,
                          child: Hero(
                            tag: 'profileImage',
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(95, 95, 95, 0.1),
                                      spreadRadius: 0,
                                      blurRadius: 20,
                                      offset: Offset(0, 0),
                                    ),
                                  ]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: imgPicker.imageFile == null
                                    ? CustomNetWorkImage(url: profileUrl,assetName: 'assets/images/userPlaceHolder.png',)
                                    : Image.file(
                                        imgPicker.imageFile,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: ListView(
                              children: [
                                _textBox(
                                    hint: 'First Name',
                                    controller: firstNameController,
                                    enabled: true,
                                  keybordType: TextInputType.name
                                ),
                                _textBox(
                                    hint: 'Last Name',
                                    controller: lastNameController,
                                    enabled: true,
                                    keybordType: TextInputType.name
                                ),
                                _textBox(
                                    hint: 'Email',
                                    controller: emailController,
                                    enabled: false,
                                    keybordType: TextInputType.emailAddress
                                ),
                                _textBox(
                                    hint: 'Mobile No.',
                                    controller: mobileController,
                                    enabled: true,
                                    keybordType: TextInputType.number
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Private profile and locaiton',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Switch(
                                        activeColor: kPrimaryColor,
                                        value: _isProfilePrivate,
                                        onChanged: (bool) {
                                          setState(() {
                                            _isProfilePrivate = bool;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                if(_isProfilePrivate)
                                  _textBox(
                                      hint: 'Anonymous name',
                                      controller: privateNameController,
                                      enabled: true,
                                      keybordType: TextInputType.name
                                  ),

                              ],
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Container(
                            margin: EdgeInsets.all(20),
                            height: 44,
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: TextButton(
                              onPressed: () async {
                                if (isLoading) {
                                  return;
                                }

                                if (firstNameController.text.isEmpty) {
                                  CustomPopup(context,
                                      title: 'Validation',
                                      message:
                                          'First name should not be empty.',
                                      primaryBtnTxt: 'OK');
                                  return;
                                }

                                if (lastNameController.text.isEmpty) {
                                  CustomPopup(context,
                                      title: 'Validation',
                                      message: 'Last name should not be empty.',
                                      primaryBtnTxt: 'OK');
                                  return;
                                }

                                // if (mobileController.text.isEmpty) {
                                //   CustomPopup(context,
                                //       title: 'Validation',
                                //       message:
                                //       'mobile number should not be empty.',
                                //       primaryBtnTxt: 'OK');
                                //   return;
                                // }

                                if(mobileController.text.isNotEmpty){
                                  if (!mobileController.text.isValidMobile) {
                                    CustomPopup(context,
                                        title: 'Validation',
                                        message:
                                        'mobile number is not valid.',
                                        primaryBtnTxt: 'OK');
                                    return;
                                  }
                                }

                                if (_isProfilePrivate){
                                  if (privateNameController.text.isEmpty) {
                                    CustomPopup(context,
                                        title: 'Validation',
                                        message: 'Private name should not be empty.',
                                        primaryBtnTxt: 'OK');
                                    return;
                                  }
                                }

                                final userProvider =
                                    Provider.of<UserProfileProvider>(context,
                                        listen: false);

                                if (imgPicker.imageFile == null) {
                                  userProvider.updateProfile(
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      mobile: mobileController.text,
                                      isProfilePrivate: _isProfilePrivate,
                                      publicName: privateNameController.text ?? "Anonymous Name",
                                      completion: () {
                                        Navigator.of(context).pop();
                                      });
                                } else {

                                  // var img = await ImageService.getBytesFromAsset(imgPicker.imageFile.path, 150);
                                  //
                                  // final file = await new File(imgPicker.imageFile.path).create();
                                  // file.writeAsBytesSync(img);

                                  userProvider.updateProfile(
                                      filepath: imgPicker.imageFile.path,
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      mobile: mobileController.text,
                                      isProfilePrivate: _isProfilePrivate,
                                      publicName: privateNameController.text ?? "Anonymous Name",
                                      completion: () {
                                        Navigator.of(context).pop();
                                      });
                                }
                              },
                              child: Center(
                                child: isLoading
                                    ? Container(
                                        height: 30,
                                        width: 30,
                                        child: LoadingSmall())
                                    : Text(
                                        'UPDATE',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }

  Container _textBox(
      {String hint, TextEditingController controller, bool enabled,TextInputType keybordType}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextField(
        keyboardType: keybordType ?? TextInputType.text,
        autocorrect: false,
        controller: controller,
        enabled: enabled,
        decoration: kRoundedTextFieldDecoration.copyWith(hintText: hint),
      ),
    );
  }
}
