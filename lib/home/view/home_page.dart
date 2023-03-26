import 'package:coffee_api/coffee_api.dart';
import 'package:coffeer_app/home/view/carousel/carousel.dart';
import 'package:flutter/material.dart';

final api = CoffeeApi();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CarouselView(
              urlFutureList: List.generate(
                15,
                (index) =>
                    api.getCoffeeUrlHolder().then((holder) => holder.url),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
