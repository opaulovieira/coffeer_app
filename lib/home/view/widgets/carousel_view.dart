import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/favorites/bloc/bloc.dart' as favorites;
import 'package:coffeer_app/home/bloc/bloc.dart' as home;
import 'package:coffeer_app/showcase/showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarouselView extends StatefulWidget {
  const CarouselView({
    super.key,
    required this.coffeeList,
    this.onRequestMore,
  });

  final List<Coffee> coffeeList;
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Scrollbar(
        thickness: 8,
        thumbVisibility: true,
        radius: const Radius.circular(4),
        controller: scrollController,
        interactive: true,
        child: ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (context, index) => const SizedBox(height: 24),
          itemBuilder: (context, index) {
            final child = CarouselItem(
              coffee: widget.coffeeList[index],
              smallestImageSideDimension:
                  MediaQuery.of(context).size.width * .45,
            );

            if (index == widget.coffeeList.length - 1) {
              return Column(
                children: [
                  child,
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
                    ),
                    const SizedBox(height: 48),
                  ],
                ],
              );
            } else {
              return child;
            }
          },
          itemCount: widget.coffeeList.length,
        ),
      ),
    );
  }
}

class CarouselItem extends StatefulWidget {
  const CarouselItem({
    super.key,
    required this.coffee,
    this.smallestImageSideDimension,
  });

  final Coffee coffee;
  final double? smallestImageSideDimension;

  @override
  State<CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends State<CarouselItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CachedNetworkImage(
      imageUrl: widget.coffee.url,
      fit: BoxFit.fitWidth,
      imageBuilder: (context, image) {
        return _CarouselItemCard(
          image: image,
          coffee: widget.coffee,
        );
      },
      progressIndicatorBuilder: (context, url, download) {
        return _CarouselItemCardShell(
          child: SizedBox(
            height: widget.smallestImageSideDimension ??
                MediaQuery.of(context).size.width * .45,
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
      errorWidget: (context, url, error) => const SizedBox.shrink(),
    );
  }
}

class _CarouselItemCard extends StatelessWidget {
  const _CarouselItemCard({
    required this.image,
    required this.coffee,
  });

  final Coffee coffee;
  final ImageProvider<Object> image;

  void _onToggleAction(BuildContext context) {
    final bloc = BlocProvider.of<home.HomeBloc>(context);

    if (coffee.isFavorite) {
      bloc.add(home.Unfavorite(id: coffee.id));
    } else {
      bloc.add(home.Favorite(coffee: coffee));
    }

    BlocProvider.of<favorites.FavoritesBloc>(context)
        .add(const favorites.RequestImages());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openToggleFavoriteShowcaseDialog(
          context,
          coffee: coffee,
          onToggleAction: () => _onToggleAction(context),
        );
      },
      onDoubleTap: () => _onToggleAction(context),
      child: _CarouselItemCardShell(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image(image: image),
            ),
            const Divider(height: 2, thickness: 2, color: Colors.black),
            const SizedBox(height: 8),
            Icon(
              coffee.isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded,
              color: Colors.red,
              shadows: const [Shadow(color: Colors.white, blurRadius: 8)],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _CarouselItemCardShell extends StatelessWidget {
  const _CarouselItemCardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 12,
            spreadRadius: 2,
            blurStyle: BlurStyle.outer,
          )
        ],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 2,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: child,
    );
  }
}
