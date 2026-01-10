import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/features/home/domain/entities/hero.dart';
import 'package:marvel_animation_app/features/home/presentation/mappers/hero_item_mapper.dart';
import 'package:marvel_animation_app/shared/domain/models/item_model.dart';

void main() {
  group('HeroToItemMapper', () {
    test('should map Hero to ItemModel correctly with all required fields', () {
      final hero = Hero(
        id: 1,
        name: 'Spider-Man',
        description: 'Friendly neighborhood spider hero',
        picture: 'https://example.com/spiderman.jpg',
      );

      final result = HeroToItemMapper.map(hero);

      expect(result, isA<ItemModel>());
      expect(result.id, equals(1));
      expect(result.title, equals('Spider-Man'));
      expect(result.subtitle, equals('Friendly neighborhood spider hero'));
      expect(result.imageUrl, equals('https://example.com/spiderman.jpg'));
      expect(result.buttonText, equals('SECRET PLACE'));
    });

    test('should map Hero with all optional fields', () {
      final hero = Hero(
        id: 149,
        name: 'Spider-Man',
        description: 'Peter Parker was bitten by a radioactive spider',
        picture:
            'https://www.superherodb.com/pictures2/portraits/10/100/133.jpg',
        fullName: 'Peter Benjamin Parker',
        publisher: 'Marvel Comics',
        alignment: 'good',
        gender: 'Male',
        race: 'Human',
        occupation: 'Photographer, teacher',
        intelligence: '90',
        strength: '55',
        speed: '67',
        durability: '75',
        power: '74',
        combat: '85',
      );

      final result = HeroToItemMapper.map(hero);

      expect(result.id, equals(149));
      expect(result.title, equals('Spider-Man'));
      expect(result.subtitle,
          equals('Peter Parker was bitten by a radioactive spider'));
      expect(
          result.imageUrl,
          equals(
              'https://www.superherodb.com/pictures2/portraits/10/100/133.jpg'));
      expect(result.buttonText, equals('SECRET PLACE'));
    });

    test('should map Hero with empty strings', () {
      final hero = Hero(
        id: 2,
        name: '',
        description: '',
        picture: '',
      );

      final result = HeroToItemMapper.map(hero);

      expect(result.id, equals(2));
      expect(result.title, equals(''));
      expect(result.subtitle, equals(''));
      expect(result.imageUrl, equals(''));
      expect(result.buttonText, equals('SECRET PLACE'));
    });

    test('should map Hero with special characters in strings', () {
      final hero = Hero(
        id: 3,
        name: 'X-Men: Wolverine™',
        description: 'Hero with "claws" & healing factor',
        picture: 'https://example.com/wolverine.jpg',
      );

      final result = HeroToItemMapper.map(hero);

      expect(result.id, equals(3));
      expect(result.title, equals('X-Men: Wolverine™'));
      expect(result.subtitle, equals('Hero with "claws" & healing factor'));
      expect(result.imageUrl, equals('https://example.com/wolverine.jpg'));
      expect(result.buttonText, equals('SECRET PLACE'));
    });

    test('should map Hero with unicode and emoji characters', () {
      final hero = Hero(
        id: 4,
        name: '🕷️ Spider-Man 蜘蛛侠',
        description: 'Hero with émojis and ñ characters',
        picture: 'https://example.com/spider-unicode.jpg',
      );

      final result = HeroToItemMapper.map(hero);

      expect(result.id, equals(4));
      expect(result.title, equals('🕷️ Spider-Man 蜘蛛侠'));
      expect(result.subtitle, equals('Hero with émojis and ñ characters'));
      expect(result.imageUrl, equals('https://example.com/spider-unicode.jpg'));
      expect(result.buttonText, equals('SECRET PLACE'));
    });

    test('should map Hero with very long strings', () {
      final longName = 'A' * 200;
      final longDescription = 'B' * 500;
      final longUrl = 'https://example.com/' + ('c' * 100) + '.jpg';

      final hero = Hero(
        id: 5,
        name: longName,
        description: longDescription,
        picture: longUrl,
      );

      final result = HeroToItemMapper.map(hero);

      expect(result.id, equals(5));
      expect(result.title, equals(longName));
      expect(result.subtitle, equals(longDescription));
      expect(result.imageUrl, equals(longUrl));
      expect(result.buttonText, equals('SECRET PLACE'));
    });

    test('should map Hero with zero id', () {
      final hero = Hero(
        id: 0,
        name: 'Hero Zero',
        description: 'Hero with zero id',
        picture: 'https://example.com/zero.jpg',
      );

      final result = HeroToItemMapper.map(hero);

      expect(result.id, equals(0));
      expect(result.title, equals('Hero Zero'));
      expect(result.subtitle, equals('Hero with zero id'));
      expect(result.imageUrl, equals('https://example.com/zero.jpg'));
      expect(result.buttonText, equals('SECRET PLACE'));
    });

    test('should map Hero with negative id', () {
      final hero = Hero(
        id: -1,
        name: 'Negative Hero',
        description: 'Hero with negative id',
        picture: 'https://example.com/negative.jpg',
      );

      final result = HeroToItemMapper.map(hero);

      expect(result.id, equals(-1));
      expect(result.title, equals('Negative Hero'));
      expect(result.subtitle, equals('Hero with negative id'));
      expect(result.imageUrl, equals('https://example.com/negative.jpg'));
      expect(result.buttonText, equals('SECRET PLACE'));
    });

    test('should map Hero with large id value', () {
      final hero = Hero(
        id: 999999999,
        name: 'Large ID Hero',
        description: 'Hero with large id',
        picture: 'https://example.com/large.jpg',
      );

      final result = HeroToItemMapper.map(hero);

      expect(result.id, equals(999999999));
      expect(result.title, equals('Large ID Hero'));
      expect(result.subtitle, equals('Hero with large id'));
      expect(result.imageUrl, equals('https://example.com/large.jpg'));
      expect(result.buttonText, equals('SECRET PLACE'));
    });

    test(
        'should always map buttonText to "SECRET PLACE" regardless of hero data',
        () {
      final heroes = [
        Hero(id: 1, name: 'Hero1', description: 'Desc1', picture: 'pic1'),
        Hero(id: 2, name: 'Hero2', description: 'Desc2', picture: 'pic2'),
        Hero(id: 3, name: 'Hero3', description: 'Desc3', picture: 'pic3'),
      ];

      for (final hero in heroes) {
        final result = HeroToItemMapper.map(hero);
        expect(result.buttonText, equals('SECRET PLACE'));
      }
    });

    test('should handle whitespace in hero data', () {
      final hero = Hero(
        id: 6,
        name: '  Iron Man  ',
        description: '  Genius billionaire playboy philanthropist  ',
        picture: '  https://example.com/ironman.jpg  ',
      );

      final result = HeroToItemMapper.map(hero);

      expect(result.id, equals(6));
      expect(result.title, equals('  Iron Man  '));
      expect(result.subtitle,
          equals('  Genius billionaire playboy philanthropist  '));
      expect(result.imageUrl, equals('  https://example.com/ironman.jpg  '));
      expect(result.buttonText, equals('SECRET PLACE'));
    });

    test('should map multiple different heroes correctly', () {
      final heroes = [
        Hero(
          id: 1,
          name: 'Spider-Man',
          description: 'Web slinger',
          picture: 'https://example.com/spiderman.jpg',
        ),
        Hero(
          id: 2,
          name: 'Iron Man',
          description: 'Genius in suit',
          picture: 'https://example.com/ironman.jpg',
        ),
        Hero(
          id: 3,
          name: 'Captain America',
          description: 'Super soldier',
          picture: 'https://example.com/cap.jpg',
        ),
      ];

      final results = heroes.map(HeroToItemMapper.map).toList();

      expect(results.length, equals(3));

      expect(results[0].id, equals(1));
      expect(results[0].title, equals('Spider-Man'));
      expect(results[0].subtitle, equals('Web slinger'));
      expect(results[0].imageUrl, equals('https://example.com/spiderman.jpg'));

      expect(results[1].id, equals(2));
      expect(results[1].title, equals('Iron Man'));
      expect(results[1].subtitle, equals('Genius in suit'));
      expect(results[1].imageUrl, equals('https://example.com/ironman.jpg'));

      expect(results[2].id, equals(3));
      expect(results[2].title, equals('Captain America'));
      expect(results[2].subtitle, equals('Super soldier'));
      expect(results[2].imageUrl, equals('https://example.com/cap.jpg'));

      for (final result in results) {
        expect(result.buttonText, equals('SECRET PLACE'));
      }
    });

    test('should preserve exact string content without modification', () {
      final hero = Hero(
        id: 7,
        name: 'Test\nNewline\tTab"Quote\'Single',
        description: 'Description with\nnewlines and\ttabs',
        picture: 'https://example.com/test?param=value&other=test',
      );

      final result = HeroToItemMapper.map(hero);

      expect(result.title, equals('Test\nNewline\tTab"Quote\'Single'));
      expect(result.subtitle, equals('Description with\nnewlines and\ttabs'));
      expect(result.imageUrl,
          equals('https://example.com/test?param=value&other=test'));
    });

    test(
        'should handle hero with list fields (aliases, height, weight) but only map basic fields',
        () {
      final hero = Hero(
        id: 8,
        name: 'Thor',
        description: 'God of Thunder',
        picture: 'https://example.com/thor.jpg',
        aliases: ['God of Thunder', 'Odinson'],
        height: ['6\'6"', '198 cm'],
        weight: ['640 lb', '290 kg'],
        fullName: 'Thor Odinson',
        publisher: 'Marvel Comics',
      );

      final result = HeroToItemMapper.map(hero);

      expect(result.id, equals(8));
      expect(result.title, equals('Thor'));
      expect(result.subtitle, equals('God of Thunder'));
      expect(result.imageUrl, equals('https://example.com/thor.jpg'));
      expect(result.buttonText, equals('SECRET PLACE'));
    });

    group('edge cases', () {
      test('should handle hero data with null character sequences', () {
        final hero = Hero(
          id: 9,
          name: 'Hero\u0000Name',
          description: 'Description\u0000with null',
          picture: 'https://example.com/null\u0000char.jpg',
        );

        final result = HeroToItemMapper.map(hero);

        expect(result.title, equals('Hero\u0000Name'));
        expect(result.subtitle, equals('Description\u0000with null'));
        expect(
            result.imageUrl, equals('https://example.com/null\u0000char.jpg'));
      });

      test('should handle different URL formats', () {
        final urlFormats = [
          'https://example.com/image.jpg',
          'http://example.com/image.png',
          'ftp://files.example.com/image.gif',
          '/local/path/image.jpg',
          'file:///absolute/path/image.jpg',
          'data:image/jpeg;base64,abc123',
          'assets/images/hero.png',
          '',
        ];

        for (int i = 0; i < urlFormats.length; i++) {
          final hero = Hero(
            id: i,
            name: 'Hero $i',
            description: 'Description $i',
            picture: urlFormats[i],
          );

          final result = HeroToItemMapper.map(hero);

          expect(result.imageUrl, equals(urlFormats[i]));
          expect(result.buttonText, equals('SECRET PLACE'));
        }
      });

      test('should create valid ItemModel even with minimal Hero data', () {
        final hero = Hero(
          id: 10,
          name: 'Minimal',
          description: 'Min',
          picture: 'pic',
        );

        final result = HeroToItemMapper.map(hero);

        expect(result, isA<ItemModel>());
        expect(result.id, equals(10));
        expect(result.title, equals('Minimal'));
        expect(result.subtitle, equals('Min'));
        expect(result.imageUrl, equals('pic'));
        expect(result.buttonText, equals('SECRET PLACE'));
      });
    });
  });
}
