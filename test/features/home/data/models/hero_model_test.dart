import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_animation_app/features/home/data/models/hero_model.dart';

void main() {
  group('HeroModel', () {
    test('should create instance with required id only', () {
      const hero = HeroModel(id: 1);

      expect(hero.id, equals(1));
      expect(hero.name, isNull);
      expect(hero.description, isNull);
      expect(hero.thumbnail, isNull);
      expect(hero.aliases, isNull);
      expect(hero.height, isNull);
      expect(hero.weight, isNull);
    });

    test('should create instance with all string parameters', () {
      const hero = HeroModel(
        id: 1,
        name: 'Spider-Man',
        description: 'Friendly neighborhood hero',
        thumbnail: 'https://example.com/spiderman.jpg',
        fullName: 'Peter Parker',
        publisher: 'Marvel Comics',
        alignment: 'good',
        gender: 'Male',
        race: 'Human',
        occupation: 'Student',
        intelligence: '90',
        strength: '55',
        speed: '67',
        durability: '75',
        power: '74',
        combat: '85',
        groupAffiliation: 'Avengers',
        relatives: 'Aunt May',
        placeOfBirth: 'New York',
        firstAppearance: 'Amazing Fantasy #15',
        alterEgos: 'No alter egos found',
        eyeColor: 'Hazel',
        hairColor: 'Brown',
        base: 'New York',
      );

      expect(hero.id, equals(1));
      expect(hero.name, equals('Spider-Man'));
      expect(hero.description, equals('Friendly neighborhood hero'));
      expect(hero.thumbnail, equals('https://example.com/spiderman.jpg'));
      expect(hero.fullName, equals('Peter Parker'));
      expect(hero.publisher, equals('Marvel Comics'));
      expect(hero.alignment, equals('good'));
      expect(hero.gender, equals('Male'));
      expect(hero.race, equals('Human'));
      expect(hero.occupation, equals('Student'));
      expect(hero.intelligence, equals('90'));
      expect(hero.strength, equals('55'));
      expect(hero.speed, equals('67'));
      expect(hero.durability, equals('75'));
      expect(hero.power, equals('74'));
      expect(hero.combat, equals('85'));
      expect(hero.groupAffiliation, equals('Avengers'));
      expect(hero.relatives, equals('Aunt May'));
      expect(hero.placeOfBirth, equals('New York'));
      expect(hero.firstAppearance, equals('Amazing Fantasy #15'));
      expect(hero.alterEgos, equals('No alter egos found'));
      expect(hero.eyeColor, equals('Hazel'));
      expect(hero.hairColor, equals('Brown'));
      expect(hero.base, equals('New York'));
    });

    test('should create instance with list parameters', () {
      const hero = HeroModel(
        id: 2,
        name: 'Batman',
        aliases: [
          'Dark Knight',
          'Caped Crusader',
          'World\'s Greatest Detective'
        ],
        height: ['6\'2"', '188 cm'],
        weight: ['210 lb', '95 kg'],
      );

      expect(hero.id, equals(2));
      expect(hero.name, equals('Batman'));
      expect(
          hero.aliases,
          equals([
            'Dark Knight',
            'Caped Crusader',
            'World\'s Greatest Detective'
          ]));
      expect(hero.height, equals(['6\'2"', '188 cm']));
      expect(hero.weight, equals(['210 lb', '95 kg']));
    });

    test('should create instance with empty lists', () {
      const hero = HeroModel(
        id: 3,
        aliases: <String>[],
        height: <String>[],
        weight: <String>[],
      );

      expect(hero.id, equals(3));
      expect(hero.aliases, isEmpty);
      expect(hero.height, isEmpty);
      expect(hero.weight, isEmpty);
    });

    test('should handle zero and negative id values', () {
      const heroZero = HeroModel(id: 0);
      const heroNegative = HeroModel(id: -1);

      expect(heroZero.id, equals(0));
      expect(heroNegative.id, equals(-1));
    });

    test('should handle large id values', () {
      const hero = HeroModel(id: 999999999);

      expect(hero.id, equals(999999999));
    });

    test('should handle empty strings', () {
      const hero = HeroModel(
        id: 1,
        name: '',
        description: '',
        thumbnail: '',
        fullName: '',
      );

      expect(hero.name, equals(''));
      expect(hero.description, equals(''));
      expect(hero.thumbnail, equals(''));
      expect(hero.fullName, equals(''));
    });

    test('should handle special characters in strings', () {
      const hero = HeroModel(
        id: 1,
        name: 'X-Men: Wolverine™',
        description: 'Hero with "claws" & healing factor',
        placeOfBirth: 'Alberta, Canada',
      );

      expect(hero.name, equals('X-Men: Wolverine™'));
      expect(hero.description, equals('Hero with "claws" & healing factor'));
      expect(hero.placeOfBirth, equals('Alberta, Canada'));
    });

    group('copyWith', () {
      late HeroModel originalHero;

      setUp(() {
        originalHero = const HeroModel(
          id: 1,
          name: 'Spider-Man',
          description: 'Friendly neighborhood hero',
          thumbnail: 'https://example.com/spiderman.jpg',
          fullName: 'Peter Parker',
          aliases: ['Spidey', 'Web-Slinger'],
          height: ['5\'10"', '178 cm'],
          weight: ['167 lb', '76 kg'],
        );
      });

      test('should return same instance when no parameters provided', () {
        final copiedHero = originalHero.copyWith();

        expect(copiedHero.id, equals(originalHero.id));
        expect(copiedHero.name, equals(originalHero.name));
        expect(copiedHero.description, equals(originalHero.description));
        expect(copiedHero.thumbnail, equals(originalHero.thumbnail));
        expect(copiedHero.fullName, equals(originalHero.fullName));
        expect(copiedHero.aliases, equals(originalHero.aliases));
        expect(copiedHero.height, equals(originalHero.height));
        expect(copiedHero.weight, equals(originalHero.weight));
      });

      test('should update only id when provided', () {
        const newId = 999;
        final copiedHero = originalHero.copyWith(id: newId);

        expect(copiedHero.id, equals(newId));
        expect(copiedHero.name, equals(originalHero.name));
        expect(copiedHero.description, equals(originalHero.description));
      });

      test('should update string fields individually', () {
        const newName = 'Amazing Spider-Man';
        const newDescription = 'Updated hero description';

        final copiedHero = originalHero.copyWith(
          name: newName,
          description: newDescription,
        );

        expect(copiedHero.name, equals(newName));
        expect(copiedHero.description, equals(newDescription));
        expect(copiedHero.id, equals(originalHero.id));
        expect(copiedHero.thumbnail, equals(originalHero.thumbnail));
      });

      test('should update all character stats', () {
        final copiedHero = originalHero.copyWith(
          intelligence: '100',
          strength: '60',
          speed: '70',
          durability: '80',
          power: '85',
          combat: '90',
        );

        expect(copiedHero.intelligence, equals('100'));
        expect(copiedHero.strength, equals('60'));
        expect(copiedHero.speed, equals('70'));
        expect(copiedHero.durability, equals('80'));
        expect(copiedHero.power, equals('85'));
        expect(copiedHero.combat, equals('90'));
      });

      test('should update all personal info fields', () {
        final copiedHero = originalHero.copyWith(
          fullName: 'Peter Benjamin Parker',
          publisher: 'Marvel Comics',
          alignment: 'good',
          gender: 'Male',
          race: 'Human',
          occupation: 'Photographer',
        );

        expect(copiedHero.fullName, equals('Peter Benjamin Parker'));
        expect(copiedHero.publisher, equals('Marvel Comics'));
        expect(copiedHero.alignment, equals('good'));
        expect(copiedHero.gender, equals('Male'));
        expect(copiedHero.race, equals('Human'));
        expect(copiedHero.occupation, equals('Photographer'));
      });

      test('should update all relationship and origin fields', () {
        final copiedHero = originalHero.copyWith(
          groupAffiliation: 'Avengers, Fantastic Four',
          relatives: 'Aunt May, Uncle Ben',
          placeOfBirth: 'Forest Hills, Queens, New York',
          firstAppearance: 'Amazing Fantasy #15 (1962)',
          alterEgos: 'No alter egos found',
        );

        expect(copiedHero.groupAffiliation, equals('Avengers, Fantastic Four'));
        expect(copiedHero.relatives, equals('Aunt May, Uncle Ben'));
        expect(
            copiedHero.placeOfBirth, equals('Forest Hills, Queens, New York'));
        expect(
            copiedHero.firstAppearance, equals('Amazing Fantasy #15 (1962)'));
        expect(copiedHero.alterEgos, equals('No alter egos found'));
      });

      test('should update physical appearance fields', () {
        final copiedHero = originalHero.copyWith(
          eyeColor: 'Hazel',
          hairColor: 'Brown',
          base: 'New York City',
        );

        expect(copiedHero.eyeColor, equals('Hazel'));
        expect(copiedHero.hairColor, equals('Brown'));
        expect(copiedHero.base, equals('New York City'));
      });

      test('should update list fields', () {
        const newAliases = ['Spider', 'Wall-Crawler', 'Web-Head'];
        const newHeight = ['5\'10"', '177 cm'];
        const newWeight = ['165 lb', '75 kg'];

        final copiedHero = originalHero.copyWith(
          aliases: newAliases,
          height: newHeight,
          weight: newWeight,
        );

        expect(copiedHero.aliases, equals(newAliases));
        expect(copiedHero.height, equals(newHeight));
        expect(copiedHero.weight, equals(newWeight));
      });

      test('should update multiple fields at once', () {
        const newId = 2;
        const newName = 'Iron Man';
        const newAliases = ['Tony Stark', 'Shellhead'];

        final copiedHero = originalHero.copyWith(
          id: newId,
          name: newName,
          aliases: newAliases,
        );

        expect(copiedHero.id, equals(newId));
        expect(copiedHero.name, equals(newName));
        expect(copiedHero.aliases, equals(newAliases));
        expect(copiedHero.description, equals(originalHero.description));
      });

      test('should handle null list updates', () {
        final copiedHero = originalHero.copyWith(
          aliases: null,
          height: null,
          weight: null,
        );

        // Due to the copyWith implementation using ?? operator,
        // passing null explicitly will maintain the original values
        expect(copiedHero.aliases, equals(originalHero.aliases));
        expect(copiedHero.height, equals(originalHero.height));
        expect(copiedHero.weight, equals(originalHero.weight));
      });

      test('should handle empty list updates', () {
        final copiedHero = originalHero.copyWith(
          aliases: const <String>[],
          height: const <String>[],
          weight: const <String>[],
        );

        expect(copiedHero.aliases, isEmpty);
        expect(copiedHero.height, isEmpty);
        expect(copiedHero.weight, isEmpty);
      });

      test('should update from null to non-null values', () {
        const heroWithNulls = HeroModel(id: 1);

        final updatedHero = heroWithNulls.copyWith(
          name: 'New Hero',
          aliases: ['Alias1', 'Alias2'],
          intelligence: '85',
        );

        expect(updatedHero.name, equals('New Hero'));
        expect(updatedHero.aliases, equals(['Alias1', 'Alias2']));
        expect(updatedHero.intelligence, equals('85'));
      });

      test('should handle string field null updates', () {
        final copiedHero = originalHero.copyWith(
          name: null,
          description: null,
          thumbnail: null,
        );

        // Due to the copyWith implementation using ?? operator,
        // passing null explicitly will maintain the original values
        expect(copiedHero.name, equals(originalHero.name));
        expect(copiedHero.description, equals(originalHero.description));
        expect(copiedHero.thumbnail, equals(originalHero.thumbnail));
      });
    });

    group('edge cases', () {
      test('should handle very long strings', () {
        final longString = 'A' * 1000;
        final hero = HeroModel(
          id: 1,
          name: longString,
          description: longString,
        );

        expect(hero.name?.length, equals(1000));
        expect(hero.description?.length, equals(1000));
      });

      test('should handle unicode and special characters', () {
        const hero = HeroModel(
          id: 1,
          name: '🕷️ Spider-Man 蜘蛛侠',
          description: 'Hero with émojis and ñ characters',
          placeOfBirth: 'New York 🏙️',
        );

        expect(hero.name, equals('🕷️ Spider-Man 蜘蛛侠'));
        expect(hero.description, equals('Hero with émojis and ñ characters'));
        expect(hero.placeOfBirth, equals('New York 🏙️'));
      });

      test('should handle lists with duplicate values', () {
        const hero = HeroModel(
          id: 1,
          aliases: ['Spider-Man', 'Spider-Man', 'Spidey'],
          height: ['5\'10"', '5\'10"'],
        );

        expect(hero.aliases, equals(['Spider-Man', 'Spider-Man', 'Spidey']));
        expect(hero.height, equals(['5\'10"', '5\'10"']));
      });

      test('should handle lists with empty strings', () {
        const hero = HeroModel(
          id: 1,
          aliases: ['', 'Spider-Man', ''],
          height: ['', '5\'10"'],
        );

        expect(hero.aliases, equals(['', 'Spider-Man', '']));
        expect(hero.height, equals(['', '5\'10"']));
      });

      test('should handle mixed case and whitespace in strings', () {
        const hero = HeroModel(
          id: 1,
          name: '  Spider-MAN  ',
          alignment: 'Good',
          gender: 'MALE',
          race: 'human',
        );

        expect(hero.name, equals('  Spider-MAN  '));
        expect(hero.alignment, equals('Good'));
        expect(hero.gender, equals('MALE'));
        expect(hero.race, equals('human'));
      });

      test('should work with copyWith chain operations', () {
        const original = HeroModel(id: 1, name: 'Hero');

        final result = original
            .copyWith(name: 'Updated Hero')
            .copyWith(description: 'New description')
            .copyWith(id: 2);

        expect(result.id, equals(2));
        expect(result.name, equals('Updated Hero'));
        expect(result.description, equals('New description'));
      });

      test('should handle numeric string stats correctly', () {
        const hero = HeroModel(
          id: 1,
          intelligence: '0',
          strength: '100',
          speed: '50.5',
          durability: 'Unknown',
          power: 'null',
          combat: '',
        );

        expect(hero.intelligence, equals('0'));
        expect(hero.strength, equals('100'));
        expect(hero.speed, equals('50.5'));
        expect(hero.durability, equals('Unknown'));
        expect(hero.power, equals('null'));
        expect(hero.combat, equals(''));
      });
    });

    group('complex scenarios', () {
      test('should handle complete hero data', () {
        const hero = HeroModel(
          id: 149,
          name: 'Spider-Man',
          description: 'Peter Parker was bitten by a radioactive spider...',
          thumbnail:
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
          groupAffiliation: 'Daily Bugle, Avengers, New Avengers',
          relatives: 'Richard Parker (father), Mary Parker (mother)',
          placeOfBirth: 'New York, New York',
          firstAppearance: 'Amazing Fantasy #15',
          alterEgos: 'No alter egos found',
          aliases: ['Spidey', 'Web-Slinger', 'Wall-Crawler', 'Web-Head'],
          height: ['5\'10"', '178 cm'],
          weight: ['167 lb', '76 kg'],
          eyeColor: 'Hazel',
          hairColor: 'Brown',
          base: 'New York, New York',
        );

        expect(hero.id, equals(149));
        expect(hero.aliases?.length, equals(4));
        expect(hero.height?.length, equals(2));
        expect(hero.weight?.length, equals(2));
        expect(hero.intelligence, equals('90'));
      });

      test('should handle minimal hero data', () {
        const hero = HeroModel(
          id: 1,
          name: 'Unknown Hero',
        );

        expect(hero.id, equals(1));
        expect(hero.name, equals('Unknown Hero'));
        expect(hero.description, isNull);
        expect(hero.aliases, isNull);
        expect(hero.intelligence, isNull);
      });

      test('should maintain data integrity with multiple copyWith operations',
          () {
        const original = HeroModel(
          id: 1,
          name: 'Original',
          aliases: ['Alias1'],
        );

        final step1 = original.copyWith(name: 'Step1');
        final step2 = step1.copyWith(description: 'Step2 description');
        final step3 = step2.copyWith(aliases: ['New1', 'New2']);

        expect(original.name, equals('Original'));
        expect(step1.name, equals('Step1'));
        expect(step1.description, isNull);
        expect(step2.description, equals('Step2 description'));
        expect(step3.aliases, equals(['New1', 'New2']));
      });
    });
  });
}
