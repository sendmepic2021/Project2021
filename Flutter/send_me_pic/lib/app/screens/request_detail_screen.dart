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
import 'package:send_me_pic/app/services/image_picker_service.dart';
import 'package:send_me_pic/app/services/location_service.dart';
import 'package:send_me_pic/app/utilities/custom_popup.dart';
import 'package:send_me_pic/app/utilities/extensions.dart';
import 'package:send_me_pic/app/utilities/network_image.dart';
import 'package:send_me_pic/app/widgets/loading_small.dart';

class RequestDetailScreen extends StatefulWidget {
  @override
  _RequestDetailScreenState createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {

  int selectedId = 0;

  PickImage imgPicker;

  @override
  void initState() {
    super.initState();
    imgPicker = PickImage(
        context: context,
        updateFile: () async {
          try{
            print('cool');
            final provider = Provider.of<RequestProvider>(context, listen: false);

            if(imgPicker.imageFile != null){
              provider.pickedImage = imgPicker.imageFile;

              Navigator.pushNamed(context, kImageSelectionRoute);
            }

            // final loc = await LocationService.getLocation();
            // print('loc for image');
            // print(loc);

          }catch(e){
            print("Exception:");
            print(e);
          }
        });
    imgPicker.maxWidth = 500;
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
              return Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(backgroundColor: Colors.transparent,),
                body: NoDataFoundContainer(reason: res.msg ?? "",tryAgainAction: (){
                  provider.fetchReceivedReqDetails();
                },),
              );
              break;
          }

          return Container();
        },
      ),
    );
  }

  Widget buildObj(){
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<RequestProvider>(context, listen: false);
    final data = provider.receivedReqResDetails.data.data;
    final ImageStatus status = ImgStatus.getImgStatus(data.status ?? "");

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
               top: 0,
               left: 0,
               right: 0,
               bottom: 1,
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
                     child:
                     data.image != null ?
                   CustomNetWorkImage( url:kImgBaseURL + (data.image ?? ""),assetName: 'assets/images/clear_placeholder.png',)
                         :
                         Image.asset('assets/images/clear_placeholder.png',fit: BoxFit.cover,)

                   ),
                 ),
               ),
             ),
             Positioned(
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
                         child: Text(
                           'Request By :',
                           style: TextStyle(
                               color: kPrimaryColor,
                               fontSize: 16,
                               fontWeight: FontWeight.w600),
                         ),
                       ),
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
                                   color: data.senderUserData.badge.getStatusColor() ?? kPrimaryColor
                               ),
                               child: ClipRRect(
                                   borderRadius:
                                   BorderRadius.circular(25),
                                   child: (data.senderUserData.isPrivateProfile == 1) ? Image.asset('assets/images/userPlaceHolder.png') : CustomNetWorkImage(
                                       assetName: 'assets/images/userPlaceHolder.png',
                                       url: kImgBaseURL + (data.senderUserData.userProfileImage ?? ""))
                               ),
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
                                     (data.senderUserData.isPrivateProfile == 1) ? (data.senderUserData.publicName ?? "Anonymous User") : (data.senderUserData.firstName ?? "") + " " + (data.senderUserData.lastName ?? ""),
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
                             if(status == ImageStatus.Confirm || status == ImageStatus.Pending)
                               Consumer<RequestProvider>(
                                 builder: (_, provider, __) {

                                   final res = provider.updateStatusRes;
                                   bool isLoading = false;
                                   switch(res.state){
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
                                         if(status == ImageStatus.Confirm){
                                           imgPicker.selectImageFromCamera();
                                           // imgPicker.selectImage();
                                         }else{
                                           CustomPopup(context,
                                               title: 'Please Select One',
                                               message:
                                               'Do you want to accept image request ?',
                                               primaryBtnTxt: 'Accept',
                                               secondaryBtnTxt: 'Reject',primaryAction: (){
                                                 provider.requestStatus(selectedId, ImageStatus.Confirm.getId());
                                               },secondaryAction: (){
                                                 provider.requestStatus(selectedId, ImageStatus.Rejected.getId());
                                               });
                                         }
                                       },
                                       child: isLoading ? Container(
                                         height: 22,
                                         width: 22,
                                         child: LoadingSmall(),
                                       ) :  Text(
                                         status == ImageStatus.Confirm ? 'Pick Image' : 'Accept',
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

