import 'package:dicoding_restaurant_app/core/api_client.dart';
import 'package:dicoding_restaurant_app/core/base_result_state.dart';
import 'package:dicoding_restaurant_app/feature/home/providers/restaurant_list/restaurant_list_provider.dart';
import 'package:dicoding_restaurant_app/shared/models/restaurant.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
  });

  const successResponseBody = '''
  {
    "error": false,
    "message": "success",
    "count": 2,
    "restaurants": [
      {
        "id": "rqdv5juczeskfw1e867",
        "name": "Melting Pot",
        "description": "Lorem ipsum dolor sit amet",
        "pictureId": "14",
        "city": "Medan",
        "rating": 4.2
      },
      {
        "id": "s1knt6za9kkfw1e867",
        "name": "Kafe Kita",
        "description": "Quisque rutrum",
        "pictureId": "25",
        "city": "Gorontalo",
        "rating": 4.0
      }
    ]
  }
  ''';

  const emptyResponseBody = '''
  {
    "error": false,
    "message": "success",
    "count": 0,
    "restaurants": []
  }
  ''';

  group('RestaurantListProvider', () {
    test(
      'initial state should be loading (constructor auto-fetches)',
      () async {
        when(
          () => mockApiClient.get('/list'),
        ).thenAnswer((_) async => http.Response(successResponseBody, 200));

        final provider = RestaurantListProvider(apiClient: mockApiClient);
        expect(provider.state, isA<BaseResultStateLoading>());
      },
    );

    test('should return list of restaurants when API call succeeds', () async {
      when(
        () => mockApiClient.get('/list'),
      ).thenAnswer((_) async => http.Response(successResponseBody, 200));

      final provider = RestaurantListProvider(apiClient: mockApiClient);
      await Future.delayed(Duration.zero);

      expect(provider.state, isA<BaseResultStateSuccess<List<Restaurant>>>());

      final successState =
          provider.state as BaseResultStateSuccess<List<Restaurant>>;
      expect(successState.data.length, 2);
      expect(successState.data[0].name, 'Melting Pot');
      expect(successState.data[1].name, 'Kafe Kita');
    });

    test(
      'should return error when API call fails with non-200 status',
      () async {
        when(
          () => mockApiClient.get('/list'),
        ).thenAnswer((_) async => http.Response('Server Error', 500));

        final provider = RestaurantListProvider(apiClient: mockApiClient);

        await Future.delayed(Duration.zero);

        expect(provider.state, isA<BaseResultStateError<List<Restaurant>>>());

        final errorState =
            provider.state as BaseResultStateError<List<Restaurant>>;
        expect(errorState.errorMessage, contains('error'));
      },
    );

    test('should return error when restaurant list is empty', () async {
      when(
        () => mockApiClient.get('/list'),
      ).thenAnswer((_) async => http.Response(emptyResponseBody, 200));

      final provider = RestaurantListProvider(apiClient: mockApiClient);

      await Future.delayed(Duration.zero);

      expect(provider.state, isA<BaseResultStateError<List<Restaurant>>>());

      final errorState =
          provider.state as BaseResultStateError<List<Restaurant>>;
      expect(errorState.errorMessage, 'No restaurants found.');
    });
  });
}
