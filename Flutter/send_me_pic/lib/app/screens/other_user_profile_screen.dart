import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/data/model/res/place_images_entity.dart';
import 'package:send_me_pic/app/model/emuns.dart';
import 'package:send_me_pic/app/providers/home_provider.dart';
import 'package:send_me_pic/app/providers/user_profile_provider.dart';
import 'package:send_me_pic/app/screens/enter_description_screen.dart';
import 'package:send_me_pic/app/screens/image_pageview_screen.dart';
import 'package:send_me_pic/app/screens/loading.dart';
import 'package:send_me_pic/app/screens/no_data_found.dart';
import 'package:send_me_pic/app/utilities/custom_popup.dart';
import 'package:send_me_pic/app/utilities/network_image.dart';
import 'package:send_me_pic/app/widgets/loading_small.dart';

class OtherUserProfileScreen extends StatefulWidget {
  @override
  _OtherUserProfileScreenState createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {

  int selectedId;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);

      selectedId = homeProvider.selectedUserFromMarker;

      final userProvider =
          Provider.of<UserProfileProvider>(context, listen: false);

      userProvider.fetchSpecificUser(selectedId);
    });
  }

  @override
  Widget build(BuildContext context) {

    final _size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: kSignInBGColor,
      body: Consumer<UserProfileProvider>(
        builder: (_, provider, __) {
          final user = provider.otherUser;

          switch (user.state) {
            case Status.LOADING:
              return LoadingContainer();
              break;
            case Status.COMPLETED:
              return buildStack(_size, context);
              break;
            case Status.ERROR:
              return NoDataFoundContainer(reason: user.msg,tryAgainAction: (){
                provider.fetchSpecificUser(selectedId);
              },);
              break;
          }

          return Container(
            color: Colors.white,
          );
        },
      ),
    );
  }

  Widget buildStack(Size _size, BuildContext context) {
    final userProvider = Provider.of<UserProfileProvider>(context);

    final userData = userProvider.otherUser.data;
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
          child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Stack(
                        children: [
                          Positioned(
                              top: (_size.height / 10) / 2,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              )),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  height: _size.height / 8,
                                  width: _size.height / 8,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          (_size.height / 8) / 2),
                                      color: userData.data.badge.getStatusColor(), //Colors.white,
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Color.fromRGBO(
                                      //         95, 95, 95, 0.15),
                                      //     spreadRadius: 0,
                                      //     blurRadius: 10,
                                      //     offset: Offset(0, 0),
                                      //   ),
                                      // ]
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          (_size.height / 8) / 2),
                                      child: (userData.data.isPrivateProfile == 1) ? Image.asset('assets/images/userPlaceHolder.png') : CustomNetWorkImage(
                                        assetName: 'assets/images/userPlaceHolder.png',
                                        url: kImgBaseURL + (userData.data.userProfileImage ?? ""),
                                      )),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  (userData.data.isPrivateProfile == 1) ? (userData.data.publicName ?? "Anonymous User") : (userData.data.firstName ?? "") + ' ' + (userData.data.lastName ?? ""),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: _size.width/5,
                                      child: Column(
                                        children: [
                                          FittedBox(
                                            child: Text((userData.data.profileTotal ?? 0).toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25)),
                                          ),
                                          FittedBox(
                                            child: Text(
                                              'Total',
                                              style: TextStyle(fontSize: 16),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: _size.width/5,
                                      child: Column(
                                        children: [
                                          FittedBox(
                                            child: Text((userData.data.profileRecived ?? 0).toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25)),
                                          ),
                                          FittedBox(
                                            child: Text(
                                              'Received',
                                              style: TextStyle(fontSize: 16),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: _size.width/5,
                                      child: Column(
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text((userData.data.profileCompleted ?? 0).toString(),
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25)),
                                          ),
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              'Completed',
                                              style: TextStyle(fontSize: 16),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ]))
                ];
              },
              body: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: Colors.white),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: 20, left: 20, right: 20, bottom: 10),
                            child: Text(
                              'Location',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: _ImagesGrid(images: userData.data.image ?? "",),
                          )),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 44,
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Consumer<UserProfileProvider>(
                            builder: (_, provider, __) {

                              final res = provider.imageReq;

                              bool isLoading = false;

                              switch(res.state){
                                case Status.LOADING:
                                  isLoading = true;
                                  break;
                                case Status.COMPLETED:
                                  print('message is: ' + res.data.message ?? "");
                                  isLoading = false;
                                  break;
                                case Status.ERROR:
                                  isLoading = false;
                                  break;
                              }

                              return isLoading ? Container(
                                child: Center(
                                  child: Container(
                                    height: 22,width: 22,
                                      child: LoadingSmall()),
                                ),
                              )
                                  : TextButton(
                                  onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) {
                                          return EnterDescriptionScreen(
                                            updateAction: (text) {
                                              print(text);
                                              provider.sendRequest(selectedId, text,(apiRes){

                                                if(apiRes.state == Status.COMPLETED){
                                                  CustomPopup(_scaffoldKey.currentContext, title: 'Success', message: 'Request Sent Successfully', primaryBtnTxt: 'OK',primaryAction: (){
                                                    Navigator.of(_scaffoldKey.currentContext).pop();
                                                  });
                                                }else{
                                                  CustomPopup(_scaffoldKey.currentContext, title: 'Error', message: apiRes.msg, primaryBtnTxt: 'OK');
                                                }
                                              });
                                            },
                                          );
                                        },
                                        fullscreenDialog: true));
                              },
                              child: Center(
                              child: Text(
                              'REQUEST',
                              style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                              ),
                              ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ))),
        )
      ],
    );
  }
}

class _ImagesGrid extends StatelessWidget {

  final List<dynamic> images;

  const _ImagesGrid({Key key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return images.length <= 0 ? NoDataFoundSimple(text: 'No Images Found',) :
    GridView.builder(
      padding: EdgeInsets.only(bottom: 100),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.8),
        itemCount: images.length,
        itemBuilder: (context, index) {

          PlaceImagesEntity imageObj = PlaceImagesEntity().fromJson(images[index]);

          return Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            child: InkWell(
              splashColor: kPrimaryColor,
              borderRadius: BorderRadius.circular(10),
              onTap: (){
                if(imageObj.image != null){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImagePageViewScreen(images: [kImgBaseURL + imageObj.image]),));
                }
              },
              child: Container(
                  margin: EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: Colors.grey[300])),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomNetWorkImage(url: kImgBaseURL + (imageObj.image ?? ''))
                  )
              ),
            ),
          );
        });
  }
}
