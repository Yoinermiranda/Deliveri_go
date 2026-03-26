import 'package:delivery_go/login_screen.dart';
import 'package:flutter/material.dart';
import 'registro_usuario_screen.dart';
import 'registro_repartidor_screen.dart';

// ── Constantes de color ────────────────────────────────────────────────────
const Color kPrimary = Color(0xFFF48C25);
const Color kBackground = Color(0xFF221910);
const Color kSurface = Color(0xFF2F2216);
const Color kTextLight = Color(0xFFF1F5F9);
const Color kTextMuted = Color(0xFF94A3B8);
const Color kTextWarm = Color(0xFFCBAD90);

class SeleccionRolScreen extends StatefulWidget {
  const SeleccionRolScreen({super.key});

  @override
  State<SeleccionRolScreen> createState() => _SeleccionRolScreenState();
}

class _SeleccionRolScreenState extends State<SeleccionRolScreen>
    with SingleTickerProviderStateMixin {
  String? _rolSeleccionado; // 'cliente' | 'repartidor'
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _seleccionarRol(String rol) {
    setState(() => _rolSeleccionado = rol);
    // Pequeño delay visual antes de navegar
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      if (rol == 'repartidor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RegistroRepartidorScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RegistroUsuarioScreen()),
        );
      }
    });
  }

  void _irIniciarSesion() {
    // Aquí puedes poner la pantalla de login
    // Por ahora redirige a RegistroUsuarioScreen como ejemplo
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _buildWelcomeSection(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              _RolCard(
                                rol: 'cliente',
                                titulo: 'Cliente',
                                descripcion:
                                    'Pide comida y productos a domicilio con rapidez.',
                                icono: Icons.person_outline_rounded,
                                seleccionado: _rolSeleccionado == 'cliente',
                                onTap: () => _seleccionarRol('cliente'),
                              ),
                              const SizedBox(height: 16),
                              _RolCard(
                                rol: 'repartidor',
                                titulo: 'Repartidor',
                                descripcion:
                                    'Genera ingresos adicionales entregando pedidos.',
                                icono: Icons.delivery_dining_outlined,
                                seleccionado: _rolSeleccionado == 'repartidor',
                                onTap: () => _seleccionarRol('repartidor'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildPromoBanner(),
                        const SizedBox(height: 24),
                        _buildFooter(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: kTextLight),
            onPressed: () => Navigator.maybePop(context),
            style: IconButton.styleFrom(shape: const CircleBorder()),
          ),
          const Expanded(
            child: Text(
              'Registro',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kTextLight,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: kPrimary.withAlpha((0.1 * 255).round()),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAHnhT-8FiMp07Kjj5HrqHS7finBaOnBr4ub9ECa9Qnugp-BTHf5R0QICmE8cW4Suock8SBunwRKvhZT1Bju2rvtgRXh8KG15B3cZmcV38e4jqfbrbkvLvrgOGC4TCV7JA20ZIe1pNSgHfi5YVyfZrYna4g25eCi5t0kAxlfh6nCroWhZSmwEhJt4l_wKUI7xtXTToGsjZIgkO-YtY10RMOmLoAq9vRgkvmHKUeSjJbUJLdtszoKDL1jXYw5JsweE3d6fZzXZDw3iY',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.delivery_dining,
                  size: 60,
                  color: kPrimary,
                ),
              ),
            ),
          ),
          const Text(
            '¡Elige tu rol!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kTextLight,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '¿Cómo te gustaría usar nuestra\nplataforma hoy?',
            textAlign: TextAlign.center,
            style: TextStyle(color: kTextMuted, fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kPrimary.withAlpha((0.25 * 255).round()),
              kBackground.withAlpha((0.95 * 255).round()),
            ],
          ),
          border: Border.all(
            color: Colors.white.withAlpha((0.05 * 255).round()),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 16,
              top: 12,
              child: Icon(
                Icons.delivery_dining,
                size: 64,
                color: kPrimary.withAlpha((0.12 * 255).round()),
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Únete a la red de delivery más confiable de la ciudad.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kTextLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¿Ya tienes cuenta? ',
          style: TextStyle(color: kTextMuted, fontSize: 14),
        ),
        GestureDetector(
          onTap: _irIniciarSesion,
          child: const Text(
            'Iniciar Sesión',
            style: TextStyle(
              color: kPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _RolCard extends StatefulWidget {
  final String rol;
  final String titulo;
  final String descripcion;
  final IconData icono;
  final bool seleccionado;
  final VoidCallback onTap;

  const _RolCard({
    required this.rol,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  State<_RolCard> createState() => _RolCardState();
}

class _RolCardState extends State<_RolCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _scaleCtrl;
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleCtrl.reverse(),
      onTapUp: (_) {
        _scaleCtrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _scaleCtrl.forward(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.seleccionado
                  ? kPrimary
                  : kPrimary.withAlpha((0.0 * 255).round()),
              width: 2,
            ),
            boxShadow: widget.seleccionado
                ? [
                    BoxShadow(
                      color: kPrimary.withAlpha((0.25 * 255).round()),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: widget.seleccionado
                      ? kPrimary.withAlpha((0.2 * 255).round())
                      : kPrimary.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(widget.icono, size: 40, color: kPrimary),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.titulo,
                      style: const TextStyle(
                        color: kTextLight,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.descripcion,
                      style: const TextStyle(
                        color: kTextWarm,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: widget.seleccionado ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: const BoxDecoration(
                    color: kPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}                             