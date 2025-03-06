import 'package:marvel_animation_app/shared/domain/models/api_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

class MockResult {
  final String value;
  MockResult(this.value);

  static MockResult fromJson(dynamic json) {
    return MockResult(json['value'].toString());
  }
}

void main() {
  group('ApiResponseModel', () {
    test('should correctly deserialize from JSON', () {
      final json = {
        'status': 'success',
        'results': {'value': 'test_value'},
      };
      
      final response = ApiResponseModel.fromJson(json, MockResult.fromJson);
      
      expect(response.status, 'success');
      expect(response.results, isA<MockResult>());
      expect(response.results!.value, 'test_value');
    });
  });
}
