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
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: const Color(0xFFF6F6E9),
          iconTheme: const IconThemeData(color: Color(0xFF7B3911)),
          appBarTheme: AppBarTheme(
            color: const Color(0xFFFFDE59),
            titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF7B3911),
                ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: const Color(0xFFFFDE59),
            extendedTextStyle:
                Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF7B3911),
                      fontFamily: 'Poppins',
                    ),
            foregroundColor: const Color(0xFF7B3911),
          ),
          dialogTheme: DialogTheme(
            backgroundColor: const Color(0xFFF6F6E9),
            titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF7B3911),
                  fontFamily: 'BebasNeue',
                  fontSize: 24,
                ),
          ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: const MaterialColor(
              0xFF7B3911,
              <int, Color>{
                100: Color(0xFFD7CCC8),
                200: Color(0xFFBCAAA4),
                300: Color(0xFFA1887F),
                400: Color(0xFF8D6E63),
                500: Color(0xFF795548),
                600: Color(0xFF6D4C41),
                700: Color(0xFF5D4037),
                800: Color(0xFF4E342E),
                900: Color(0xFF3E2723),
              },
            ),
            backgroundColor: const Color(0xFFF6F6E9),
            accentColor: const Color(0xFFFFDE59),
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const PageManager(),
      ),
    );
  }
}
