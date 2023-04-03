import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffeer_app/shared/custom_card.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatefulWidget {
  const CustomNetworkImage({
    super.key,
    required this.url,
    required this.onSuccess,
    required this.smallestImageSideDimension,
    this.onLoading,
    this.onError,
    this.padding,
  });

  final String url;
  final Widget Function(BuildContext context, ImageProvider<Object> image)
      onSuccess;
  final Widget Function(BuildContext context, double? progress)? onLoading;
  final Widget Function(BuildContext context)? onError;
  final double smallestImageSideDimension;
  final EdgeInsetsGeometry? padding;

  @override
  State<CustomNetworkImage> createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(8),
      child: CachedNetworkImage(
        imageUrl: widget.url,
        imageBuilder: widget.onSuccess,
        progressIndicatorBuilder: (context, url, download) {
          return widget.onLoading?.call(context, download.progress) ??
              CustomCardShell(
                child: SizedBox(
                  height: widget.smallestImageSideDimension,
                  child: Center(
                    child: FittedBox(
                      child: CircularProgressIndicator(
                        value: download.progress,
                      ),
                    ),
                  ),
                ),
              );
        },
        errorWidget: (context, url, error) =>
            widget.onError?.call(context) ?? const SizedBox.shrink(),
      ),
    );
  }
}
