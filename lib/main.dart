import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';
import 'preferencias/pref_ser.dart';
import 'preferencias/tema.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeService = ThemeService();
  await themeService.loadThemeFromPrefs();
  await themeService.init();

  final prefs = await SharedPreferences.getInstance();
  final correoGuardado = prefs.getString('correo');

  runApp(
    MyApp(
      themeService: themeService,
      startInHome: correoGuardado != null && correoGuardado.isNotEmpty,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeService themeService;
  final bool startInHome;

  const MyApp({
    super.key,
    required this.themeService,
    required this.startInHome,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Inicio sesión',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeService.themeMode,
      home: startInHome ? const HomePage() : const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final correoCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  // Fuentes Google Fonts para elegir
  String fuente = 'Roboto';
  String color = 'Azul';
  bool isDark = false;

  final List<String> fuentes = ['Roboto', 'Lato', 'Open Sans'];
  final List<String> colores = ['Azul', 'Morado', 'Amarillo', 'Verde'];

  Future<void> ingresar() async {
    if (correoCtrl.text.isEmpty || passCtrl.text.isEmpty) return;

    await PreferencesService.savePreferences(
      correo: correoCtrl.text,
      fuente: fuente,
      color: color,
      isDark: isDark,
    );

    Get.find<ThemeService>().toggleTheme(isDark);
    Get.offAll(() => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de sesión'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 550,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Inicio',
                  style: GoogleFonts.lato(
                    fontSize: 35,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: correoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Correo',
                    hintText: 'Ingrese su correo',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    hintText: 'Ingrese su contraseña',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  value: fuente,
                  decoration: const InputDecoration(
                    labelText: 'Fuente',
                    border: OutlineInputBorder(),
                  ),
                  items: fuentes
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (value) => setState(() => fuente = value!),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  value: color,
                  decoration: const InputDecoration(
                    labelText: 'Color de navegación',
                    border: OutlineInputBorder(),
                  ),
                  items: colores
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) => setState(() => color = value!),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Tema oscuro'),
                    Switch(
                      value: isDark,
                      onChanged: (value) => setState(() => isDark = value),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                MaterialButton(
                  minWidth: double.infinity,
                  onPressed: ingresar,
                  child: const Text('Ingresar'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
