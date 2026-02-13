import 'package:flutter_test/flutter_test.dart';
import 'package:aurabus/features/legal/data/legal_section.dart';

void main() {
  group('LegalSection Model', () {
    test('creates instance with required fields', () {
      const section = LegalSection(
        title: 'Test Title',
        body: 'Test Body Content',
      );

      expect(section.title, 'Test Title');
      expect(section.body, 'Test Body Content');
    });

    test('supports const constructor', () {
      const section1 = LegalSection(title: 'A', body: 'B');
      const section2 = LegalSection(title: 'A', body: 'B');

      expect(identical(section1, section2), isTrue);
    });

    test('different instances are not identical', () {
      const section1 = LegalSection(title: 'A', body: 'B');
      const section2 = LegalSection(title: 'C', body: 'D');

      expect(section1.title, isNot(equals(section2.title)));
      expect(section1.body, isNot(equals(section2.body)));
    });

    test('handles empty strings', () {
      const section = LegalSection(title: '', body: '');

      expect(section.title, isEmpty);
      expect(section.body, isEmpty);
    });

    test('handles multiline body text', () {
      const section = LegalSection(
        title: 'Privacy',
        body: 'Line 1\nLine 2\nLine 3\n\n• Bullet point',
      );

      expect(section.body, contains('\n'));
      expect(section.body, contains('• Bullet point'));
    });

    test('handles special characters and unicode', () {
      const section = LegalSection(
        title: 'Termini & Condizioni',
        body:
            'Ai sensi del GDPR (Regolamento UE 2016/679) — diritto all\'oblio',
      );

      expect(section.title, contains('&'));
      expect(section.body, contains('—'));
      expect(section.body, contains('\''));
    });
  });
}
