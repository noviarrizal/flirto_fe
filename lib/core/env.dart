import 'dart:io';

class Env {
  static final apiBase = const String.fromEnvironment('API_BASE', defaultValue: 'http://10.0.2.2:8080');
  static final supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  static final supabaseAnon = const String.fromEnvironment('SUPABASE_ANON_KEY');
  static bool get isCI => Platform.environment['CI'] == 'true';
}