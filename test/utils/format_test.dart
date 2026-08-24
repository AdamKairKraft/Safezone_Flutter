import 'package:flutter_test/flutter_test.dart';
import 'package:safezone_tablet/utils/format.dart';

void main() {
  group('humanize', () {
    test('title-cases snake_case codes', () {
      expect(humanize('TOOLBOX_TALK'), 'Toolbox Talk');
      expect(humanize('OVERDUE'), 'Overdue');
    });
  });

  group('reportSummary', () {
    test('uses the first non-empty summary field present in the data', () {
      expect(
        reportSummary('TOOLBOX_TALK', {'topic': 'Ladder safety', 'attendees': '9'}),
        'Ladder safety',
      );
    });

    test('falls back to a humanized report type code when no summary field is set', () {
      expect(reportSummary('TOOLBOX_TALK', {'attendees': '9'}), 'Toolbox Talk');
    });

    test('skips a blank higher-priority field and falls through to the next one', () {
      expect(reportSummary('INCIDENT', {'topic': '   ', 'description': 'Real description'}), 'Real description');
    });
  });

  group('formatDate', () {
    test('renders null as an em dash', () {
      expect(formatDate(null), '—');
    });

    test('formats a real date', () {
      expect(formatDate(DateTime(2026, 3, 5)), 'Mar 5');
    });
  });
}
