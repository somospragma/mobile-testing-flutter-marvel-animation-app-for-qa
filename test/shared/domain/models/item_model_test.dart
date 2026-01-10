import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/shared/domain/models/item_model.dart';

void main() {
  group('ItemModel', () {
    const testId = 1;
    const testTitle = 'Test Title';
    const testSubtitle = 'Test Subtitle';
    const testImageUrl = 'https://example.com/image.jpg';
    const testButtonText = 'Test Button';

    group('constructor', () {
      testWidgets('should create ItemModel with all required properties',
          (tester) async {
        final itemModel = ItemModel(
          id: testId,
          title: testTitle,
          subtitle: testSubtitle,
          imageUrl: testImageUrl,
          buttonText: testButtonText,
        );

        expect(itemModel.id, equals(testId));
        expect(itemModel.title, equals(testTitle));
        expect(itemModel.subtitle, equals(testSubtitle));
        expect(itemModel.imageUrl, equals(testImageUrl));
        expect(itemModel.buttonText, equals(testButtonText));
      });

      test('should create ItemModel with minimum valid data', () {
        final itemModel = ItemModel(
          id: 0,
          title: '',
          subtitle: '',
          imageUrl: '',
          buttonText: '',
        );

        expect(itemModel.id, equals(0));
        expect(itemModel.title, equals(''));
        expect(itemModel.subtitle, equals(''));
        expect(itemModel.imageUrl, equals(''));
        expect(itemModel.buttonText, equals(''));
      });

      test('should create ItemModel with negative id', () {
        final itemModel = ItemModel(
          id: -1,
          title: testTitle,
          subtitle: testSubtitle,
          imageUrl: testImageUrl,
          buttonText: testButtonText,
        );

        expect(itemModel.id, equals(-1));
        expect(itemModel.title, equals(testTitle));
      });

      test('should create ItemModel with long strings', () {
        const longString =
            'This is a very long string that contains multiple words and characters to test edge cases with lengthy content';

        final itemModel = ItemModel(
          id: testId,
          title: longString,
          subtitle: longString,
          imageUrl: longString,
          buttonText: longString,
        );

        expect(itemModel.title, equals(longString));
        expect(itemModel.subtitle, equals(longString));
        expect(itemModel.imageUrl, equals(longString));
        expect(itemModel.buttonText, equals(longString));
      });

      test('should create ItemModel with special characters', () {
        const specialTitle = 'Special @#\$%^&*()_+ Title';
        const specialSubtitle = 'Subtitle with émojis 🚀 and áccénts';
        const specialUrl = 'https://example.com/path?param=value&other=123';
        const specialButton = 'Buttón with ñ and ü';

        final itemModel = ItemModel(
          id: testId,
          title: specialTitle,
          subtitle: specialSubtitle,
          imageUrl: specialUrl,
          buttonText: specialButton,
        );

        expect(itemModel.title, equals(specialTitle));
        expect(itemModel.subtitle, equals(specialSubtitle));
        expect(itemModel.imageUrl, equals(specialUrl));
        expect(itemModel.buttonText, equals(specialButton));
      });
    });

    group('fromJson', () {
      test('should create ItemModel from valid JSON', () {
        final json = {
          'id': testId,
          'title': testTitle,
          'subtitle': testSubtitle,
          'image': testImageUrl,
          'buttonText': testButtonText,
        };

        final itemModel = ItemModel.fromJson(json);

        expect(itemModel.id, equals(testId));
        expect(itemModel.title, equals(testTitle));
        expect(itemModel.subtitle, equals(testSubtitle));
        expect(itemModel.imageUrl, equals(testImageUrl));
        expect(itemModel.buttonText, equals(testButtonText));
      });

      test('should create ItemModel from JSON with different data types', () {
        final json = {
          'id': 999,
          'title': 'Another Title',
          'subtitle': 'Another Subtitle',
          'image': 'https://different.com/image.png',
          'buttonText': 'Different Button',
        };

        final itemModel = ItemModel.fromJson(json);

        expect(itemModel.id, equals(999));
        expect(itemModel.title, equals('Another Title'));
        expect(itemModel.subtitle, equals('Another Subtitle'));
        expect(itemModel.imageUrl, equals('https://different.com/image.png'));
        expect(itemModel.buttonText, equals('Different Button'));
      });

      test('should create ItemModel from JSON with empty strings', () {
        final json = {
          'id': 0,
          'title': '',
          'subtitle': '',
          'image': '',
          'buttonText': '',
        };

        final itemModel = ItemModel.fromJson(json);

        expect(itemModel.id, equals(0));
        expect(itemModel.title, equals(''));
        expect(itemModel.subtitle, equals(''));
        expect(itemModel.imageUrl, equals(''));
        expect(itemModel.buttonText, equals(''));
      });

      test('should throw error when creating ItemModel from JSON with null id',
          () {
        final json = {
          'id': null,
          'title': testTitle,
          'subtitle': testSubtitle,
          'image': testImageUrl,
          'buttonText': testButtonText,
        };

        expect(
          () => ItemModel.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('should handle JSON with extra fields', () {
        final json = {
          'id': testId,
          'title': testTitle,
          'subtitle': testSubtitle,
          'image': testImageUrl,
          'buttonText': testButtonText,
          'extraField': 'extraValue',
          'anotherField': 123,
        };

        final itemModel = ItemModel.fromJson(json);

        expect(itemModel.id, equals(testId));
        expect(itemModel.title, equals(testTitle));
        expect(itemModel.subtitle, equals(testSubtitle));
        expect(itemModel.imageUrl, equals(testImageUrl));
        expect(itemModel.buttonText, equals(testButtonText));
      });

      test('should handle JSON with missing fields', () {
        final json = {
          'id': testId,
          'title': testTitle,
        };

        expect(
          () => ItemModel.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('should handle empty JSON', () {
        final json = <String, dynamic>{};

        expect(
          () => ItemModel.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });

      test(
          'should throw error when creating ItemModel from JSON with wrong id type',
          () {
        final json = {
          'id': 'not_a_number',
          'title': testTitle,
          'subtitle': testSubtitle,
          'image': testImageUrl,
          'buttonText': testButtonText,
        };

        expect(
          () => ItemModel.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });

      test(
          'should create ItemModel from JSON with int and string types correctly',
          () {
        final json = {
          'id': 42,
          'title': 'Valid Title',
          'subtitle': 'Valid Subtitle',
          'image': 'https://valid.url/image.jpg',
          'buttonText': 'Valid Button',
        };

        final itemModel = ItemModel.fromJson(json);

        expect(itemModel.id, equals(42));
        expect(itemModel.title, equals('Valid Title'));
        expect(itemModel.subtitle, equals('Valid Subtitle'));
        expect(itemModel.imageUrl, equals('https://valid.url/image.jpg'));
        expect(itemModel.buttonText, equals('Valid Button'));
      });
    });

    group('properties', () {
      late ItemModel itemModel;

      setUp(() {
        itemModel = ItemModel(
          id: testId,
          title: testTitle,
          subtitle: testSubtitle,
          imageUrl: testImageUrl,
          buttonText: testButtonText,
        );
      });

      test('should have immutable properties', () {
        expect(itemModel.id, equals(testId));
        expect(itemModel.title, equals(testTitle));
        expect(itemModel.subtitle, equals(testSubtitle));
        expect(itemModel.imageUrl, equals(testImageUrl));
        expect(itemModel.buttonText, equals(testButtonText));
      });

      test('should maintain property values after creation', () {
        final originalId = itemModel.id;
        final originalTitle = itemModel.title;
        final originalSubtitle = itemModel.subtitle;
        final originalImageUrl = itemModel.imageUrl;
        final originalButtonText = itemModel.buttonText;

        expect(itemModel.id, equals(originalId));
        expect(itemModel.title, equals(originalTitle));
        expect(itemModel.subtitle, equals(originalSubtitle));
        expect(itemModel.imageUrl, equals(originalImageUrl));
        expect(itemModel.buttonText, equals(originalButtonText));
      });
    });

    group('edge cases', () {
      test('should handle very large id values', () {
        const largeId = 9223372036854775807;

        final itemModel = ItemModel(
          id: largeId,
          title: testTitle,
          subtitle: testSubtitle,
          imageUrl: testImageUrl,
          buttonText: testButtonText,
        );

        expect(itemModel.id, equals(largeId));
      });

      test('should handle unicode characters in all fields', () {
        const unicodeTitle = '测试标题 タイトル عنوان';
        const unicodeSubtitle = '副标题 サブタイトル العنوان الفرعي';
        const unicodeUrl = 'https://测试.com/图像.jpg';
        const unicodeButton = '按钮 ボタン زر';

        final itemModel = ItemModel(
          id: testId,
          title: unicodeTitle,
          subtitle: unicodeSubtitle,
          imageUrl: unicodeUrl,
          buttonText: unicodeButton,
        );

        expect(itemModel.title, equals(unicodeTitle));
        expect(itemModel.subtitle, equals(unicodeSubtitle));
        expect(itemModel.imageUrl, equals(unicodeUrl));
        expect(itemModel.buttonText, equals(unicodeButton));
      });

      test('should handle newline characters', () {
        const titleWithNewlines = 'Title\nwith\nline\nbreaks';
        const subtitleWithNewlines = 'Subtitle\r\nwith\r\ncarriage\r\nreturns';

        final itemModel = ItemModel(
          id: testId,
          title: titleWithNewlines,
          subtitle: subtitleWithNewlines,
          imageUrl: testImageUrl,
          buttonText: testButtonText,
        );

        expect(itemModel.title, equals(titleWithNewlines));
        expect(itemModel.subtitle, equals(subtitleWithNewlines));
      });
    });

    group('multiple instances', () {
      test('should create multiple different instances', () {
        final itemModel1 = ItemModel(
          id: 1,
          title: 'Title 1',
          subtitle: 'Subtitle 1',
          imageUrl: 'url1.jpg',
          buttonText: 'Button 1',
        );

        final itemModel2 = ItemModel(
          id: 2,
          title: 'Title 2',
          subtitle: 'Subtitle 2',
          imageUrl: 'url2.jpg',
          buttonText: 'Button 2',
        );

        expect(itemModel1.id, equals(1));
        expect(itemModel2.id, equals(2));
        expect(itemModel1.title, equals('Title 1'));
        expect(itemModel2.title, equals('Title 2'));
        expect(itemModel1.id, isNot(equals(itemModel2.id)));
        expect(itemModel1.title, isNot(equals(itemModel2.title)));
      });

      test('should create multiple instances from different JSON sources', () {
        final json1 = {
          'id': 1,
          'title': 'JSON Title 1',
          'subtitle': 'JSON Subtitle 1',
          'image': 'json1.jpg',
          'buttonText': 'JSON Button 1',
        };

        final json2 = {
          'id': 2,
          'title': 'JSON Title 2',
          'subtitle': 'JSON Subtitle 2',
          'image': 'json2.jpg',
          'buttonText': 'JSON Button 2',
        };

        final itemModel1 = ItemModel.fromJson(json1);
        final itemModel2 = ItemModel.fromJson(json2);

        expect(itemModel1.id, equals(1));
        expect(itemModel2.id, equals(2));
        expect(itemModel1.title, isNot(equals(itemModel2.title)));
        expect(itemModel1.imageUrl, isNot(equals(itemModel2.imageUrl)));
      });
    });
  });
}
