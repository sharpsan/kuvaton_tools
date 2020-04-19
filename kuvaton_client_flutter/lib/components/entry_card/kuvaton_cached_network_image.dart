import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class KuvatonCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  KuvatonCachedNetworkImage({
    @required this.imageUrl,
    this.fit = BoxFit.fitWidth,
  });
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.fitWidth,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return Container(
          height: 100,
          child: Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child:
                  CircularProgressIndicator(value: downloadProgress.progress),
            ),
          ),
        );
      },
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
