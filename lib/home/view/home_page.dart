import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/favorites/bloc/bloc.dart' as favorites;
import 'package:coffeer_app/home/bloc/home_bloc.dart';
import 'package:coffeer_app/shared/shared.dart';
import 'package:coffeer_app/showcase/showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return HomeBloc(
          coffeeRepository: RepositoryProvider.of<CoffeeRepository>(context),
        )..add(const RequestImages());
      },
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is Success) {
              return CarouselView(
                coffeeList: state.coffeeList,
                onRequestMore: () {
                  BlocProvider.of<HomeBloc>(context).add(
                    const RequestImages(),
                  );
                },
              );
            } else if (state is Error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.detail.message,
                      style: const TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<HomeBloc>(context).add(
                          const TryAgain(),
                        );
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class CarouselView extends StatefulWidget {
  const CarouselView({
    super.key,
    required this.coffeeList,
    required this.onRequestMore,
  });

  final List<Coffee> coffeeList;
  final VoidCallback onRequestMore;

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
        child: RefreshIndicator(
          onRefresh: () async {
            widget.onRequestMore();
          },
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return _CarouselItem(coffee: widget.coffeeList[index]);
            },
            itemCount: widget.coffeeList.length,
          ),
        ),
      ),
    );
  }
}

class _CarouselItem extends StatefulWidget {
  const _CarouselItem({required this.coffee});

  final Coffee coffee;

  @override
  State<_CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends State<_CarouselItem> {
  void _onToggleAction(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context);

    if (widget.coffee.isFavorite) {
      bloc.add(Unfavorite(id: widget.coffee.id));
    } else {
      bloc.add(Favorite(coffee: widget.coffee));
    }

    BlocProvider.of<favorites.FavoritesBloc>(context)
        .add(const favorites.RequestImages());
  }

  @override
  Widget build(BuildContext context) {
    return CustomNetworkImage(
      url: widget.coffee.url,
      onSuccess: (context, image) {
        return CustomCard(
          image: image,
          height: MediaQuery.of(context).size.width * .45,
          flexFit: FlexFit.loose,
          leftIcon: Icon(
            widget.coffee.isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_outline_rounded,
            color: Colors.red,
            shadows: const [Shadow(color: Colors.white, blurRadius: 8)],
          ),
          onRightAction: () {
            openToggleFavoriteShowcaseDialog(
              context,
              coffee: widget.coffee,
              onToggleAction: () => _onToggleAction(context),
            );
          },
          onLeftAction: () => _onToggleAction(context),
          onImageTap: () {
            openToggleFavoriteShowcaseDialog(
              context,
              coffee: widget.coffee,
              onToggleAction: () => _onToggleAction(context),
            );
          },
          onImageDoubleTap: () => _onToggleAction(context),
        );
      },
      smallestImageSideDimension: MediaQuery.of(context).size.width * .45,
    );
  }
}
