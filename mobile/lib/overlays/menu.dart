import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';
import 'package:mobile/color_tap_game.dart';
import 'package:mobile/managers/lives_manager.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mobile/pages/settings_page.dart';
import 'package:mobile/utils/dimens.dart';
import 'package:mobile/utils/theme.dart';
import 'package:mobile/widgets/get_lives.dart';
import 'package:mobile/widgets/remaining_lives.dart';

import '../utils/colors.dart';
import '../utils/page_utils.dart';

class Menu extends StatelessWidget {
  static const _titleSize = 50.0;
  static const _scoreSize = 100.0;

  final ColorTapGame game;
  final _MenuData _data;

  Menu.main(this.game) : _data = _MainMenuData();

  Menu.gameOver(this.game) : _data = _GameOverMenuData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme(context),
      themeMode: ThemeMode.dark,
      localizationsDelegates: Strings.localizationsDelegates,
      supportedLocales: Strings.supportedLocales,
      // Unless the system locale exactly matches supportedLocales, default to
      // US English.
      localeResolutionCallback: (locale, locales) =>
          locales.contains(locale) ? locale : const Locale("en"),
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: SafeArea(
                  child: Padding(
                    padding: insetsDefault,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        _buildTitle(context),
                        _buildLives(),
                        _buildScore(),
                        _buildGetLives(context),
                        const Spacer(),
                        _buildPlayButton(context),
                        const SizedBox(height: paddingSmall),
                        _buildSettingsButton(context),
                        const Spacer(),
                        _buildDifficulty(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      _data.title(context),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: _titleSize,
        color: colorLightText,
      ),
    );
  }

  Widget _buildLives() {
    return const RemainingLives();
  }

  Widget _buildScore() {
    if (_data.hideScore) {
      return Container();
    }

    return Text(
      game.world.score.toString(),
      style: const TextStyle(
        fontSize: _scoreSize,
        color: colorLightText,
      ),
    );
  }

  Widget _buildGetLives(BuildContext context) {
    return StreamBuilder(
      stream: LivesManager.get.stream,
      builder: (context, _) {
        if (LivesManager.get.canPlay) {
          return Container();
        }

        return Padding(
          padding: insetsVerticalDefault,
          child: Column(
            children: [
              Text(
                Strings.of(context).menuOutOfLives,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              GetLives(Strings.of(context).menuBuyMoreLives),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return StreamBuilder(
      stream: LivesManager.get.stream,
      builder: (context, _) => LivesManager.get.canPlay
          ? FilledButton(
              onPressed: game.world.play,
              child: Text(_data.playText(context)),
            )
          : const SizedBox(),
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return Padding(
      padding: insetsVerticalSmall,
      child: FilledButton(
        onPressed: () => present(context, SettingsPage()),
        child: Text(Strings.of(context).settingsTitle),
      ),
    );
  }

  Widget _buildDifficulty() {
    return StreamBuilder(
      stream: PreferenceManager.get.stream,
      builder: (context, _) {
        return Column(
          children: [
            Text(
              Strings.of(context).menuDifficulty(
                  PreferenceManager.get.difficulty.displayName(context)),
              style: styleTextPrimary(),
            ),
            Text(
              Strings.of(context).menuHighScore(
                  PreferenceManager.get.currentHighScore?.toString() ??
                      Strings.of(context).menuHighScoreNone),
              style: styleTextPrimary(),
            ),
          ],
        );
      },
    );
  }
}

abstract class _MenuData {
  bool get hideScore;

  String playText(BuildContext context);

  String title(BuildContext context);
}

class _MainMenuData implements _MenuData {
  @override
  bool get hideScore => true;

  @override
  String playText(BuildContext context) => Strings.of(context).menuMainPlay;

  @override
  String title(BuildContext context) => Strings.of(context).menuMainTitle;
}

class _GameOverMenuData implements _MenuData {
  @override
  bool get hideScore => false;

  @override
  String playText(BuildContext context) =>
      Strings.of(context).menuGameOverPlayAgain;

  @override
  String title(BuildContext context) => Strings.of(context).menuGameOverTitle;
}
