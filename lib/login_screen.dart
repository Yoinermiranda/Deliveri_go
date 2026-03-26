import 'package:delivery_go/Pantalla_home.dart';
import 'package:flutter/material.dart';



/// Pantalla de inicio de sesión recreada a partir de la guía HTML/Tailwind.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  static const Color kPrimary = Color(0xFFF48C25);
  static const Color kBackgroundLight = Color(0xFFF5F7F8);
  static const Color kBackgroundDark = Color(0xFF101922);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? kBackgroundDark : kBackgroundLight;
    final cardColor = isDark ? Colors.grey[900] : Colors.white;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;

    // helper moved inside build so it can see local vars
    Widget socialButton(String label, String assetUrl) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cardColor,
          elevation: 0,
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          side: BorderSide(color: borderColor),
        ),
        onPressed: () {},
        child: Row(
          children: [
            Image.network(assetUrl, height: 20, width: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 430,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(48),
                border: Border.all(color: borderColor, width: 8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // header/nav
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                        backgroundColor: isDark
                            ? Colors.black26
                            : Colors.white70,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: isDark ? Colors.white : Colors.black,
                          onPressed: () => Navigator.maybePop(context),
                        ),
                      ),
                    ),
                  ),

                  // hero section
                  Stack(
                    children: [
                      Container(
                        height: 320,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: isDark
                                ? [const Color(0xFF94A3B8), Colors.grey[900]!]
                                : [Colors.blue.shade50, Colors.white],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 32, 8, 8),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCb3K6TjO8tCLaBF40SQwMuTjpeHa_1QshoZPJ2JinG-zXcVohgFvVR_0tUdzj3lAs9ccIhYMiK40apg4mL0ODslvtgy9ZL_Q9C_CfVrfUhpeRclxHzHtH7uBKZ_xPy7ZK6MkVPueGwnqfcphc-Xmb_FLcNSjLmgOHY03PVuPWBJIdYJfSLdHb-fhYE6NEKSBftgz0s4QQ14WV6tDmRBq8YBtHVw1PtaSjIx5j2_PvIXD3002vAP1vyRMMqaq2ny2DYU0a5Ab7vi0ep',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(
                                Icons.delivery_dining,
                                size: 100,
                                color: kPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // decorative curve
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(40),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // content
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          '¡Bienvenido!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ingresa tus credenciales para comenzar a entregar.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.mail_outline),
                                  labelText: 'Correo Electrónico',
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(24),
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingresa un correo';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                obscureText: !_passwordVisible,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  labelText: 'Contraseña',
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(24),
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingresa tu contraseña';
                                  }
                                  return null;
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  elevation: 4,
                                ),
                               onPressed: () {
                          if (_formKey.currentState!.validate()) {
                                Navigator.pushReplacement(
                               context,
                                MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                              ),
                            );
                              }
                            },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('Iniciar Sesión'),
                                    SizedBox(width: 8),
                                    Icon(Icons.login),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(child: Divider(color: borderColor)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                'O continúa con',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: borderColor)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            socialButton(
                              'Google',
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuCSChl8dmOVH8QjK0vK9W8lY_unI8fEdBp4BnDM5m_6mGfyySw-4B6CjXfavDOFswpMgAkyH4GZqAxtKFqFS7WPRAdLyfG5Ke9sQ4Tt-IoKsGQPPWYPSmDEFi4kWdykWP6kN3YaBJJ-wg8o1YSUb4lJvcreKLCUPUMgpraPqQwSWYqkYDLz_BVo3_kRTXnmVipTBaK9ZGrR7v6YCixyl_B2KBlvxA4Jp2PcZU8RIPMxqq4JfLNybni1p9z8_m55SIyzzDrNMdgT_KcK',
                            ),
                            socialButton(
                              'Apple',
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBTahZf7HXEqxfeHSeKYl38QRoTMf9xrXUjOAtJWpsQ5N1k_dvyjFkBgVLPwMMDjqzj6T0buSQoQrCs8QEWHWHEeEy_1XQE-onousZV6MZoh7vgCXm5F50OboQWctIj6xIWiwdF6CR8l3GLqMX262fTSDWiSh2EAmmNSIE_F28rGYfVMyUY1rLdEnpHy4XOltibHZM37_0BK8AjHRMfM0in0g0_akVFggj3p9qagKoyxMeq7OHBl-SOSyL-oyTI-bvTk4mew0eK-49a',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/select-role');
                            },
                            child: RichText(
                              text: TextSpan(
                                text: '¿No tienes una cuenta?',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                                children: const [
                                  TextSpan(
                                    text: ' Regístrate aquí',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

