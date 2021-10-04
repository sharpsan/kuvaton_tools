import 'package:android_intent/flag.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:android_intent/android_intent.dart';
import 'package:auto_route/auto_route.dart';
import 'package:file_utils/file_utils.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:share/share.dart';
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
  final _sweetSheet = SweetSheet();
  final _scaleStateController = PhotoViewScaleStateController();
  final _photoViewController = PhotoViewController();
  final _cacheManager = DefaultCacheManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoView.customChild(
            backgroundDecoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            controller: _photoViewController,
            scaleStateController: _scaleStateController,
            scaleStateCycle: _scaleStateCycle,
            initialScale: PhotoViewComputedScale.contained * 1.0,
            minScale: PhotoViewComputedScale.contained * 1.0,
            maxScale: PhotoViewComputedScale.covered * 2.5,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                /// returns when zoomed in/out
                /// to prevent accidental swiping
                if (_scaleStateController.isZooming) return;

                if (details.delta.dy > 10 || details.delta.dy < 10) {
                  context.router.pop();
                }
              },
              onDoubleTap: () {
                if (_scaleStateController.isZooming) {
                  _scaleStateController.reset();
                } else {
                  _photoViewController.scale =
                      (PhotoViewComputedScale.covered * 2.5).multiplier;
                }
              },
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

          /// top bar
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.only(
                left: 4,
                top: MediaQuery.of(context).padding.top + 4,
                right: 4,
                bottom: 4,
              ),
              child: Row(
                children: [
                  BackButton(
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${widget.imageFilename}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Theme.of(context).textTheme.headline6?.fontSize,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    onPressed: () => _shareImage(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed:
            widget.imageUrl == null ? null : () => _saveImage(widget.imageUrl!),
      ),
    );
  }

  @override
  void dispose() {
    _scaleStateController.dispose();
    _photoViewController.dispose();
    super.dispose();
  }

  Future<void> _openImageIntent(String imagePath) async {
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'action_view',
        type: 'image/*',
        data: '$imagePath',
      );
      return await intent.launch();
    }
  }

  Future<void> _shareImage() async {
    FileInfo? fileInfo = await _cacheManager.getFileFromCache(widget.imageUrl!);
    if (fileInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error has ocurred while trying to share this image.',
          ),
        ),
      );
      return;
    }
    if (widget.imageFilename == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error has ocurred while trying to share this image.',
          ),
        ),
      );
    }
    return await Share.shareFiles([fileInfo.file.path]);
  }

  //TODO: move to helper class
  Future<void> _saveImage(String imageUrl) async {
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
    FileInfo? fileInfo = await _cacheManager.getFileFromCache(widget.imageUrl!);
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

  PhotoViewScaleState _scaleStateCycle(PhotoViewScaleState actual) {
    switch (actual) {
      case PhotoViewScaleState.zoomedIn:
      case PhotoViewScaleState.zoomedOut:
      case PhotoViewScaleState.covering:
        return PhotoViewScaleState.initial;
      case PhotoViewScaleState.initial:
      case PhotoViewScaleState.originalSize:
      default:
        return PhotoViewScaleState.covering;
    }
  }
}
