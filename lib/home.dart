import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'preferencias/pref_ser.dart';
import 'preferencias/tema.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> cerrarSesion() async {
    await PreferencesService.clearPreferences();
    Get.find<ThemeService>().toggleTheme(false);
    Get.offAll(() => const LoginPage());
  }

  TextStyle getTextStyle(String fuente, Color color) {
    switch (fuente) {
      case 'Roboto':
        return GoogleFonts.roboto(color: color, fontSize: 24);
      case 'Lato':
        return GoogleFonts.lato(color: color, fontSize: 24);
      case 'Open Sans':
        return GoogleFonts.openSans(color: color, fontSize: 24);
      default:
        return GoogleFonts.lato(color: color, fontSize: 24);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PreferencesService.loadPreferences(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final prefs = snapshot.data!;
        final correo = prefs['correo'] ?? '';
        final fuente = prefs['fuente'] ?? 'Roboto';
        final color = prefs['color'] ?? 'Azul';
        final isDark = prefs['temaOscuro'] ?? false;

        Color navColor = Colors.blue;
        if (color == 'Morado') navColor = Colors.purple;
        if (color == 'Amarillo') navColor = Colors.amber;
        if (color == 'Verde') navColor = Colors.green;

        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          appBar: AppBar(
            title: const Text('Bienvenido'),
            backgroundColor: navColor,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Maresa Velazquez Martinez\n'
                  'Hola, $correo',
                  style: getTextStyle(
                    fuente,
                    isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: cerrarSesion,
                  child: const Text('Cerrar sesión'),
                  style: ElevatedButton.styleFrom(backgroundColor: navColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
