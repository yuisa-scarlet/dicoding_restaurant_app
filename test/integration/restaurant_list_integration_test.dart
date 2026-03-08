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

  group('Restaurant List Integration Test', () {
    test(
      'full flow: fetch API → parse JSON → Restaurant model → provider state',
      () async {
        const realApiResponse = '''
      {
        "error": false,
        "message": "success",
        "count": 3,
        "restaurants": [
          {
            "id": "rqdv5juczeskfw1e867",
            "name": "Melting Pot",
            "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.",
            "pictureId": "14",
            "city": "Medan",
            "rating": 4.2
          },
          {
            "id": "s1knt6za9kkfw1e867",
            "name": "Kafe Kita",
            "description": "Quisque rutrum. Aenean imperdiet.",
            "pictureId": "25",
            "city": "Gorontalo",
            "rating": 4.0
          },
          {
            "id": "w9pez5lzsa12fw1e867",
            "name": "Bring Your Phone Cafe",
            "description": "Tempor incididunt ut labore et dolore magna aliqua.",
            "pictureId": "03",
            "city": "Surabaya",
            "rating": 4.2
          }
        ]
      }
      ''';

        when(
          () => mockApiClient.get('/list'),
        ).thenAnswer((_) async => http.Response(realApiResponse, 200));

        final provider = RestaurantListProvider(apiClient: mockApiClient);

        await Future.delayed(Duration.zero);

        expect(provider.state, isA<BaseResultStateSuccess<List<Restaurant>>>());

        final state =
            provider.state as BaseResultStateSuccess<List<Restaurant>>;
        final restaurants = state.data;

        expect(restaurants.length, 3);

        expect(restaurants[0].id, 'rqdv5juczeskfw1e867');
        expect(restaurants[0].name, 'Melting Pot');
        expect(restaurants[0].city, 'Medan');
        expect(restaurants[0].rating, 4.2);

        expect(restaurants[1].id, 's1knt6za9kkfw1e867');
        expect(restaurants[1].name, 'Kafe Kita');
        expect(restaurants[1].city, 'Gorontalo');

        expect(restaurants[2].name, 'Bring Your Phone Cafe');
        expect(restaurants[2].city, 'Surabaya');

        verify(() => mockApiClient.get('/list')).called(1);
      },
    );
  });
}
