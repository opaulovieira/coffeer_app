import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/favorites/bloc/favorites_bloc.dart';
import 'package:coffeer_app/home/bloc/bloc.dart' as home;
import 'package:coffeer_app/showcase/showcase.dart';
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
          listenWhen: (previousState, actualState) {
            return previousState is Idle &&
                (actualState is Idle || actualState is Empty);
          },
          listener: (context, state) {
            if (state is Idle && state.action != null) {
              final action = state.action;

              if (action is RequestUnfavoriteConfirmation) {
                showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Favorites'),
                      content: const Text(
                        'Are you sure you want to unfavorite this image?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Confirm'),
                        ),
                      ],
                    );
                  },
                ).then((shouldUnfavorite) {
                  final bloc = BlocProvider.of<FavoritesBloc>(context);

                  if (shouldUnfavorite != null && shouldUnfavorite) {
                    bloc.add(Unfavorite(id: action.key));
                  } else {
                    bloc.add(const CancelUnfavorite());
                  }
                });
              }
            } else if (state is Idle && state.action == null ||
                state is Empty) {
              BlocProvider.of<home.HomeBloc>(context)
                  .add(const home.UpdateFavoriteState());
            }
          },
          builder: (context, state) {
            if (state is Idle) {
              final coffeeList = state.coffeeList;

              final tableRows = coffeeList.slices(2).map(
                (row) {
                  return TableRow(
                    children: [
                      _FavoritesItem(coffee: row[0]),
                      if (row.length.isOdd)
                        const SizedBox.shrink()
                      else
                        _FavoritesItem(coffee: row[1]),
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
  const _FavoritesItem({required this.coffee});

  final Coffee coffee;

  void _onUnfavorite(BuildContext context) {
    BlocProvider.of<FavoritesBloc>(context).add(
      RequestUnfavorite(id: coffee.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final smallestImageSideDimension = MediaQuery.of(context).size.width * .45;

    return CachedNetworkImage(
      imageUrl: coffee.url,
      fit: BoxFit.fitHeight,
      imageBuilder: (context, image) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: GestureDetector(
            onTap: () {
              openUnfavoriteCoffeeShowcaseDialog(
                context,
                coffee: coffee,
                onUnfavorite: () => _onUnfavorite(context),
              );
            },
            onDoubleTap: () => _onUnfavorite(context),
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
