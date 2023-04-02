import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/favorites/bloc/favorites_bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesBloc>(
      create: (context) {
        return FavoritesBloc(coffeeRepository: context.read<CoffeeRepository>())
          ..add(const RequestImages());
      },
      child: const FavoritesView(),
    );
  }
}

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<FavoritesBloc, FavoritesState>(
          listener: (context, state) {
            if (state is Idle && state.action != null) {
              final action = state.action;

              if (action is RequestUnfavoriteConfirmation) {
                showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Favorites'),
                      content: Text(
                          'Are you sure you want to unfavorite this image?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Cancel')),
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Confirm')),
                      ],
                    );
                  },
                ).then((shouldUnfavorite) {
                  if (shouldUnfavorite != null && shouldUnfavorite) {
                    BlocProvider.of<FavoritesBloc>(context)
                        .add(Unfavorite(key: action.key));
                  }
                });
              }
            }
          },
          builder: (context, state) {
            if (state is Idle) {
              final coffeeList = state.coffeeList;

              final tableRows = coffeeList.slices(2).map(
                (row) {
                  return TableRow(
                    children: [
                      _FavoritesItem(url: row[0].url),
                      if (row.length.isOdd)
                        const SizedBox.shrink()
                      else
                        _FavoritesItem(url: row[1].url),
                    ],
                  );
                },
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(4),
                child: Table(
                  children: tableRows.toList(),
                ),
              );
            } else if (state is Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: Text('It seems that you have not favorited anything'),
              );
            }
          },
        ),
      ),
    );
  }
}

class _FavoritesItem extends StatelessWidget {
  const _FavoritesItem({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final smallestImageSideDimension = MediaQuery.of(context).size.width * .45;

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.fitHeight,
      imageBuilder: (context, image) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: GestureDetector(
            onDoubleTap: () {
              BlocProvider.of<FavoritesBloc>(context).add(
                RequestUnfavorite(key: url),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image(image: image),
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
    );
  }
}
