import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/model/emuns.dart';
import 'package:send_me_pic/app/providers/request_provider.dart';
import 'package:send_me_pic/app/screens/image_pageview_screen.dart';
import 'package:send_me_pic/app/screens/loading.dart';
import 'package:send_me_pic/app/screens/no_data_found.dart';
import 'package:send_me_pic/app/utilities/custom_popup.dart';
import 'package:send_me_pic/app/utilities/extensions.dart';
import 'package:send_me_pic/app/utilities/network_image.dart';
import 'package:send_me_pic/app/widgets/loading_small.dart';

class RequestDetailSentScreen extends StatefulWidget {
  @override
  _RequestDetailSentScreenState createState() => _RequestDetailSentScreenState();
}

class _RequestDetailSentScreenState extends State<RequestDetailSentScreen> {

  int selectedId = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<RequestProvider>(context, listen: false);

      selectedId = provider.selectedReceivedReqDetail;

      provider.fetchReceivedReqDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    final scrollOffset = _size.height * 0.4;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.black.withOpacity(0.03),
      //   foregroundColor: Colors.white,
      // ),
      backgroundColor: Colors.white,
      body: Consumer<RequestProvider>(
        builder: (_, provider, __) {

          final res = provider.receivedReqResDetails;

          switch(res.state){
            case Status.LOADING:
              return LoadingContainer();
              break;
            case Status.COMPLETED:
            // TODO: Handle this case.
              return buildObj();
              break;
            case Status.ERROR:
              return NoDataFoundContainer(reason: res.msg ?? "No Data found",tryAgainAction: (){
                provider.fetchReceivedReqDetails();
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

  Widget buildObj(){
    final size = MediaQuery.of(context).size;

    final provider = Provider.of<RequestProvider>(context, listen: false);
    final data = provider.receivedReqResDetails.data.data;
    final ImageStatus status = ImgStatus.getImgStatus(data.status);

    return CustomScrollView(
      slivers:[
        SliverAppBar(
          pinned: false,
          snap: true,
          floating: true,
          expandedHeight: size.height/2.5,
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          primary: true,
          flexibleSpace: Stack(
            children: [
              Positioned(
                bottom: 1,
                top: 0,
                right: 0,
                left: 0,
                child: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: GestureDetector(
                    onTap: (){
                      if(data.image != null){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImagePageViewScreen(images: [kImgBaseURL + data.image]),));
                      }
                    },
                    child: Container(
                      color: kPrimaryColor,
                      child: data.image == null ? Image.asset('assets/images/clear_placeholder.png',fit: BoxFit.cover,) :  CustomNetWorkImage(
                        url: kImgBaseURL + (data.image ?? '') ,assetName: 'assets/images/clear_placeholder.png',),
                    ),
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
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                  ),
                ),
              )
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: 0, left: 20, right: 20, bottom: 10),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                padding: EdgeInsets.all(2.5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: data.reciveUserData.badge.getStatusColor() ?? kPrimaryColor
                                ),
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(25),
                                    child: (data.reciveUserData.isPrivateProfile == 1) ? Image.asset('assets/images/userPlaceHolder.png') : CustomNetWorkImage(
                                        assetName: 'assets/images/userPlaceHolder.png',
                                        url: kImgBaseURL + (data.reciveUserData.userProfileImage ?? ""))),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (data.reciveUserData.isPrivateProfile == 1) ? (data.reciveUserData.publicName ?? "Anonymous User") : (data.reciveUserData.firstName ?? "") + " " + (data.reciveUserData.lastName ?? ""),
                                      maxLines: 1,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight:
                                          FontWeight.w600),
                                    ),
                                    Text(
                                      data.createdAt.formatDate(),
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(5),
                                        color: HexColor.fromHex(
                                            status.getStatusColor())
                                            .withOpacity(0.8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 10),
                                      child: Text(
                                        'Status : ${status.getString()}',
                                        style:
                                        TextStyle(fontSize: 12),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Consumer<RequestProvider>(
                                builder: (_, provider, __) {

                                  bool isLoading = false;

                                  switch(provider.deleteImageRes.state){
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

                                  return Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius:
                                        BorderRadius.circular(5)),
                                    child: TextButton(
                                      onPressed: () {
                                        CustomPopup(context, title: 'Cancel', message: 'Are you sure you want to delete this request ?', primaryBtnTxt: 'Yes',secondaryBtnTxt: 'No',primaryAction: (){
                                          provider.deleteImage(id: data.id,completion: (){
                                            Navigator.pop(context,true);
                                          });
                                        });
                                      },
                                      child: isLoading ? LoadingSmall(size: 15,) : Text('Delete',
                                        style: TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.black.withOpacity(0.3),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Request Description :',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(data.description ?? ''),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


