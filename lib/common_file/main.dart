import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2_sample/common_file/app.dart';

void main() {
  const scope = ProviderScope(child: App());
  runApp(scope);
}
