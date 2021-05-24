import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:send_me_pic/app/constants/constants.dart';
import 'package:send_me_pic/app/data/repository/image_req_repository.dart';
import 'package:send_me_pic/app/services/image_service.dart';
import 'package:send_me_pic/app/utilities/custom_popup.dart';
import 'package:send_me_pic/app/utilities/network_image.dart';
import 'package:http/http.dart' as http;
import 'package:send_me_pic/app/widgets/loading_small.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_share_file/flutter_share_file.dart';

class ImagePageViewScreen extends StatelessWidget {
  List<String> images = [];
  List<int> image_ids = [];

  int selectedIndex = 0;

  bool isForDelete = false;

  ImagePageViewScreen({@required this.images, this.selectedIndex, this.isForDelete, this.image_ids});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: _ImageGallery(
          imageUrls: images,
         selectedIndex: selectedIndex,
        isForDelete: isForDelete,
        image_ids: image_ids,
      ),
    );
  }
}

class _ImageGallery extends StatefulWidget {
  final List<String> imageUrls;
  int selectedIndex = 0;
  List<int> image_ids = [];
  final bool isForDelete;
  _ImageGallery({this.imageUrls,List<TransformationController> imgControllers, this.selectedIndex, bool isForDelete, this.image_ids}) : imgControllers = imgControllers ?? imageUrls.map((e) => TransformationController()).toList(), isForDelete = isForDelete ?? false;

  final List<TransformationController> imgControllers;

  @override
  __ImageGalleryState createState() => __ImageGalleryState();
}

class __ImageGalleryState extends State<_ImageGallery> {
  var initialControllerValue;
  bool isDownloadImgLoading = false;

  bool isShareImgLoading = false;

  bool isDeleteLoading = false;

  var progress = 0.0;

  static GlobalKey _globalKey = GlobalKey();

  @override
  void initState(){
    super.initState();
    if(Platform.isAndroid){
      initiateDownloader();
    }
  }

  Future deleteImage(int id) async {
    setState(() {
      isDeleteLoading = true;
    });
    try{
      final res = await ImageRequestRepository().deleteImage(id);

      if(res.status != 1){
        throw res.message;
      }
      print(id);
      setState(() {
        isDeleteLoading = false;
      });
      Navigator.pop(context,true);

    }catch(e){
      setState(() {
        isDeleteLoading = false;
      });
      CustomPopup(context, title: 'Sorry', message: '$e', primaryBtnTxt: 'OK');
    }
  }

  initiateDownloader() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(debug: true);
  }

  Future<bool> _checkPermission() async {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }

    return false;
  }

  _shareImage(String url) async {
    print('Loading..');
    try {
      setState(() {
        isShareImgLoading = true;
      });
      final _uri = Uri.parse(url);//Uri.parse('https://tinyjpg.com/images/social/website.jpg');//

      final fileName = url.split('/').last;

      if (Platform.isAndroid) {
        final RenderBox box = context.findRenderObject();
        var response = await http.get(_uri);
        final documentDirectory = (await getExternalStorageDirectory()).path;
        File imgFile = new File('$documentDirectory/${fileName ?? "flutter"}');
        imgFile.writeAsBytesSync(response.bodyBytes);
        Share.shareFiles(['$documentDirectory/${fileName ?? "flutter"}'],
            subject: 'Send Me Pic',
            text: 'Download from: ' + kApplicationUrl,
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
        setState(() {
          isShareImgLoading = false;
        });
      }else if(Platform.isIOS){
        try{
          // var response = await http.readBytes(_uri);
          // final tempDir = await getTemporaryDirectory();
          // final file = await new File('${tempDir.path}/${fileName ?? "flutter"}').create();
          // file.writeAsBytesSync(response);
          // print(file.path);

          // Directory dir = await getApplicationDocumentsDirectory();
          // File testFile = new File("${dir.path}/image.png");
          // FlutterShareFile.share('${tempDir.path}', '${fileName ?? "flutter"}', ShareFileType.image);
          
          // final channel = const MethodChannel('channel:me.albie.share/share');
          // channel.invokeMethod('shareFile', '${fileName ?? "flutter"}');

          //New way

          final request = http.Request('GET',_uri);

          final http.StreamedResponse response = await http.Client().send(request);

          final contentLength = response.contentLength;

          List<int> bytes = [];

          response.stream.listen(
                (List<int> newBytes) {
              // update progress
              bytes.addAll(newBytes);
            },
            onDone: () async {

              final image = await ImageService.getBytesFromServerImage(Uint8List.fromList(bytes), 1200);

              final channel = const MethodChannel('channel:me.albie.share/share');
              channel.invokeMethod('shareImageData', image);

              setState(() {
                isShareImgLoading = false;
              });

            },
            onError: (e) {
              setState(() {
                isShareImgLoading = false;
              });
              CustomPopup(context, title: 'Sorry', message: '$e', primaryBtnTxt: 'Done');
            },
            cancelOnError: true,
          );
        }catch(e){
          CustomPopup(context, title: 'Sorry', message: 'Image not found', primaryBtnTxt: 'OK');
          setState(() {
            isShareImgLoading = false;
          });
        }
      }

    } catch (e) {
      setState(() {
        isShareImgLoading = false;
      });
      print('Share error: $e');
    }
  }

  Future<bool> saveFileAndroid(String url,String fileName) async{

    Directory dir;

    final Dio dio = Dio();

    try{
      if(Platform.isAndroid){

        if(await _requestPermission(Permission.storage)){
          dir = await getExternalStorageDirectory();
          print(dir.path);

          String newPath = '';

          List<String> folders = dir.path.split('/');

          for(int x = 1; x < folders.length; x++){
            String folder = folders[x];
            if(folder != 'Android'){
              newPath += "/" + folder;
            }else{
              break;
            }
          }

          // newPath = newPath + '/DCIM';
          newPath = newPath + '/Download';
          dir = Directory(newPath);
          print(dir.path);

        }else{
          return false;
        }

      }else{

      }

      if(!await dir.exists()){
        await dir.create(recursive: true);
      }

      if(await dir.exists()){

        File saveFile = File(dir.path + "/$fileName");

        print(saveFile.path);

        await dio.download(url, saveFile.path,onReceiveProgress: (size,totalSize){
          setState(() {
            print(totalSize/size);
            progress = totalSize/size;
          });
        });

        return true;

      }

    }catch(e){
      print(e);
      return false;
    }
    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {

    if(await permission.isGranted){
      return true;
    } else {
      var result = await permission.request();

      if(result == PermissionStatus.granted){
        return true;
      }else{
        return false;
      }
    }
  }

  saveImage(String url) async {

    print(url);

    if(Platform.isAndroid){

      // final res = await _checkPermission();
      //
      // if(res){
      //   String localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';
      //   final savedDir = Directory(localPath);
      //   bool hasExisted = await savedDir.exists();
      //   if (!hasExisted) {
      //     savedDir.create();
      //   }
      //   print('cool');
      //   // savedDir.path
      //   final taskId = await FlutterDownloader.enqueue(
      //     url: url,
      //     savedDir: localPath,
      //     showNotification: true, // show download progress in status bar (for Android)
      //     openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      //   );
      //   CustomPopup(context, title: 'Download', message: 'Image Downloading!!', primaryBtnTxt: 'Done');
      // }else{
      //   CustomPopup(context, title: 'Permission', message: 'Please Grant Permission to download image', primaryBtnTxt: 'OK');
      // }

      setState(() {
        isDownloadImgLoading = true;
      });

      final fileName = url.split('/').last;

      bool isDownloaded = await saveFileAndroid(url, fileName ?? 'flutterImg.png');

      if(isDownloaded){
        CustomPopup(context, title: 'Complete', message: 'Image saved in downloads folder', primaryBtnTxt: 'Done');
      }else{
        CustomPopup(context, title: 'Sorry', message: 'Something Went Wrong', primaryBtnTxt: 'Done');
      }

      setState(() {
        isDownloadImgLoading = false;
      });

    }else{
      final _uri = Uri.parse(url);
      final fileName = url.split('/').last;

      setState(() {
        isDownloadImgLoading = true;
      });

      try{

        final request = http.Request('GET',_uri);

        final http.StreamedResponse response = await http.Client().send(request);

        final contentLength = response.contentLength;

        List<int> bytes = [];

        response.stream.listen(
              (List<int> newBytes) {
            // update progress
            bytes.addAll(newBytes);
            final downloadedLength = bytes.length;
            setState(() {
              progress = downloadedLength / contentLength;
            });
            print(progress);
          },
          onDone: () async {
            CustomPopup(context, title: 'Complete', message: 'Image Saved SuccessFully!!', primaryBtnTxt: 'Done');
            setState(() {
              progress = 0.0;
              isDownloadImgLoading = false;
            });

            final result = await ImageGallerySaver.saveImage(
                Uint8List.fromList(bytes),
                quality: 60,
                name: fileName ?? 'Flutter.png');

            print(result);

          },
          onError: (e) {
            CustomPopup(context, title: 'Sorry', message: '$e', primaryBtnTxt: 'Done');
          },
          cancelOnError: true,
        );

      }catch(e){
        print(e);
        CustomPopup(context, title: 'Sorry', message: '$e', primaryBtnTxt: 'OK');
        setState(() {
          isDownloadImgLoading = false;
        });
      }
    }
  }

  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      key: _globalKey,
      controller: PageController(initialPage: widget.selectedIndex ?? 0),
      itemCount: widget.imageUrls.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: InteractiveViewer(
                panEnabled: false,
                transformationController: widget.imgControllers[index],
                  onInteractionStart: (details){
                    initialControllerValue = widget.imgControllers[index].value;
                  },
                onInteractionEnd: (func){

                  widget.imgControllers[index].value = initialControllerValue;
                },
                boundaryMargin: EdgeInsets.all(80),
                minScale: 1,
                maxScale: 4,
                child: CustomNetWorkImage(url: widget.imageUrls[index],fit: BoxFit.fitWidth,assetName: 'assets/images/clear_placeholder.png',)
              ),
            ),
            Positioned(
              bottom: 70,left: 0,right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: kPinkBTNColor
                    ),
                    child: isDownloadImgLoading ? ProgressSmall(color: Colors.white,progress: progress,) : TextButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith((states) => Colors.red.withOpacity(0.5)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35),
                                )
                            )),
                      onPressed: (){
                        saveImage(widget.imageUrls[index]);
                      },
                      child: Icon(Icons.download_outlined,color: Colors.white,),
                    ),
                  ),

                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: kPrimaryColor
                    ),
                    child: isShareImgLoading ? LoadingSmall() : TextButton(
                      style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(0.5)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),

                              )
                          )),
                      onPressed: (){
                        print('Sharing');
                        _shareImage(widget.imageUrls[index]);
                      },
                      child: Icon(Icons.share_outlined,color: Colors.white,),
                    ),
                  ),
                  if(widget.isForDelete)
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.black
                      ),
                      child: isDeleteLoading ? LoadingSmall() : TextButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(0.5)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35),

                                )
                            )),
                        onPressed: (){
                          if(index < widget.image_ids.length){
                            CustomPopup(context, title: 'Are You sure', message: 'You want to delete this image?', primaryBtnTxt: 'Yes',secondaryBtnTxt: 'No',primaryAction: (){
                              deleteImage(widget.image_ids[index]);
                            });
                          }
                        },
                        child: Icon(Icons.delete,color: Colors.white,),
                      ),
                    ),

                ],
              ),
            )
          ],
        );
      },
    );
  }
}
