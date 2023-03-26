// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:coffee_api/coffee_api.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockDio extends Mock implements Dio {}

extension _MockedGet on Dio {
  Future<Response<T>> mockedGet<T>(String path) {
    return get<T>(
      path,
      cancelToken: any(named: 'cancelToken'),
      data: any(named: 'data'),
      onReceiveProgress: any(named: 'onReceiveProgress'),
      options: any(named: 'options'),
      queryParameters: any(named: 'queryParameters'),
    );
  }
}

void main() {
  late Dio dio;
  late CoffeeApi sut;

  const baseUrl = 'https://coffee.alexflipnote.dev';
  const dataUrl = 'https://coffee.alexflipnote.dev/W7W69vnJ02A_coffee.jpg';

  setUp(() {
    dio = _MockDio();

    when(() {
      return dio.mockedGet<Map<String, Object?>>('/random.json');
    }).thenAnswer((invocation) async {
      return Response<Map<String, Object?>>(
        data: <String, Object?>{'file': dataUrl},
        requestOptions: RequestOptions(baseUrl: baseUrl),
        statusCode: 200,
      );
    });

    when(() {
      return dio.mockedGet<List<int>>('/random');
    }).thenAnswer((invocation) async {
      return Response<List<int>>(
        data: [1, 2, 3, 4],
        requestOptions: RequestOptions(baseUrl: baseUrl),
        statusCode: 200,
      );
    });

    sut = CoffeeApi(dio: dio);
  });

  group('CoffeeApi', () {
    test('can be instantiated', () {
      expect(sut, isNotNull);
    });

    test('returns a CoffeeUrl object when calling getCoffeeUrlHolder', () {
      expect(
        sut.getCoffeeUrlHolder(),
        completion(CoffeeUrl(url: dataUrl)),
      );
    });

    test('returns a Uint8List object when calling getCoffeeBytes', () {
      expect(
        sut.getCoffeeBytes(),
        completion(Uint8List.fromList([1, 2, 3, 4])),
      );
    });

    test(
      'throws UnsuccessfulRequestException '
      "when response's statusCode is not 200",
      () async {
        when(() {
          return dio.mockedGet<Map<String, Object?>>('/random.json');
        }).thenAnswer((invocation) async {
          return Response<Map<String, Object?>>(
            data: <String, Object?>{'file': dataUrl},
            requestOptions: RequestOptions(baseUrl: baseUrl),
          );
        });

        when(() {
          return dio.mockedGet<List<int>>('/random');
        }).thenAnswer((invocation) async {
          return Response<List<int>>(
            data: [1, 2, 3, 4],
            requestOptions: RequestOptions(baseUrl: baseUrl),
          );
        });

        expect(
          sut.getCoffeeBytes(),
          throwsA(isA<UnsuccessfulRequestException>()),
        );

        expect(
          sut.getCoffeeUrlHolder(),
          throwsA(isA<UnsuccessfulRequestException>()),
        );
      },
    );

    test(
      "throws UnsuccessfulRequestException when response's data is null",
      () async {
        when(() {
          return dio.mockedGet<Map<String, Object?>>('/random.json');
        }).thenAnswer((invocation) async {
          return Response<Map<String, Object?>>(
            requestOptions: RequestOptions(baseUrl: baseUrl),
            statusCode: 200,
          );
        });

        when(() {
          return dio.mockedGet<List<int>>('/random');
        }).thenAnswer((invocation) async {
          return Response<List<int>>(
            requestOptions: RequestOptions(baseUrl: baseUrl),
            statusCode: 200,
          );
        });

        expect(
          sut.getCoffeeBytes(),
          throwsA(isA<UnsuccessfulRequestException>()),
        );

        expect(
          sut.getCoffeeUrlHolder(),
          throwsA(isA<UnsuccessfulRequestException>()),
        );
      },
    );

    test(
      'throws FailedRequestException when the http client throws an error',
      () async {
        when(() {
          return dio.mockedGet<Map<String, Object?>>('/random.json');
        }).thenThrow((invocation) {
          return Future<Map<String, Object?>>.error(Exception('Error'));
        });

        when(() {
          return dio.mockedGet<List<int>>('/random');
        }).thenThrow((invocation) async {
          return Future<List<int>>.error(Exception('Error'));
        });

        expect(
          sut.getCoffeeBytes(),
          throwsA(isA<FailedRequestException>()),
        );

        expect(
          sut.getCoffeeUrlHolder(),
          throwsA(isA<FailedRequestException>()),
        );
      },
    );
  });
}
