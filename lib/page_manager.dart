import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/connection_checker/connection_checker.dart';
import 'package:coffeer_app/favorites/favorites.dart' as favorites;
import 'package:coffeer_app/home/home.dart' as home;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageManager extends StatefulWidget {
  const PageManager({super.key});

  @override
  State<PageManager> createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> with ConnectionChecker {
  var _pageIndex = 0;

  @override
  bool get enableMaterialBanner => true;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => home.HomeBloc(
            coffeeRepository: RepositoryProvider.of<CoffeeRepository>(context),
          )..add(const home.RequestImages()),
        ),
        BlocProvider(
          create: (context) => favorites.FavoritesBloc(
            coffeeRepository: RepositoryProvider.of<CoffeeRepository>(context),
          )..add(const favorites.RequestImages()),
        )
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _pageIndex,
          children: const [
            home.HomeView(),
            favorites.FavoritesView(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: 'Favorites',
            ),
          ],
          onTap: (index) => setState(() => _pageIndex = index),
          currentIndex: _pageIndex,
        ),
      ),
    );
  }
}
