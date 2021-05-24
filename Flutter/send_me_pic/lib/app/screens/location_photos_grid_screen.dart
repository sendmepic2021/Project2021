import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/model/emuns.dart';
import 'package:send_me_pic/app/providers/home_provider.dart';
import 'package:send_me_pic/app/screens/image_pageview_screen.dart';
import 'package:send_me_pic/app/screens/no_data_found.dart';
import 'package:send_me_pic/app/utilities/extensions.dart';
import 'package:send_me_pic/app/widgets/image_grid_widget.dart';
import 'package:send_me_pic/app/widgets/loading_small.dart';

class LocationPhotosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    try{
      final res = provider.res.data.data.imageGroup[provider.selectedPlaceIndex];

      return Scaffold(
        appBar: AppBar(
          title: Text(res.first.imagePlaceName),
        ),
        body: res.length <= 0
            ? NoDataFoundSimple(
          text: 'No Data Found',
        )
            : Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.88),
              itemCount: res.length,
              itemBuilder: (context, index) {
                final data = res[index];

                return ImageGridWidget(
                  userBadge: data.reciveUserData.badge,
                  type: ImageWidgetType.locationProfile,
                  imageURL: kImgBaseURL + (data.image ?? ""),
                  userURL: (data.reciveUserData.isPrivateProfile == 1) ? "" : kImgBaseURL + (data.reciveUserData.userProfileImage ?? ""),
                  userName: (data.reciveUserData.isPrivateProfile == 1) ? (data.reciveUserData.publicName ?? "") :(data.reciveUserData.firstName ?? "") + ' ' + (data.reciveUserData.lastName ?? ""),
                  date: data.createdAt.formatDate(),
                  status: 'Status : Pending',
                  statusColor: '#FFDE6D',
                  onTap: () {
                    // Navigator.of(context).pushNamed(kRequestedImageRoute);

                    if(data.image == null && data.image.isEmpty){
                      return;
                    }

                    Navigator.push(context, MaterialPageRoute(builder: (context) => ImagePageViewScreen(images: [kImgBaseURL + (data.image ?? "")],),));

                  },
                );
              }),
        ),
      );
    }catch(e){
      return Container(
        color: Colors.white,
        child: Center(
          child: LoadingSmall(),
        ),
      );
    }

  }
}
