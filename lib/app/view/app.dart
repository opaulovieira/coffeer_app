import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffeer_app/l10n/l10n.dart';
import 'package:coffeer_app/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_value_storage/key_value_storage.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final CoffeeRepository coffeeRepository;
  late final CoffeeLocalStorage coffeeLocalStorage;
  late final CoffeeApi coffeeApi;
  late final KeyValueStorage keyValueStorage;

  @override
  void initState() {
    super.initState();

    coffeeApi = CoffeeApi();
    keyValueStorage = KeyValueStorage();

    coffeeLocalStorage = CoffeeLocalStorage(storage: keyValueStorage);
    coffeeRepository = CoffeeRepository(
      api: coffeeApi,
      storage: coffeeLocalStorage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CoffeeRepository>(
          create: (context) => coffeeRepository,
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
          colorScheme: ColorScheme.fromSwatch(
            accentColor: const Color(0xFF13B9FF),
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const PageManager(),
      ),
    );
  }
}
