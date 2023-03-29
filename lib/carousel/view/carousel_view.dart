import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/carousel/bloc/carousel_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarouselView extends StatelessWidget {
  const CarouselView({super.key, required this.urlList});

  final List<String> urlList;

  @override
  Widget build(BuildContext context) {
    final smallestImageSideDimension = MediaQuery.of(context).size.width * .45;

    return SizedBox(
      height: smallestImageSideDimension,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return BlocProvider<CarouselCubit>(
            create: (context) {
              return CarouselCubit(
                url: urlList[index],
                coffeeRepository:
                    RepositoryProvider.of<CoffeeRepository>(context),
              );
            },
            child: CarouselItem(
              url: urlList[index],
              smallestImageSideDimension: smallestImageSideDimension,
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemCount: urlList.length,
      ),
    );
  }
}

class CarouselItem extends StatefulWidget {
  const CarouselItem({
    super.key,
    required this.url,
    this.smallestImageSideDimension,
  });

  final String url;
  final double? smallestImageSideDimension;

  @override
  State<CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends State<CarouselItem>
    with AutomaticKeepAliveClientMixin {
  final bytesCompleter = Completer<Uint8List?>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final smallestImageSideDimension = widget.smallestImageSideDimension ??
        MediaQuery.of(context).size.width * .45;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: smallestImageSideDimension,
        maxWidth: smallestImageSideDimension * 2,
      ),
      child: CachedNetworkImage(
        imageUrl: widget.url,
        fit: BoxFit.fitHeight,
        imageBuilder: (context, image) {
          if (!bytesCompleter.isCompleted) {
            bytesCompleter.complete(image.getBytes(context));
          }

          return BlocBuilder<CarouselCubit, bool>(
            builder: (context, isFavorite) {
              return GestureDetector(
                onDoubleTap: () {
                  final cubit = BlocProvider.of<CarouselCubit>(context);

                  if (isFavorite) {
                    cubit.unfavorite();
                  } else {
                    cubit.favorite(bytesCompleter.future);
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image(image: image),
                    ),
                    Icon(
                      Icons.favorite,
                      color: isFavorite ? Colors.red : Colors.black,
                    ),
                  ],
                ),
              );
            },
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

extension _ImageTool on ImageProvider {
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
