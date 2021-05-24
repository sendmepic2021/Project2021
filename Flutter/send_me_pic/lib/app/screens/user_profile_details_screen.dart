import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/data/model/res/place_images_entity.dart';
import 'package:send_me_pic/app/data/model/res/user_res_entity.dart';
import 'package:send_me_pic/app/model/emuns.dart';
import 'package:send_me_pic/app/model/user_pref.dart';
import 'package:send_me_pic/app/providers/user_profile_provider.dart';
import 'package:send_me_pic/app/screens/image_pageview_screen.dart';
import 'package:send_me_pic/app/screens/loading.dart';
import 'package:send_me_pic/app/screens/no_data_found.dart';
import 'package:send_me_pic/app/utilities/network_image.dart';

class UserProfileDetailsScreen extends StatefulWidget {
  @override
  _UserProfileDetailsScreenState createState() =>
      _UserProfileDetailsScreenState();
}

class _UserProfileDetailsScreenState extends State<UserProfileDetailsScreen> {
  String profileUrl =
      'https://st4.depositphotos.com/4329009/19956/v/600/depositphotos_199564354-stock-illustration-creative-vector-illustration-default-avatar.jpg';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<UserProfileProvider>(context, listen: false);

      provider.fetchUser();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kSignInBGColor,
      body: Consumer<UserProfileProvider>(
        builder: (_, provider, __) {
          var user = provider.user;

          switch (user.state) {
            case Status.LOADING:
              return LoadingContainer();
              break;
            case Status.COMPLETED:
              var userData = user.data;
              if (userData.status == 1) {
                return buildObj(
                    data: userData.data); //buildStack(data: userData.data);
              } else {
                return NoDataFoundContainer(
                    reason: provider.user.msg,
                    tryAgainAction: () {
                      provider.fetchUser();
                    });
              }
              break;
            case Status.ERROR:
              return Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                ),
                body: NoDataFoundContainer(
                    reason: provider.user.msg,
                    tryAgainAction: () {
                      provider.fetchUser();
                    }),
              );
              break;
          }

          return Container();
        },
      ),
    );
  }

  Widget buildObj({UserResData data}) {
    final badge = UserStatus.getBadgeStatus(data.level_id ?? 0);
    _getImgUrl();
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            snap: true,
            floating: true,
            expandedHeight: 320,
            title: Text('Profile'),
            backgroundColor: kSignInBGColor,
            elevation: 0,
            actions: [
              IconButton(
                  icon: Icon(Icons.edit_outlined),
                  onPressed: () {
                    Navigator.of(context).pushNamed(kUpdateProfileRoute);
                  })
            ],
            primary: true,
            flexibleSpace: Stack(
              children: [
                FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Container(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child:
                          Image.asset('assets/images/send_me_bg_opeque.png',fit: BoxFit.fitHeight,),
                              // Image.asset('assets/images/send_me_bg_blur.png',fit: BoxFit.fitHeight,),
                        ),
                        Positioned(
                            top: 130,
                            bottom: 50,
                            left: 20,
                            right: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black.withOpacity(0.1),
                              ),
                            )),
                        Positioned(
                          top: 90,
                          left: 30,
                          right: 30,
                          bottom: 50,
                          child: Container(
                            child: Column(
                              children: [
                                Hero(
                                  tag: 'profileImage',
                                  child: Container(
                                    height: 90,
                                    width: 90,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: badge.getStatusColor(),//Colors.white,
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
                                        borderRadius: BorderRadius.circular(50),
                                        child: CustomNetWorkImage(
                                            assetName: 'assets/images/userPlaceHolder.png',
                                            url: profileUrl)),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  (data.firstName ?? "") +
                                      " " +
                                      (data.lastName ?? ""),
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width:size.width/5,
                                      child: Column(
                                        children: [
                                          FittedBox(
                                            child: Text(
                                                (data.profileTotal ?? 0)
                                                    .toString(),
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
                                      width:size.width/5,
                                      child: Column(
                                        children: [
                                          FittedBox(
                                            child: Text(
                                                (data.profileRecived ?? 0)
                                                    .toString(),
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
                                      width:size.width/5,
                                      child: Column(
                                        children: [
                                          FittedBox(
                                            child: Text(
                                                (data.profileCompleted ?? 0)
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25)),
                                          ),
                                          FittedBox(
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
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  // alignment: Alignment.bottomCenter,
                  bottom: -20,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                  ),
                )
              ],
            ),
          ),
          SliverImageGridView(
            images: data.image,
          )
        ],
      ),
    );
  }
}

class SliverImageGridView extends StatelessWidget {
  final List<dynamic> images;

  const SliverImageGridView({Key key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return images.length <= 0
        ? SliverToBoxAdapter(
            child: Container(
                child: NoDataFoundSimple(
              text: 'No Images Found',
            )),
          )
        : SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 0.8),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                PlaceImagesEntity imageObj =
                    PlaceImagesEntity().fromJson(images[index]);

                return Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      if (imageObj.image != null) {
                        List<PlaceImagesEntity> obj = images
                            .map((e) => PlaceImagesEntity().fromJson(e))
                            .toList();

                        final allImgs =
                            obj.map((e) => kImgBaseURL + e.image).toList();

                        final allIds = obj.map((e) => e.id).toList();

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ImagePageViewScreen(
                            images: allImgs,
                            selectedIndex: index,
                            isForDelete: true,
                            image_ids: allIds,
                          ),
                        )).then((value) {
                          if(value != null && value == true){
                            final provider = Provider.of<UserProfileProvider>(context, listen: false);

                            provider.fetchUser();
                          }
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: Colors.grey[300])),
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CustomNetWorkImage(
                                url: kImgBaseURL + (imageObj.image ?? ''))),
                      ),
                    ),
                  ),
                );
              },
              childCount: images.length,
            ),
          );
  }
}
