import 'package:flutter/material.dart';
import 'package:test/test.dart';

import 'package:habr_app/stores/app_settings.dart';

void main() {
  group('to more than from', () {
    const from = TimeOfDay(hour: 10, minute: 0);
    const to = TimeOfDay(hour: 20, minute: 0);
    test('current equal from', () {
      expect(
          AppSettings.needSetLightTheme(
              const TimeOfDay(hour: 10, minute: 0), from, to),
          true);
    });
    test('current between from and to', () {
      expect(
          AppSettings.needSetLightTheme(
              const TimeOfDay(hour: 10, minute: 1), from, to),
          true);
      expect(
          AppSettings.needSetLightTheme(
              const TimeOfDay(hour: 11, minute: 0), from, to),
          true);
    });
    test('current more to', () {
      expect(
          AppSettings.needSetLightTheme(
              const TimeOfDay(hour: 20, minute: 1), from, to),
          false);
    });
    test('current less from', () {
      expect(
          AppSettings.needSetLightTheme(
              const TimeOfDay(hour: 9, minute: 59), from, to),
          false);
    });
  });
  group('from more than to', () {
    const from = TimeOfDay(hour: 20, minute: 0);
    const to = TimeOfDay(hour: 10, minute: 0);
    test('current equal from', () {
      expect(
          AppSettings.needSetLightTheme(
              const TimeOfDay(hour: 20, minute: 0), from, to),
          true);
    });
    test('current between from and to', () {
      expect(
          AppSettings.needSetLightTheme(
              const TimeOfDay(hour: 20, minute: 1), from, to),
          true);
      expect(
          AppSettings.needSetLightTheme(
              const TimeOfDay(hour: 21, minute: 0), from, to),
          true);
      expect(
          AppSettings.needSetLightTheme(
              const TimeOfDay(hour: 0, minute: 1), from, to),
          true);
      expect(
          AppSettings.needSetLightTheme(
              const TimeOfDay(hour: 9, minute: 59), from, to),
          true);
    });
    test('current more to', () {
      expect(
          AppSettings.needSetLightTheme(
              const TimeOfDay(hour: 10, minute: 1), from, to),
          false);
      expect(
          AppSettings.needSetLightTheme(
              const TimeOfDay(hour: 19, minute: 59), from, to),
          false);
    });
  });
}
