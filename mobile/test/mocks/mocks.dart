import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/color_tap_game.dart';
import 'package:mobile/color_tap_world.dart';
import 'package:mobile/components/target_board.dart';
import 'package:mobile/managers/lives_manager.dart';
import 'package:mobile/managers/preference_manager.dart';
import 'package:mobile/managers/properties_manager.dart';
import 'package:mobile/managers/purchases_manager.dart';
import 'package:mobile/managers/time_manager.dart';
import 'package:mobile/wrappers/internet_address_wrapper.dart';
import 'package:mobile/wrappers/platform_wrapper.dart';
import 'package:mobile/wrappers/purchases_wrapper.dart';
import 'package:mobile/wrappers/rewarded_ad_wrapper.dart';
import 'package:mobile/wrappers/url_launcher_wrapper.dart';
import 'package:mockito/annotations.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([ColorTapGame])
@GenerateMocks([ColorTapWorld])
@GenerateMocks([], customMocks: [MockSpec<ComponentsNotifier>()])
@GenerateMocks([CustomerInfo])
@GenerateMocks([FlutterView])
@GenerateMocks([InternetAddressWrapper])
@GenerateMocks([LivesManager])
@GenerateMocks([Offering])
@GenerateMocks([Offerings])
@GenerateMocks([Package])
@GenerateMocks([PlatformDispatcher])
@GenerateMocks([PlatformException])
@GenerateMocks([PlatformWrapper])
@GenerateMocks([PreferenceManager])
@GenerateMocks([PropertiesManager])
@GenerateMocks([PurchasesManager])
@GenerateMocks([PurchasesWrapper])
@GenerateMocks([RewardedAd])
@GenerateMocks([RewardedAdWrapper])
@GenerateMocks([SharedPreferences])
@GenerateMocks([StoreProduct])
@GenerateMocks([TapDownEvent])
@GenerateMocks([TargetBoard])
@GenerateMocks([TimeManager])
@GenerateMocks([UrlLauncherWrapper])
@GenerateMocks([Viewport])
main() {}