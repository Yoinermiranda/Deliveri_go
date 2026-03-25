import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registro_usuario_screen.dart';
import 'seleccion_rol_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const DeliveryGoApp());
}

class DeliveryGoApp extends StatelessWidget {
  const DeliveryGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliveryGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF221910),
        fontFamily: 'PlusJakartaSans',
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/select-role': (_) => const SeleccionRolScreen(),
        '/register': (_) => const RegistroUsuarioScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Color primario naranja de DeliveryGo
  static const Color kPrimary = Color(0xFFF48C25);
  static const Color kBackground = Color(0xFF221910);
  static const Color kTextLight = Color(0xFFF1F5F9); // slate-100
  static const Color kTextMuted = Color(0xFF94A3B8); // slate-400

  late AnimationController _progressController;
  late AnimationController _fadeController;
  late AnimationController _spinController;

  late Animation<double> _progressAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animación de progreso: 0% → 100% en 3 segundos
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Fade in del contenido
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Spin continuo del ícono de sync
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Iniciar animaciones
    _fadeController.forward();
    _progressController.forward();

    // Navegar a la siguiente pantalla al terminar
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Tras la pantalla de carga mostrada arriba, presentamos la
        // página de inicio de sesión en formato HTML dentro de un WebView.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _fadeController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar (botón cerrar placeholder) ──────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(Icons.close, color: kTextLight, size: 24),
                  ),
                ),
              ),

              // ── Logo + texto de bienvenida ───────────────────────────
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        // Mientras integras el asset real usa un placeholder naranja
                        color: const Color(
                          0xFFF48C25,
                        ).withAlpha((0.15 * 255).round()),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAHnhT-8FiMp07Kjj5HrqHS7finBaOnBr4ub9ECa9Qnugp-BTHf5R0QICmE8cW4Suock8SBunwRKvhZT1Bju2rvtgRXh8KG15B3cZmcV38e4jqfbrbkvLvrgOGC4TCV7JA20ZIe1pNSgHfi5YVyfZrYna4g25eCi5t0kAxlfh6nCroWhZSmwEhJt4l_wKUI7xtXTToGsjZIgkO-YtY10RMOmLoAq9vRgkvmHKUeSjJbUJLdtszoKDL1jXYw5JsweE3d6fZzXZDw3iY',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(
                              Icons.delivery_dining,
                              size: 100,
                              color: kPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Título
                    const Text(
                      '¡Bienvenido!',
                      style: TextStyle(
                        color: kTextLight,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtítulo
                    const Text(
                      'Tus antojos, a un toque de distancia.',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Sección de carga ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, _) {
                    final percent = (_progressAnimation.value * 100).toInt();
                    return Column(
                      children: [
                        // Fila: ícono + "Cargando..." | porcentaje
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                // Ícono giratorio
                                RotationTransition(
                                  turns: _spinController,
                                  child: const Icon(
                                    Icons.sync,
                                    color: kPrimary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Cargando...',
                                  style: TextStyle(
                                    color: kTextLight,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '$percent%',
                              style: const TextStyle(
                                color: kTextMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Barra de progreso
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: _progressAnimation.value,
                            minHeight: 8,
                            backgroundColor: kPrimary.withAlpha(
                              (0.2 * 255).round(),
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              kPrimary,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Safe area bottom
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
