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
        appBar: AppBar(
          title: Text(
            _pageIndex == 0 ? 'Home' : 'Favorites',
            style: const TextStyle(
              fontFamily: 'BebasNeue',
              fontSize: 24,
            ),
          ),
        ),
        body: IndexedStack(
          index: _pageIndex,
          children: const [
            home.HomeView(),
            favorites.FavoritesView(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text(_pageIndex == 1 ? 'Home' : 'Favorites'),
          icon: Icon(
            _pageIndex == 1 ? Icons.home_filled : Icons.favorite_rounded,
          ),
          onPressed: () {
            setState(() {
              if (_pageIndex == 0) {
                _pageIndex = 1;
              } else {
                _pageIndex = 0;
              }
            });
          },
        ),
      ),
    );
  }
}
