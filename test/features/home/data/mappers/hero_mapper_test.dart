import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/features/home/data/mappers/hero_mapper.dart';
import 'package:marvel_animation_app/features/home/data/models/hero_model.dart';
import 'package:marvel_animation_app/features/home/domain/entities/hero.dart';

void main() {
  group('HeroMapper', () {
    group('fromJson', () {
      test('should create HeroModel from complete valid JSON', () {
        final json = {
          'id': '1',
          'name': 'Spider-Man',
          'biography': {
            'full-name': 'Peter Benjamin Parker',
            'publisher': 'Marvel Comics',
            'alignment': 'good',
            'place-of-birth': 'Queens, New York',
            'first-appearance': 'Amazing Fantasy #15',
            'alter-egos': 'No alter egos found.',
            'aliases': ['Spidey', 'Web-Slinger', 'Wall-Crawler']
          },
          'appearance': {
            'gender': 'Male',
            'race': 'Human',
            'height': ['5\'10', '178 cm'],
            'weight': ['167 lb', '76 kg'],
            'eye-color': 'Hazel',
            'hair-color': 'Brown'
          },
          'work': {
            'occupation': 'Photographer, teacher, scientist',
            'base': 'New York'
          },
          'powerstats': {
            'intelligence': '90',
            'strength': '55',
            'speed': '67',
            'durability': '75',
            'power': '74',
            'combat': '85'
          },
          'connections': {
            'group-affiliation': 'Avengers, Fantastic Four',
            'relatives': 'Richard Parker (father), Mary Parker (mother)'
          },
          'image': {
            'url':
                'https://www.superherodb.com/pictures2/portraits/10/100/133.jpg'
          }
        };

        final result = HeroMapper.fromJson(json);

        expect(result.id, equals(1));
        expect(result.name, equals('Spider-Man'));
        expect(result.description, equals('Peter Benjamin Parker'));
        expect(
            result.thumbnail,
            equals(
                'https://www.superherodb.com/pictures2/portraits/10/100/133.jpg'));
        expect(result.fullName, equals('Peter Benjamin Parker'));
        expect(result.publisher, equals('Marvel Comics'));
        expect(result.alignment, equals('good'));
        expect(result.gender, equals('Male'));
        expect(result.race, equals('Human'));
        expect(result.occupation, equals('Photographer, teacher, scientist'));
        expect(result.intelligence, equals('90'));
        expect(result.strength, equals('55'));
        expect(result.speed, equals('67'));
        expect(result.durability, equals('75'));
        expect(result.power, equals('74'));
        expect(result.combat, equals('85'));
        expect(result.groupAffiliation, equals('Avengers, Fantastic Four'));
        expect(result.relatives,
            equals('Richard Parker (father), Mary Parker (mother)'));
        expect(result.placeOfBirth, equals('Queens, New York'));
        expect(result.firstAppearance, equals('Amazing Fantasy #15'));
        expect(result.alterEgos, equals('No alter egos found.'));
        expect(
            result.aliases, equals(['Spidey', 'Web-Slinger', 'Wall-Crawler']));
        expect(result.height, equals(['5\'10', '178 cm']));
        expect(result.weight, equals(['167 lb', '76 kg']));
        expect(result.eyeColor, equals('Hazel'));
        expect(result.hairColor, equals('Brown'));
        expect(result.base, equals('New York'));
      });

      test('should create HeroModel with minimal JSON data', () {
        final json = {
          'id': '2',
          'name': 'Batman',
        };

        final result = HeroMapper.fromJson(json);

        expect(result.id, equals(2));
        expect(result.name, equals('Batman'));
        expect(result.description, equals('Batman'));
        expect(result.thumbnail, equals(''));
        expect(result.fullName, isNull);
        expect(result.publisher, isNull);
        expect(result.alignment, isNull);
        expect(result.intelligence, equals('0'));
        expect(result.strength, equals('0'));
        expect(result.speed, equals('0'));
        expect(result.durability, equals('0'));
        expect(result.power, equals('0'));
        expect(result.combat, equals('0'));
      });

      test('should handle null and missing values gracefully', () {
        final json = {
          'id': null,
          'name': null,
          'biography': null,
          'appearance': null,
          'work': null,
          'powerstats': null,
          'connections': null,
          'image': null,
        };

        final result = HeroMapper.fromJson(json);

        expect(result.id, equals(0));
        expect(result.name, equals('Unknown Hero'));
        expect(result.description, isNull);
        expect(result.thumbnail, equals(''));
        expect(result.intelligence, equals('0'));
        expect(result.strength, equals('0'));
        expect(result.speed, equals('0'));
        expect(result.durability, equals('0'));
        expect(result.power, equals('0'));
        expect(result.combat, equals('0'));
      });

      test('should parse string ID correctly', () {
        final json = {
          'id': '999',
          'name': 'Test Hero',
        };

        final result = HeroMapper.fromJson(json);

        expect(result.id, equals(999));
        expect(result.name, equals('Test Hero'));
      });

      test('should parse integer ID correctly', () {
        final json = {
          'id': 777,
          'name': 'Test Hero',
        };

        final result = HeroMapper.fromJson(json);

        expect(result.id, equals(777));
        expect(result.name, equals('Test Hero'));
      });

      test('should handle invalid ID gracefully', () {
        final json = {
          'id': 'invalid-id',
          'name': 'Test Hero',
        };

        final result = HeroMapper.fromJson(json);

        expect(result.id, equals(0));
        expect(result.name, equals('Test Hero'));
      });

      test('should handle empty nested objects', () {
        final json = {
          'id': '1',
          'name': 'Test Hero',
          'biography': {},
          'appearance': {},
          'work': {},
          'powerstats': {},
          'connections': {},
          'image': {},
        };

        final result = HeroMapper.fromJson(json);

        expect(result.id, equals(1));
        expect(result.name, equals('Test Hero'));
        expect(result.description, equals('Test Hero'));
        expect(result.thumbnail, equals(''));
        expect(result.fullName, isNull);
        expect(result.publisher, isNull);
        expect(result.intelligence, equals('0'));
      });

      test('should handle arrays with null values', () {
        final json = {
          'id': '1',
          'name': 'Test Hero',
          'biography': {
            'aliases': null,
          },
          'appearance': {
            'height': null,
            'weight': null,
          },
        };

        final result = HeroMapper.fromJson(json);

        expect(result.aliases, isNull);
        expect(result.height, isNull);
        expect(result.weight, isNull);
      });

      test('should convert arrays correctly when present', () {
        final json = {
          'id': '1',
          'name': 'Test Hero',
          'biography': {
            'aliases': ['Alias1', 'Alias2', 'Alias3'],
          },
          'appearance': {
            'height': ['6\'0', '183 cm'],
            'weight': ['200 lb', '91 kg'],
          },
        };

        final result = HeroMapper.fromJson(json);

        expect(result.aliases, equals(['Alias1', 'Alias2', 'Alias3']));
        expect(result.height, equals(['6\'0', '183 cm']));
        expect(result.weight, equals(['200 lb', '91 kg']));
      });

      test('should handle malformed arrays gracefully', () {
        final json = {
          'id': '1',
          'name': 'Test Hero',
          'biography': {
            'aliases': 'not-an-array',
          },
          'appearance': {
            'height': 123,
            'weight': {'invalid': 'object'},
          },
        };

        expect(() => HeroMapper.fromJson(json), throwsA(isA<TypeError>()));
      });
    });

    group('fromJsonList', () {
      test('should convert list of JSON to list of HeroModel', () {
        final jsonList = [
          {
            'id': '1',
            'name': 'Hero One',
            'biography': {'full-name': 'Full Hero One'},
          },
          {
            'id': '2',
            'name': 'Hero Two',
            'biography': {'full-name': 'Full Hero Two'},
          },
          {
            'id': '3',
            'name': 'Hero Three',
          },
        ];

        final result = HeroMapper.fromJsonList(jsonList);

        expect(result, hasLength(3));
        expect(result[0].id, equals(1));
        expect(result[0].name, equals('Hero One'));
        expect(result[0].fullName, equals('Full Hero One'));
        expect(result[1].id, equals(2));
        expect(result[1].name, equals('Hero Two'));
        expect(result[1].fullName, equals('Full Hero Two'));
        expect(result[2].id, equals(3));
        expect(result[2].name, equals('Hero Three'));
        expect(result[2].fullName, isNull);
      });

      test('should handle empty list', () {
        final result = HeroMapper.fromJsonList([]);

        expect(result, isEmpty);
      });

      test('should handle list with null elements', () {
        final jsonList = [
          {
            'id': '1',
            'name': 'Valid Hero',
          },
          null,
        ];

        expect(
            () => HeroMapper.fromJsonList(jsonList), throwsA(isA<TypeError>()));
      });
    });

    group('_parseStatValue', () {
      test('should parse valid integer strings correctly', () {
        final json = {
          'id': '1',
          'name': 'Test Hero',
          'powerstats': {
            'intelligence': '85',
            'strength': '100',
            'speed': '0',
            'durability': '50',
          },
        };

        final result = HeroMapper.fromJson(json);

        expect(result.intelligence, equals('85'));
        expect(result.strength, equals('100'));
        expect(result.speed, equals('0'));
        expect(result.durability, equals('50'));
      });

      test('should handle null stat values', () {
        final json = {
          'id': '1',
          'name': 'Test Hero',
          'powerstats': {
            'intelligence': null,
            'strength': null,
          },
        };

        final result = HeroMapper.fromJson(json);

        expect(result.intelligence, equals('0'));
        expect(result.strength, equals('0'));
      });

      test('should handle "null" string stat values', () {
        final json = {
          'id': '1',
          'name': 'Test Hero',
          'powerstats': {
            'intelligence': 'null',
            'strength': 'null',
          },
        };

        final result = HeroMapper.fromJson(json);

        expect(result.intelligence, equals('0'));
        expect(result.strength, equals('0'));
      });

      test('should handle dash "-" stat values', () {
        final json = {
          'id': '1',
          'name': 'Test Hero',
          'powerstats': {
            'intelligence': '-',
            'strength': '-',
          },
        };

        final result = HeroMapper.fromJson(json);

        expect(result.intelligence, equals('0'));
        expect(result.strength, equals('0'));
      });

      test('should handle out of range values', () {
        final json = {
          'id': '1',
          'name': 'Test Hero',
          'powerstats': {
            'intelligence': '150',
            'strength': '-10',
            'speed': '101',
            'durability': '-1',
          },
        };

        final result = HeroMapper.fromJson(json);

        expect(result.intelligence, equals('0'));
        expect(result.strength, equals('0'));
        expect(result.speed, equals('0'));
        expect(result.durability, equals('0'));
      });

      test('should handle non-numeric stat values', () {
        final json = {
          'id': '1',
          'name': 'Test Hero',
          'powerstats': {
            'intelligence': 'high',
            'strength': 'very strong',
            'speed': 'fast',
          },
        };

        final result = HeroMapper.fromJson(json);

        expect(result.intelligence, equals('0'));
        expect(result.strength, equals('0'));
        expect(result.speed, equals('0'));
      });

      test('should handle integer stat values', () {
        final json = {
          'id': '1',
          'name': 'Test Hero',
          'powerstats': {
            'intelligence': 90,
            'strength': 75,
            'speed': 60,
          },
        };

        final result = HeroMapper.fromJson(json);

        expect(result.intelligence, equals('90'));
        expect(result.strength, equals('75'));
        expect(result.speed, equals('60'));
      });
    });

    group('toEntity', () {
      test('should convert HeroModel to Hero entity correctly', () {
        const heroModel = HeroModel(
          id: 1,
          name: 'Wonder Woman',
          description: 'Princess Diana of Themyscira',
          thumbnail: 'https://example.com/wonder-woman.jpg',
          fullName: 'Princess Diana',
          publisher: 'DC Comics',
          alignment: 'good',
          gender: 'Female',
          race: 'Amazon',
          occupation: 'Adventurer, Diplomat',
          intelligence: '88',
          strength: '100',
          speed: '79',
          durability: '100',
          power: '100',
          combat: '100',
          groupAffiliation: 'Justice League',
          relatives: 'Queen Hippolyta (mother)',
          placeOfBirth: 'Themyscira',
          firstAppearance: 'All Star Comics #8',
          alterEgos: 'No alter egos found.',
          aliases: ['Diana Prince', 'Wonder Girl'],
          height: ['6\'0', '183 cm'],
          weight: ['165 lb', '74 kg'],
          eyeColor: 'Blue',
          hairColor: 'Black',
          base: 'Themyscira, Gateway City',
        );

        final result = HeroMapper.toEntity(heroModel);

        expect(result.id, equals(1));
        expect(result.name, equals('Wonder Woman'));
        expect(result.description, equals('Princess Diana of Themyscira'));
        expect(result.picture, equals('https://example.com/wonder-woman.jpg'));
        expect(result.fullName, equals('Princess Diana'));
        expect(result.publisher, equals('DC Comics'));
        expect(result.alignment, equals('good'));
        expect(result.gender, equals('Female'));
        expect(result.race, equals('Amazon'));
        expect(result.occupation, equals('Adventurer, Diplomat'));
        expect(result.intelligence, equals('88'));
        expect(result.strength, equals('100'));
        expect(result.speed, equals('79'));
        expect(result.durability, equals('100'));
        expect(result.power, equals('100'));
        expect(result.combat, equals('100'));
        expect(result.groupAffiliation, equals('Justice League'));
        expect(result.relatives, equals('Queen Hippolyta (mother)'));
        expect(result.placeOfBirth, equals('Themyscira'));
        expect(result.firstAppearance, equals('All Star Comics #8'));
        expect(result.alterEgos, equals('No alter egos found.'));
        expect(result.aliases, equals(['Diana Prince', 'Wonder Girl']));
        expect(result.height, equals(['6\'0', '183 cm']));
        expect(result.weight, equals(['165 lb', '74 kg']));
        expect(result.eyeColor, equals('Blue'));
        expect(result.hairColor, equals('Black'));
        expect(result.base, equals('Themyscira, Gateway City'));
      });

      test('should convert HeroModel with minimal data to Hero entity', () {
        const heroModel = HeroModel(
          id: 2,
          name: null,
          description: null,
          thumbnail: null,
        );

        final result = HeroMapper.toEntity(heroModel);

        expect(result.id, equals(2));
        expect(result.name, equals('No Name'));
        expect(result.description, equals('No Description'));
        expect(result.picture, equals(''));
        expect(result.fullName, isNull);
        expect(result.publisher, isNull);
        expect(result.alignment, isNull);
        expect(result.gender, isNull);
        expect(result.race, isNull);
        expect(result.occupation, isNull);
        expect(result.intelligence, isNull);
        expect(result.strength, isNull);
        expect(result.speed, isNull);
        expect(result.durability, isNull);
        expect(result.power, isNull);
        expect(result.combat, isNull);
        expect(result.aliases, isNull);
        expect(result.height, isNull);
        expect(result.weight, isNull);
      });

      test('should handle HeroModel with all null values', () {
        const heroModel = HeroModel(
          id: 0,
          name: null,
          description: null,
          thumbnail: null,
          fullName: null,
          publisher: null,
          alignment: null,
          gender: null,
          race: null,
          occupation: null,
          intelligence: null,
          strength: null,
          speed: null,
          durability: null,
          power: null,
          combat: null,
          groupAffiliation: null,
          relatives: null,
          placeOfBirth: null,
          firstAppearance: null,
          alterEgos: null,
          aliases: null,
          height: null,
          weight: null,
          eyeColor: null,
          hairColor: null,
          base: null,
        );

        final result = HeroMapper.toEntity(heroModel);

        expect(result.id, equals(0));
        expect(result.name, equals('No Name'));
        expect(result.description, equals('No Description'));
        expect(result.picture, equals(''));
        expect(result.fullName, isNull);
        expect(result.publisher, isNull);
        expect(result.aliases, isNull);
        expect(result.height, isNull);
        expect(result.weight, isNull);
      });

      test('should preserve list data types correctly', () {
        const heroModel = HeroModel(
          id: 3,
          name: 'List Test Hero',
          description: 'Testing lists',
          thumbnail: 'test.jpg',
          aliases: ['Alias One', 'Alias Two', 'Alias Three'],
          height: ['5\'8', '173 cm'],
          weight: ['150 lb', '68 kg'],
        );

        final result = HeroMapper.toEntity(heroModel);

        expect(result.aliases, isA<List<String>>());
        expect(
            result.aliases, equals(['Alias One', 'Alias Two', 'Alias Three']));
        expect(result.height, isA<List<String>>());
        expect(result.height, equals(['5\'8', '173 cm']));
        expect(result.weight, isA<List<String>>());
        expect(result.weight, equals(['150 lb', '68 kg']));
      });
    });

    group('integration tests', () {
      test('should handle complete JSON to Entity workflow', () {
        final json = {
          'id': '42',
          'name': 'Integration Test Hero',
          'biography': {
            'full-name': 'Complete Integration Test Hero',
            'publisher': 'Test Comics',
            'alignment': 'neutral',
            'aliases': ['Test Hero', 'Integration Hero'],
          },
          'appearance': {
            'gender': 'Non-binary',
            'race': 'Alien',
            'height': ['7\'0', '213 cm'],
            'weight': ['300 lb', '136 kg'],
          },
          'work': {
            'occupation': 'Tester',
            'base': 'Test Facility',
          },
          'powerstats': {
            'intelligence': '95',
            'strength': '80',
            'speed': '70',
            'durability': '90',
            'power': '85',
            'combat': '75',
          },
          'image': {
            'url': 'https://test.com/integration-hero.jpg',
          },
        };

        final heroModel = HeroMapper.fromJson(json);

        final heroEntity = HeroMapper.toEntity(heroModel);

        expect(heroEntity.id, equals(42));
        expect(heroEntity.name, equals('Integration Test Hero'));
        expect(
            heroEntity.description, equals('Complete Integration Test Hero'));
        expect(heroEntity.picture,
            equals('https://test.com/integration-hero.jpg'));
        expect(heroEntity.publisher, equals('Test Comics'));
        expect(heroEntity.alignment, equals('neutral'));
        expect(heroEntity.gender, equals('Non-binary'));
        expect(heroEntity.race, equals('Alien'));
        expect(heroEntity.occupation, equals('Tester'));
        expect(heroEntity.intelligence, equals('95'));
        expect(heroEntity.strength, equals('80'));
        expect(heroEntity.aliases, equals(['Test Hero', 'Integration Hero']));
        expect(heroEntity.height, equals(['7\'0', '213 cm']));
        expect(heroEntity.weight, equals(['300 lb', '136 kg']));
      });

      test('should handle edge case data throughout complete workflow', () {
        final json = {
          'id': 'edge-case',
          'name': '',
          'biography': {
            'full-name': null,
            'aliases': [],
          },
          'powerstats': {
            'intelligence': '-',
            'strength': 'null',
            'speed': '999',
            'durability': null,
          },
          'image': {},
        };

        final heroModel = HeroMapper.fromJson(json);
        final heroEntity = HeroMapper.toEntity(heroModel);

        expect(heroEntity.id, equals(0));
        expect(heroEntity.name, isEmpty);
        expect(heroEntity.description, isEmpty);
        expect(heroEntity.picture, equals(''));
        expect(heroEntity.intelligence, equals('0'));
        expect(heroEntity.strength, equals('0'));
        expect(heroEntity.speed, equals('0'));
        expect(heroEntity.durability, equals('0'));
        expect(heroEntity.aliases, equals([]));
      });
    });

    group('error handling', () {
      test('should handle completely empty JSON object', () {
        final json = <String, dynamic>{};

        final result = HeroMapper.fromJson(json);

        expect(result.id, equals(0));
        expect(result.name, equals('Unknown Hero'));
        expect(result.description, isNull);
        expect(result.thumbnail, equals(''));
      });

      test('should handle JSON with unexpected data types', () {
        final json = {
          'id': {'unexpected': 'object'},
          'name': 12345,
          'biography': 'should-be-object',
          'powerstats': ['should-be-object'],
        };

        expect(() => HeroMapper.fromJson(json), throwsA(isA<TypeError>()));
      });
    });
  });
}
