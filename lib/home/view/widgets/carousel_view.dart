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
              return CarouselItem(
                coffee: widget.coffeeList[index],
                smallestImageSideDimension: smallestImageSideDimension,
              );
            },
            itemCount: widget.coffeeList.length,
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
  void _onToggleAction() {
    final bloc = BlocProvider.of<home.HomeBloc>(context);

    if (widget.coffee.isFavorite) {
      bloc.add(home.Unfavorite(id: widget.coffee.id));
    } else {
      bloc.add(home.Favorite(coffee: widget.coffee));
    }

    BlocProvider.of<favorites.FavoritesBloc>(context)
        .add(const favorites.RequestImages());
  }

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
        imageUrl: widget.coffee.url,
        fit: BoxFit.fitHeight,
        imageBuilder: (context, image) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () {
                openToggleFavoriteShowcaseDialog(
                  context,
                  coffee: widget.coffee,
                  onToggleAction: _onToggleAction,
                );
              },
              onDoubleTap: _onToggleAction,
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
                      widget.coffee.isFavorite
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
