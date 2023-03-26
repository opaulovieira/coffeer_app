import 'package:coffee_api/src/models/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Exception which may occur in case of fetched data returns null or '
/// the status code being different from 200.
class UnsuccessfulRequestException implements Exception {}

/// {@template failed_request_exception}
/// Exception which may occur in case of fetched data throws an error
/// {@endtemplate}
class FailedRequestException implements Exception {
  /// {@macro failed_request_exception}
  const FailedRequestException(this.error, this.stackTrace);

  /// The error that was caught.
  final Object error;

  /// The Stacktrace associated with the [error].
  final StackTrace stackTrace;
}

/// {@template coffee_api}
/// Service to fetch coffee images from https://coffee.alexflipnote.dev/
/// {@endtemplate}
abstract class CoffeeApiContract {
  /// {@macro coffee_api}
  const CoffeeApiContract(this._dio);

  final Dio _dio;

  /// {@template get_coffee_url_holder}
  /// Returns a [CoffeeUrl], which holds an url for fetching a coffee image
  /// {@endtemplate}
  Future<CoffeeUrl> getCoffeeUrlHolder();

  /// {@template get_coffee_bytes}
  /// Returns the bytes of a coffee image
  /// {@endtemplate}
  Future<Uint8List> getCoffeeBytes();
}

/// {@macro coffee_api}
class CoffeeApi extends CoffeeApiContract {
  /// {@macro coffee_api}
  CoffeeApi({
    @visibleForTesting Dio? dio,
  }) : super(
          dio ?? Dio(BaseOptions(baseUrl: 'https://coffee.alexflipnote.dev')),
        );

  @override
  Future<CoffeeUrl> getCoffeeUrlHolder() async {
    try {
      final response = await _dio.get<Map<String, Object?>>(
        '/random.json',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );

      final data = response.data;
      if (data != null && response.statusCode == 200) {
        return CoffeeUrl.fromJson(data);
      } else {
        throw UnsuccessfulRequestException();
      }
    } on UnsuccessfulRequestException {
      rethrow;
    } catch (error, stackTrace) {
      throw FailedRequestException(error, stackTrace);
    }
  }

  @override
  Future<Uint8List> getCoffeeBytes() async {
    try {
      final response = await _dio.get<List<int>>(
        '/random',
        options: Options(
          contentType: 'image/png',
          responseType: ResponseType.bytes,
        ),
      );

      final data = response.data;
      if (data != null && response.statusCode == 200) {
        return Uint8List.fromList(data);
      } else {
        throw UnsuccessfulRequestException();
      }
    } on UnsuccessfulRequestException {
      rethrow;
    } catch (error, stackTrace) {
      throw FailedRequestException(error, stackTrace);
    }
  }
}
