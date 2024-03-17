import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2_sample/app.dart';

void main() {
  const scope = ProviderScope(child: App());
  runApp(scope);
}
