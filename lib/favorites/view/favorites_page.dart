import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/favorites/bloc/favorites_bloc.dart';
import 'package:coffeer_app/home/bloc/bloc.dart' as home;
import 'package:coffeer_app/shared/shared.dart';
import 'package:coffeer_app/showcase/showcase.dart';
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

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

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

              return Padding(
                padding: const EdgeInsets.all(4),
                child: Scrollbar(
                  thickness: 8,
                  thumbVisibility: true,
                  radius: const Radius.circular(4),
                  controller: scrollController,
                  interactive: true,
                  child: GridView.count(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 32,
                      right: 32,
                      top: 24,
                      bottom: 80,
                    ),
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    children: coffeeList
                        .map((coffee) => _FavoritesItem(coffee: coffee))
                        .toList(),
                  ),
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

    return CustomNetworkImage(
      url: coffee.url,
      onSuccess: (context, image) {
        return CustomCard(
          image: image,
          onImageTap: () {
            openUnfavoriteShowcaseDialog(
              context,
              coffee: coffee,
              onUnfavorite: () => _onUnfavorite(context),
            );
          },
          onRightAction: () {
            openUnfavoriteShowcaseDialog(
              context,
              coffee: coffee,
              onUnfavorite: () => _onUnfavorite(context),
            );
          },
          onLeftAction: () => _onUnfavorite(context),
        );
      },
      onError: (context) {
        return SizedBox(
          width: smallestImageSideDimension / 2,
          height: smallestImageSideDimension / 2,
          child: const Center(
            child: Text(
              'Sorry :/\nSomething went wrong while loading your image!',
              style: TextStyle(fontSize: 10),
            ),
          ),
        );
      },
      smallestImageSideDimension: smallestImageSideDimension / 2,
    );
  }
}
