import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/carousel/bloc/carousel_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarouselView extends StatefulWidget {
  const CarouselView({
    super.key,
    required this.urlList,
    this.onRequestMore,
  });

  final List<String> urlList;
  final VoidCallback? onRequestMore;

  @override
  State<CarouselView> createState() => _CarouselViewState();
}

class _CarouselViewState extends State<CarouselView> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final smallestImageSideDimension = MediaQuery.of(context).size.width * .45;

    return Column(
      children: [
        SizedBox(
          height: smallestImageSideDimension,
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return BlocProvider<CarouselCubit>(
                create: (context) {
                  return CarouselCubit(
                    url: widget.urlList[index],
                    coffeeRepository:
                        RepositoryProvider.of<CoffeeRepository>(context),
                  );
                },
                child: CarouselItem(
                  url: widget.urlList[index],
                  smallestImageSideDimension: smallestImageSideDimension,
                ),
              );
            },
            itemCount: widget.urlList.length,
          ),
        ),
        if (widget.onRequestMore != null) ...[
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              widget.onRequestMore?.call();
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
            label: const Text('I want more!'),
            icon: const Icon(Icons.refresh_rounded),
          )
        ],
      ],
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

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: BlocBuilder<CarouselCubit, bool>(
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
                      Positioned(
                        bottom: 0,
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_outline_rounded,
                          color: Colors.red,
                          shadows: const [
                            Shadow(color: Colors.white, blurRadius: 8)
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        progressIndicatorBuilder: (context, url, download) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: smallestImageSideDimension / 2,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: CircularProgressIndicator(
                  value: download.progress,
                ),
              ),
            ),
          );
        },
        errorWidget: (context, url, error) => const SizedBox.shrink(),
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
