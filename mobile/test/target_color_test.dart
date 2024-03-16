import 'package:flame/palette.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mobile/target_color.dart';
import 'package:mockito/mockito.dart';

import 'mocks/mocks.mocks.dart';

void main() {
  test("random excludes input", () {
    // Not a perfect test, but changes of 1000 random colors not producing the
    // same as the previous is very low in a collection of 8 colors.
    var exclude = TargetColor.random();
    for (var i = 0; i < 1000; i++) {
      var color = TargetColor.random(exclude: exclude);
      expect(color, isNot(exclude));
    }
  });

  test("fromPreferences valid value", () {
    var prefs = MockPreferenceManager();
    PreferenceManager.set(prefs);
    when(prefs.colorIndex).thenReturn(1);

    var color = TargetColor.fromPreferences();
    expect(color.color, BasicPalette.orange.color);
  });

  test("fromPreferences null value", () {
    var prefs = MockPreferenceManager();
    PreferenceManager.set(prefs);
    when(prefs.colorIndex).thenReturn(null);

    TargetColor.fromPreferences();
    verify(prefs.colorIndex).called(1);
  });

  test("from index", () {
    expect(TargetColor.from(index: 1).color, BasicPalette.orange.color);
  });

  test("all returns correct number of colors", () {
    expect(TargetColor.all().length, 8);
  });
}