import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/carousel/carousel.dart';
import 'package:coffeer_app/home/bloc/home_bloc.dart';
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
              return Column(
                children: [
                  const Spacer(),
                  CarouselView(
                    urlList: state.coffeeUrlList,
                    onRequestMore: () {
                      BlocProvider.of<HomeBloc>(context).add(
                        const RequestImages(),
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                ],
              );
            } else if (state is Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Ops, sorry... \nSomething went wrong!',
                      style: TextStyle(fontSize: 24),
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
            }
          },
        ),
      ),
    );
  }
}
