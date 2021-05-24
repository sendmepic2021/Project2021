import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class CustomNetWorkImage extends StatelessWidget {
  CustomNetWorkImage({@required this.url, String assetName, BoxFit fit})
      : assetName = assetName ?? 'assets/images/placeholder.png',
        fit = fit ?? BoxFit.cover;

  final String url;
  final String assetName;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    try {

      final image = NetworkImage(url);
      return FadeInImage(
        fit: fit,
        placeholder: AssetImage(assetName,),
        image: image,
        imageErrorBuilder: (context, error, stackTrace) {

          return Image.asset(
            assetName,
            fit: fit,
          );
        },
        placeholderErrorBuilder: (context, error, stackTrace) {

          return Image.asset(
            assetName,
            fit: fit,
          );
        },
      );
    } catch (e) {
      return Container();
    }

  }
}
