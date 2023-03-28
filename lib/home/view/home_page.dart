import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/home/bloc/home_bloc.dart';
import 'package:coffeer_app/home/view/carousel/carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_value_storage/key_value_storage.dart';

final api = CoffeeApi();
final storage = KeyValueStorage();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return HomeBloc(
          coffeeRepository: CoffeeRepository(
            api: api,
            storage: CoffeeLocalStorage(storage: storage),
          ),
        )..add(const OnRequestImages());
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
                  CarouselView(urlList: state.coffeeUrlList),
                ],
              );
            } else if (state is Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: Text('something went wrong!'),
              );
            }
          },
        ),
      ),
    );
  }
}
