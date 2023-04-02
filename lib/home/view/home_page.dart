import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/home/bloc/home_bloc.dart';
import 'package:coffeer_app/home/view/widgets/carousel_view.dart';
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
