import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension ImageTool on ImageProvider {
  Future<Uint8List?> getBytes(
    BuildContext context, {
    ImageByteFormat format = ImageByteFormat.rawRgba,
  }) async {
    final completer = Completer<Uint8List?>();

    final imageStream = resolve(createLocalImageConfiguration(context));
    final listener = ImageStreamListener(
      (imageInfo, synchronousCall) async {
        final bytes = await imageInfo.image.toByteData(format: format);

        if (!completer.isCompleted) {
          completer.complete(bytes?.buffer.asUint8List());
        }
      },
    );

    imageStream.addListener(listener);

    final imageBytes = await completer.future;

    imageStream.removeListener(listener);

    return imageBytes;
  }
}

class CarouselView extends StatelessWidget {
  const CarouselView({super.key, required this.urlFutureList});

  final List<Future<String>> urlFutureList;

  @override
  Widget build(BuildContext context) {
    final smallestImageSideDimension = MediaQuery.of(context).size.width * .45;

    return SizedBox(
      height: smallestImageSideDimension,
      child: FutureBuilder<List<String>>(
        future: Future.wait<String>(urlFutureList),
        builder: (context, snapshot) {
          final urlList = snapshot.data;

          if (urlList != null &&
              snapshot.connectionState == ConnectionState.done) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CarouselItem(
                  url: urlList[index],
                  smallestImageSideDimension: smallestImageSideDimension,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemCount: urlList.length,
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          } else {
            throw StateError('An unrecognized state happened at CarouselView');
          }
        },
      ),
    );
  }
}

class CarouselItem extends StatelessWidget {
  const CarouselItem({
    super.key,
    required this.url,
    this.smallestImageSideDimension,
  });

  final String url;
  final double? smallestImageSideDimension;

  @override
  Widget build(BuildContext context) {
    final smallestImageSideDimension = this.smallestImageSideDimension ??
        MediaQuery.of(context).size.width * .45;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: smallestImageSideDimension,
        maxWidth: smallestImageSideDimension * 2,
      ),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.fitHeight,
        imageBuilder: (context, image) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image(image: image),
          );
        },
        progressIndicatorBuilder: (context, url, download) {
          return SizedBox(
            width: smallestImageSideDimension / 2,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: CircularProgressIndicator(
                value: download.progress,
              ),
            ),
          );
        },
      ),
    );
  }
}
