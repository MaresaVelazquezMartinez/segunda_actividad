import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static Future<void> savePreferences({
    required String correo,
    required String fuente,
    required String color,
    required bool isDark,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('correo', correo);
    await prefs.setString('fuente', fuente);
    await prefs.setString('color', color);
    await prefs.setBool('temaOscuro', isDark);
  }

  static Future<Map<String, dynamic>> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'correo': prefs.getString('correo'),
      'fuente': prefs.getString('fuente'),
      'color': prefs.getString('color'),
      'temaOscuro': prefs.getBool('temaOscuro'),
    };
  }

  static Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
