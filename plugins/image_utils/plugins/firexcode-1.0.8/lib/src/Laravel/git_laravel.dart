import 'dart:convert';
import 'dart:io';
import 'package:process_run/shell.dart';

import '../../laravel.dart';

var shell = Shell();

var context = '';

class LaravelSetup {
  void laravelStarts({required String path, String? projectName}) async {
    print('Laravel start downloading.....');

    await shell
        .cd(path)
        .run(
            'git clone https://github.com/zeeshux7860/laravel_firexcode.git $projectName')
        .then((value) async {
      print('Laravel download done.............');
      print(
          '--------------------------------------------------------------------------------');
      print(
          '--------------------------------------------------------------------------------');

      createFile(path + '/$projectName', context, '.env');
      var file = File(path + '/$projectName/' + '.env');
      var ok = File(path + '\\$projectName\\.env.example').openRead();
      ok
          .transform(utf8.decoder) // Decode bytes to UTF-8.
          .transform(LineSplitter()) // Convert stream to individual lines.
          .listen((String line) async {
        await file.writeAsString(line + '\n', mode: FileMode.append);
        // context = context + line + '\n';
      });
      print(
          "Go to here  $path + '/$projectName' .env\nSetup database configration");
    }).catchError((onError) {});
  }

  void laravelDone({required String path, String? projectName}) async {
    await shell.cd(path + '/$projectName').run('composer update').then((a) {
      shell
          .cd(path + '/$projectName')
          .run('''php artisan migrate ''').then((a) {
        shell
            .cd(path + '/$projectName')
            .run('php artisan passport:install')
            .then((a) {});
      });
    });
  }

  void laravelMigrate({required String path}) {
    shell.cd(path).run('''php artisan migrate ''').then((a) {});
  }

  void laravelReset({required String path}) {
    shell.cd(path).run('''
    php artisan migrate:rollback
    php artisan migrate:reset
    php artisan migrate:fresh
    php artisan migrate:fresh --seed
    ''').then((a) {});
  }

  void laravelRunPassPort(path) {
    shell.cd(path).run('php artisan passport:install').then((a) {});
  }
}
