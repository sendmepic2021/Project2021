import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/data/model/res/LatLongDashBordRes.dart';
import 'package:send_me_pic/app/model/emuns.dart';
import 'package:send_me_pic/app/providers/home_provider.dart';
import 'package:send_me_pic/app/screens/enter_description_screen.dart';
import 'package:send_me_pic/app/screens/no_data_found.dart';
import 'package:send_me_pic/app/utilities/custom_popup.dart';
import 'package:send_me_pic/app/utilities/network_image.dart';
import 'package:send_me_pic/app/widgets/loading_small.dart';

class SearchListScreen extends StatefulWidget {
  @override
  _SearchListScreenState createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<HomeProvider>(context, listen: false);

      provider.getResponse(
          searchText: '',
          completion: (res, status) {
            CustomPopup(context,
                title: 'Error', message: res.msg, primaryBtnTxt: 'OK');
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    bool isSearched = false;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(35),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              height: 35,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                  borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: TabBar(
                  labelStyle: TextStyle(color: kPrimaryColor),
                  unselectedLabelColor: kPrimaryColor,
                  labelColor: Colors.white,
                  indicator: BoxDecoration(color: kPrimaryColor),
                  tabs: [
                    Tab(
                      text: 'User List',
                    ),
                    Tab(
                      text: 'Location Pictures',
                    )
                  ],
                ),
              ),
            ),
          ),
          title: Text('Search List'),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 15, bottom: 10),
          child: Column(
            children: [
              //SearchBar
              Container(
                // height: 45,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[200]),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(95, 95, 95, 0.1),
                        spreadRadius: 10,
                        blurRadius: 30,
                        offset: Offset(0, 0),
                      ),
                    ]),
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: TextField(
                  style: TextStyle(color: kPrimaryColor, fontSize: 15),
                  onSubmitted: (text) {
                    if (text.isNotEmpty) {
                      isSearched = true;
                      homeProvider.getResponse(
                          isLoading: true,
                          searchText: text,
                          completion: (res, status) {});
                    }
                  },
                  onChanged: (text) {
                    // if(text.length > 2){
                    //   homeProvider.getResponse(isLoading: false,searchText: text,completion: (res,status){
                    //     // CustomPopup(context, title: 'Error', message: res.msg, primaryBtnTxt: 'OK');
                    //   });
                    // }

                    if (text.length == 0 && isSearched) {
                      isSearched = false;
                      homeProvider.getResponse(
                          isLoading: true,
                          searchText: text,
                          completion: (res, status) {
                            // CustomPopup(context, title: 'Error', message: res.msg, primaryBtnTxt: 'OK');
                          });
                    }
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Search here...",
                    hintStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Expanded(
                child: TabBarView(
                  children: [
                    _UserList(
                      scaffoldKey: _scaffoldKey,
                    ),
                    _LocationList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  _UserList({this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Consumer<HomeProvider>(
            builder: (_, provider, __) {
              try {
                bool isLoading = false;
                final userData = provider.res.data.data.userList;
                if (provider.res.state == Status.LOADING) {
                  isLoading = true;
                } else {
                  isLoading = false;
                }

                return (userData.length <= 0)
                    ? Container()
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 40,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () {
                            print(provider.requestUser);
                            // CustomPopup(context,title: 'Send Request',message: 'This action will allow you to send your request to all the listed users, \n Do you want to send?',primaryBtnTxt: 'YES',secondaryBtnTxt: 'NO');

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) {
                                      return EnterDescriptionScreen(
                                        updateAction: (text) {
                                          if (isLoading) {
                                            return;
                                          }
                                          provider.sendReqToAll(text, (apiRes) {
                                            if (apiRes.state ==
                                                Status.COMPLETED) {
                                              CustomPopup(
                                                  scaffoldKey.currentContext,
                                                  title: 'Success',
                                                  message:
                                                      'Request Sent Successfully',
                                                  primaryBtnTxt: 'OK',
                                                  primaryAction: () {
                                                Navigator.of(scaffoldKey
                                                        .currentContext)
                                                    .pop();
                                              });
                                            } else {
                                              CustomPopup(
                                                  scaffoldKey.currentContext,
                                                  title: 'Error',
                                                  message: apiRes.msg,
                                                  primaryBtnTxt: 'OK');
                                            }
                                          });
                                        },
                                      );
                                    },
                                    fullscreenDialog: true));
                          },
                          child: isLoading
                              ? Container(
                                  height: 22,
                                  width: 22,
                                  child: LoadingSmall(),
                                )
                              : Text(
                                  'Send Request To All',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      );
              } catch (e) {
                return Container();
              }
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Consumer<HomeProvider>(
          builder: (_, provider, __) {
            try {
              final userData = provider.res.data.data.userList;

              return Expanded(
                child: userData.length <= 0
                    ? NoDataFoundSimple(
                        text: 'No Users Found',
                      )
                    : Scrollbar(
                        child: ListView.builder(
                          itemCount: userData.length,
                          itemBuilder: (context, index) {
                            final res = userData[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 15, top: 0),
                              child: ListTile(
                                title: _buildContainer(res),
                                onTap: () {
                                  // final userProvider = Provider.of<UserProfileProvider>(context,listen: false);
                                  // userProvider.fetchSpecificUser(res.id);
                                  provider.selectedUserFromMarker = res.id;
                                  Navigator.of(context)
                                      .pushNamed(kOtherUserProfileRoute);
                                },
                              ),
                            );
                          },
                        ),
                      ),
              );
            } catch (e) {
              return Expanded(
                  child: Center(
                child: Container(
                  height: 30,
                  width: 30,
                  child: LoadingSmall(
                    color: kPrimaryColor,
                  ),
                ),
              ));
            }
          },
        ),
      ],
    );
  }

  Widget _buildContainer(UserList user) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: user.badge.getStatusColor(),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                        child: (user.isPrivateProfile == 1) ? Image.asset('assets/images/userPlaceHolder.png') : CustomNetWorkImage(
                          assetName: 'assets/images/userPlaceHolder.png',
                            url: kImgBaseURL + (user.userProfileImage ?? ""))),
                  )),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (user.isPrivateProfile == 1)
                          ? (user.publicName ?? "Anonymous")
                          : (user.firstName ?? "") +
                              " " +
                              (user.lastName ?? ""),
                      maxLines: 1,
                      softWrap: true,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                        ),
                        Flexible(
                          child: Text(
                            (user.isPrivateProfile == 1)
                                ? 'Is Private'
                                : (user.palaceName ?? "Address"),
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 1,
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
    );
  }
}

class _LocationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (_, provider, __) {
        try {
          final imgData = provider.res.data.data.imageGroup;

          return imgData.length <= 0
              ? NoDataFoundSimple(text: 'No Images Found')
              : Scrollbar(
                  child: ListView.builder(
                    itemCount: imgData.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 15, top: 0),
                        child: ListTile(
                          title: _buildContainer(imgData[index]),
                          onTap: () {
                            provider.selectedPlaceIndex = index;
                            Navigator.pushNamed(
                                context, kLocationProfileGridRoute);
                          },
                        ),
                      );
                    },
                  ),
                );
        } catch (e) {
          return Expanded(
              child: Center(
            child: Container(
              height: 30,
              width: 30,
              child: LoadingSmall(
                color: kPrimaryColor,
              ),
            ),
          ));
        }
      },
    );
  }

  Widget _buildContainer(List<ImageGroup> data) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CustomNetWorkImage(
                        url: kImgBaseURL + (data.first.image ?? ""))),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  data.first.imagePlaceName ?? "Near by Place",
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 1,
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
    );
  }
}
