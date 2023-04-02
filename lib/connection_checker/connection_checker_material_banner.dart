import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

mixin ConnectionChecker<T extends StatefulWidget> on State<T> {
  static final _connectivity = Connectivity();

  late final StreamSubscription<ConnectivityResult>
      _connectivityResultStreamSubscription;

  Stream<bool> get hasInternetConnectionStream =>
      _connectivity.onConnectivityChanged.asyncMap((event) async {
        return _hasInternetConnection();
      }).distinct();

  void _openMaterialBanner(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();

    ScaffoldMessenger.of(context).showMaterialBanner(
      ConnectionCheckerMaterialBanner(),
    );
  }

  Future<bool> _hasInternetConnection() async {
    await Future<void>.delayed(const Duration(seconds: 1));

    try {
      final result = await InternetAddress.lookup('example.com');

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    _connectivity.checkConnectivity().then((value) async {
      final hasConnection = await _hasInternetConnection();

      if (mounted && !hasConnection) {
        _openMaterialBanner(context);
      }
    });

    _connectivityResultStreamSubscription =
        _connectivity.onConnectivityChanged.listen((event) async {
      final hasConnection = await _hasInternetConnection();

      if (mounted) {
        if (hasConnection) {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        } else {
          _openMaterialBanner(context);
        }
      }
    });
  }

  @override
  void dispose() {
    _connectivityResultStreamSubscription.cancel();
    super.dispose();
  }
}

class ConnectionCheckerMaterialBanner extends MaterialBanner {
  ConnectionCheckerMaterialBanner({super.key})
      : super(
          backgroundColor: Colors.red,
          content: const SizedBox(
            height: 100,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Well, well, well... Looks like you do not have access to the'
                ' internet. It will be necessary to reopen the app after '
                'getting signal again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          actions: [
            Builder(
              builder: (context) {
                return TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  },
                  child: const Text(
                    'Ok. Got it',
                    style: TextStyle(
                      color: Colors.yellow,
                    ),
                  ),
                );
              },
            ),
          ],
        );
}
