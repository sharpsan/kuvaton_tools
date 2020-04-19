import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kuvaton_client_flutter/components/entry_card/kuvaton_cached_network_image.dart';
import 'package:kuvaton_client_flutter/helpers/vant_helper/vant_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinch_zoom_image_updated/pinch_zoom_image_updated.dart';

class ImageRoute extends StatefulWidget {
  final String imageFilename;
  final String imageUrl;
  ImageRoute({
    @required this.imageUrl,
    @required this.imageFilename,
  });
  @override
  _ImageRouteState createState() => _ImageRouteState();
}

class _ImageRouteState extends State<ImageRoute> {
  //TODO: move to helper class
  void _saveImage(String imageUrl) async {
    /// handle permissions
    if (await Permission.storage.request().isGranted) {
      print('storage permission is granted');
    } else {
      VantHelper.quickNDialog(context,
          title: "Permissions Error",
          message:
              "You need to enable storage permissions to be able to save images.");
      return;
    }

    /// save image
    DefaultCacheManager cacheManager = DefaultCacheManager();
    FileInfo fileInfo = await cacheManager.getFileFromCache(widget.imageUrl);
    File file = fileInfo.file;
    String filePath = '${file.path}';
    print('path to file: $filePath');
    String kuvatonDir =
        '${await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_PICTURES)}/kuvatON';
    print('kuvaton dir path: $kuvatonDir');
    bool makeDir = FileUtils.mkdir([kuvatonDir]);
    print('makeDir success: $makeDir');
    bool moveFile = FileUtils.move([filePath], kuvatonDir);
    print('move file success: $moveFile');
    print('try alternative move:');
    File fileCopy = await file.copy('$kuvatonDir/${widget.imageFilename}');
    print(await fileCopy.exists());
    VantHelper.quickNDialog(context,
        title: "File Downloaded",
        message:
            "'${widget.imageFilename}' has been saved to '${fileCopy.path}'");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10) {
            ExtendedNavigator.of(context).pop();
          }
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.transparent,
          child: Center(
            child: SingleChildScrollView(
              child: PinchZoomImage(
                image: SizedBox(
                  width: double.infinity,
                  child: Hero(
                    tag: widget.imageUrl,
                    child: KuvatonCachedNetworkImage(
                      imageUrl: widget.imageUrl,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () => _saveImage(widget.imageUrl),
      ),
    );
  }
}
