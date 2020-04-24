import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:android_intent/android_intent.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:file_utils/file_utils.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:kuvaton_client_flutter/components/entry_card/kuvaton_cached_network_image.dart';

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
  //PhotoViewScaleStateController _scaleStateController;
  final SweetSheet _sweetSheet = SweetSheet();

  Future _openImageIntent(String imagePath) async {
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'action_view',
        type: 'image/*',
        data: '$imagePath',
      );
      await intent.launch();
    }
  }

  //TODO: move to helper class
  void _saveImage(String imageUrl) async {
    /// handle permissions
    if (await Permission.storage.request().isGranted) {
      print('storage permission is granted');
    } else {
      _sweetSheet.show(
        context: context,
        color: SweetSheetColor.DANGER,
        title: Text('Error'),
        description:
            Text('You need to enable storage permissions to save images.'),
        icon: Icons.error,
        positive: SweetSheetAction(
          title: 'OKAY',
          onPressed: () => Navigator.of(context).pop(),
        ),
      );

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
    _sweetSheet.show(
      context: context,
      title: Text('Saved'),
      description: Text("The image has been saved to '${fileCopy.path}'"),
      color: SweetSheetColor.SUCCESS,
      icon: Icons.check_circle,
      positive: SweetSheetAction(
        title: 'OPEN',
        icon: Icons.open_in_new,
        onPressed: () {
          _openImageIntent(fileCopy.path);
          Navigator.of(context).pop();
        },
      ),
      negative: SweetSheetAction(
        title: "OKAY",
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _scaleStateController = PhotoViewScaleStateController();
  // }

  // @override
  // void dispose() {
  //   _scaleStateController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10 || details.delta.dy < 10) {
            ExtendedNavigator.of(context).pop();
          }
        },
        // onDoubleTap: () {
        //   print('double tap called');
        //   _scaleStateController.scaleState = PhotoViewScaleState.zoomedIn;
        // },
        child: PhotoView.customChild(
          //scaleStateController: _scaleStateController,
          backgroundDecoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Hero(
                tag: widget.imageUrl,
                child: SizedBox(
                  width: double.infinity,
                  child: KuvatonCachedNetworkImage(
                    imageUrl: widget.imageUrl,
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
