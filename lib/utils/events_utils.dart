import 'dart:async';

class GlobalEvents {
  static GlobalEvents _instance;
  factory GlobalEvents() => _instance ??= GlobalEvents._();
  GlobalEvents._();

  final StreamController<bool> showHeader = StreamController<bool>.broadcast();
}
