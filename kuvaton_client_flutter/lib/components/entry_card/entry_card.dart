import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kuvaton_client_flutter/components/entry_card/kuvaton_cached_network_image.dart';
import 'package:kuvaton_client_flutter/generatable/router/router.gr.dart';

class EntryCard extends StatefulWidget {
  final String imageFilename;
  final String imageUrl;
  EntryCard({
    @required this.imageFilename,
    @required this.imageUrl,
  });
  @override
  _EntryCardState createState() => _EntryCardState();
}

class _EntryCardState extends State<EntryCard> {
  bool isFinishedLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400],
            blurRadius: 6.0, // has the effect of softening the shadow
            spreadRadius: 1.0, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              2.0, // vertical, move down 10
            ),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: widget.imageUrl,
                  child: KuvatonCachedNetworkImage(imageUrl: widget.imageUrl),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  ExtendedNavigator.ofRouter<Router>().pushImageRoute(
                      imageFilename: widget.imageFilename,
                      imageUrl: widget.imageUrl);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
