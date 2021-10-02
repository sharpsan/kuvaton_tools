import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:android_intent/android_intent.dart';
import 'package:auto_route/auto_route.dart';
import 'package:file_utils/file_utils.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:kuvaton_client_flutter/components/entry_card/kuvaton_cached_network_image.dart';

class ImageRoute extends StatefulWidget {
  final String? imageFilename;
  final String? imageUrl;
  ImageRoute({
    required this.imageUrl,
    required this.imageFilename,
  });
  @override
  _ImageRouteState createState() => _ImageRouteState();
}

class _ImageRouteState extends State<ImageRoute> {
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
    if (!await Permission.storage.request().isGranted) {
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
    FileInfo? fileInfo = await cacheManager.getFileFromCache(widget.imageUrl!);
    if (fileInfo == null) {
      _sweetSheet.show(
        context: context,
        color: SweetSheetColor.DANGER,
        title: Text('Error'),
        description: Text('Cached file not found.'),
        icon: Icons.error,
        positive: SweetSheetAction(
          title: 'OKAY',
          onPressed: () => Navigator.of(context).pop(),
        ),
      );
      return;
    }
    File file = fileInfo.file;
    String filePath = '${file.path}';
    print('path to file: $filePath');
    var extStorageDirPath = '/storage/emulated/0';
    var picturesDirPath = '${extStorageDirPath}/Pictures';
    var kuvatonDirPath = '$picturesDirPath/kuvatON';
    var destination = '$kuvatonDirPath/${widget.imageFilename}';
    print('kuvaton dir path: $kuvatonDirPath');
    print('desired destination path $destination');
    await Directory(kuvatonDirPath).create(recursive: true);
    bool moveFile = FileUtils.rename(filePath, destination);
    print('moved file: $moveFile');
    if (!moveFile) {
      await file.copy(destination);
      print('file copied: true');
    }
    if (await File(destination).exists()) {
      print('file exists :)');

      /// trigger Android's media-scanner so new image shows up in gallery apps
      MediaScanner.loadMedia(path: destination);
      _sweetSheet.show(
        context: context,
        title: Text('Saved'),
        description: Text("The image has been saved to '$destination'"),
        color: SweetSheetColor.SUCCESS,
        icon: Icons.check_circle,
        positive: SweetSheetAction(
          title: 'OPEN',
          icon: Icons.open_in_new,
          onPressed: () {
            _openImageIntent(destination);
            Navigator.of(context).pop();
          },
        ),
        negative: SweetSheetAction(
          title: "OKAY",
          onPressed: () => Navigator.of(context).pop(),
        ),
      );
    } else {
      print('file failed to copy :(');
      _sweetSheet.show(
        context: context,
        color: SweetSheetColor.DANGER,
        title: Text('Error'),
        description: Text('Unable to save image.'),
        icon: Icons.error,
        positive: SweetSheetAction(
          title: 'OKAY',
          onPressed: () => Navigator.of(context).pop(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10 || details.delta.dy < 10) {
            context.router.pop();
          }
        },
        child: PhotoView.customChild(
          backgroundDecoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Hero(
                tag: widget.imageUrl ?? '',
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
        onPressed:
            widget.imageUrl == null ? null : () => _saveImage(widget.imageUrl!),
      ),
    );
  }
}
