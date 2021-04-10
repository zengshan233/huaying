# huayin_logistics

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## App 环境运行指令

- 开发环境

``` Shell
flutter run --flavor dev -t lib/main_dev.dart
```

- 测试环境

``` Shell
flutter run  --flavor alpha -t lib/main_test.dart
```

- UAT环境

``` Shell
flutter run  --flavor uat -t lib/main_uat.dart
```

- 生产环境

``` Shell
flutter run  --flavor prod -t lib/main_prod.dart
```

## App 打包指令

- 开发环境

``` Shell
flutter build apk/ios --flavor dev -t lib/main_dev.dart
```

- 测试环境

``` Shell
flutter build apk/ios --flavor alpha -t lib/main_test.dart
```

- 生产环境

``` Shell
* flutter build apk/ios  --flavor prod -t lib/main_prod.dart
```

- 用户验收环境

``` Shell
flutter build apk/ios --flavor uat -t lib/main_uat.dart
```
