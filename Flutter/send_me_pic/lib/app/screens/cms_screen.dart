import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send_me_pic/app/base/api_base_helper.dart';
import 'package:send_me_pic/app/providers/settings_provider.dart';
import 'package:send_me_pic/app/screens/loading.dart';
import 'package:send_me_pic/app/screens/no_data_found.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CMSScreen extends StatefulWidget {

  CMSScreen({@required this.type});

  final CMSType type;

  @override
  _CMSScreenState createState() => _CMSScreenState();
}

class _CMSScreenState extends State<CMSScreen> {
  String get screenTitle {
    switch(widget.type){
      case CMSType.privacyPolicy:
        return 'Privacy Policy';
      case CMSType.terms:
        return 'Terms & Conditions';
      case CMSType.aboutUs:
        return 'About Us';
      default:
        return 'Nope';
    }
}

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // get_cms_pages

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  loadHTMLContent(String htmlContent) async {
    final String contentBase64 =
    base64Encode(const Utf8Encoder().convert(htmlContent));

    final controller = await _controller.future;

    await controller.loadUrl('data:text/html;base64,$contentBase64');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: buildWebView()
        ),
      ),
    );
  }

  Widget buildWebView() {
    final provider = Provider.of<SettingsProvider>(context);

    switch(provider.cmsData.state){
      case Status.LOADING:
        return LoadingContainer();
        break;
      case Status.COMPLETED:
        return WebView(
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
              loadHTMLContent(provider.cmsData.data.data.dataDetails ?? "");
            },
            onProgress: (int progress) {
              print("WebView is loading (progress : $progress%)");
            },
            navigationDelegate: (NavigationRequest request)  {
              if(request.url.contains("mailto:") || request.url.contains("tel:")) {
                try{
                  launch(request.url);
                }catch(e){
                  print(e);
                }
                return NavigationDecision.prevent;
              }
              if (request.url.startsWith('https://www.youtube.com/')) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            }
        );
        break;
      case Status.ERROR:
      return NoDataFoundContainer(reason: provider.cmsData.msg ?? "");
        break;
    }
    return Container(
      color: Colors.white,
    );
  }
}

enum CMSType{
  privacyPolicy,
  terms,
  aboutUs
}