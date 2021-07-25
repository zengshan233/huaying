import 'dart:io';

import 'package:process_run/shell.dart';

var shell = Shell();

class NodeSetup {
  Future<void> expressStarts({String? path, String? projectName}) async {
    print('Express creating.....');
    File('$path\\node_start.sh')
        .writeAsStringSync('#!/bin/bash\ncd $path\nnpm init');

    await Process.run('$path\\node_start.sh', [], runInShell: true);

    // await shell.pushd(path).runExecutableArguments('npm', [
    //   'init'
    // ]);
//\nnpm install express nodemon \nnpm install bcrypt \nnpm install dotenv \nnpm install jsonwebtoken \nnpm install mongoose \nnpm install node-input-validator
    //  shell = shell.popd();
  }

  Future<void> expressInstallDependencies({required String path}) async {
    await shell.cd(path).run('npm i express nodemon');

    await shell.cd(path).run('npm i bcrypt');

    await shell.cd(path).run('npm i dotenv');
    await shell.cd(path).run('npm i jsonwebtoken');
    await shell.cd(path).run('npm i mongoose');
    await shell.cd(path).run('npm install node-input-validator');
  }
}
