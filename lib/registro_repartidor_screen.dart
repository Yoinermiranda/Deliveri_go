import 'package:flutter/material.dart';

// ─── Colores del sistema DeliveryGo ────────────────────────────────────────
class AppColors {
  static const primary = Color(0xFFF48C25);
  static const bgDark = Color(0xFF221910);
  static const surfaceDark = Color(0xFF2C2116);
  static const borderDark = Color(0xFF4A3B2D);
  static const textPrimary = Color(0xFFF0E6DD);
  static const textSecondary = Color(0xFFBFA080);
}

// ─── Tipos de vehículo ──────────────────────────────────────────────────────
enum VehicleType { motocicleta, bicicleta, automovil }

// ─── Pantalla principal ─────────────────────────────────────────────────────
class RegistroRepartidorScreen extends StatefulWidget {
  const RegistroRepartidorScreen({super.key});

  @override
  State<RegistroRepartidorScreen> createState() =>
      _RegistroRepartidorScreenState();
}

class _RegistroRepartidorScreenState extends State<RegistroRepartidorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _plateController = TextEditingController();

  VehicleType _selectedVehicle = VehicleType.motocicleta;
  String? _selectedZone;

  bool _licenseUploaded = false;
  bool _insuranceUploaded = false;

  static const _zones = [
    'Zona Norte',
    'Zona Sur',
    'Centro Histórico',
    'Zona Poniente',
    'Zona Oriente',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('¡Postulación enviada con éxito!'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  bool _isPlateRequired() =>
      _selectedVehicle == VehicleType.motocicleta ||
      _selectedVehicle == VehicleType.automovil;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        'Completa tu perfil',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ingresa tus datos y documentos para empezar a repartir.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Nombre completo
                      _SectionLabel('Nombre completo'),
                      const SizedBox(height: 8),
                      _AppTextField(
                        controller: _nameController,
                        hint: 'Ej. Juan Pérez',
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 24),

                      // Correo electrónico
                      _SectionLabel('Correo electrónico'),
                      const SizedBox(height: 8),
                      _AppTextField(
                        controller: _emailController,
                        hint: 'Ej. correo@ejemplo.com',
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Campo requerido';
                          final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(v)) return 'Correo inválido';
                          return null;
                        },
                        textCapitalization: TextCapitalization.none,
                      ),
                      const SizedBox(height: 24),

                      // Contraseña
                      _SectionLabel('Contraseña'),
                      const SizedBox(height: 8),
                      _AppTextField(
                        controller: _passwordController,
                        hint: 'Mínimo 6 caracteres',
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Campo requerido';
                          if (v.length < 6) return 'La contraseña es muy corta';
                          return null;
                        },
                        textCapitalization: TextCapitalization.none,
                      ),
                      const SizedBox(height: 24),

                      // Tipo de vehículo
                      _SectionLabel('Tipo de vehículo'),
                      const SizedBox(height: 12),
                      _VehicleOption(
                        type: VehicleType.motocicleta,
                        label: 'Motocicleta',
                        subtitle: 'Ideal para distancias medias',
                        icon: Icons.two_wheeler,
                        selected: _selectedVehicle,
                        onTap: (t) => setState(() => _selectedVehicle = t),
                      ),
                      const SizedBox(height: 10),
                      _VehicleOption(
                        type: VehicleType.bicicleta,
                        label: 'Bicicleta',
                        subtitle: 'Para zonas urbanas densas',
                        icon: Icons.pedal_bike,
                        selected: _selectedVehicle,
                        onTap: (t) => setState(() => _selectedVehicle = t),
                      ),
                      const SizedBox(height: 10),
                      _VehicleOption(
                        type: VehicleType.automovil,
                        label: 'Automóvil',
                        subtitle: 'Mayor capacidad de carga',
                        icon: Icons.directions_car,
                        selected: _selectedVehicle,
                        onTap: (t) => setState(() => _selectedVehicle = t),
                      ),
                      const SizedBox(height: 24),

                      // Número de placa
                      _SectionLabel('Número de placa'),
                      const SizedBox(height: 8),
                      _AppTextField(
                        controller: _plateController,
                        hint: 'ABC-1234',
                        suffix: const Icon(
                          Icons.subtitles_outlined,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        textCapitalization: TextCapitalization.characters,
                        validator: (v) {
                          if (_isPlateRequired() &&
                              (v == null || v.isEmpty)) {
                            return 'Campo requerido para el vehículo seleccionado';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 4),
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          'Solo necesario si seleccionaste Moto o Automóvil',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Zona de trabajo
                      _SectionLabel('Zona de trabajo preferida'),
                      const SizedBox(height: 8),
                      _ZoneDropdown(
                        value: _selectedZone,
                        zones: _zones,
                        onChanged: (v) => setState(() => _selectedZone = v),
                      ),
                      const SizedBox(height: 24),

                      // Documentación
                      _SectionLabel('Documentación'),
                      const SizedBox(height: 12),
                      _DocumentUploadTile(
                        icon: Icons.badge_outlined,
                        title: 'Licencia de Conducir',
                        subtitle: 'Sube una foto clara',
                        uploaded: _licenseUploaded,
                        onTap: () =>
                            setState(() => _licenseUploaded = true),
                      ),
                      const SizedBox(height: 10),
                      _DocumentUploadTile(
                        icon: Icons.verified_user_outlined,
                        title: 'Seguro Vigente',
                        subtitle: 'Póliza de seguro',
                        uploaded: _insuranceUploaded,
                        onTap: () => setState(() => _insuranceUploaded = true),
                      ),
                      const SizedBox(height: 32),

                      // Botón de envío
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: AppColors.primary.withAlpha(
                              (0.4 * 255).round(),
                            ),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Postularme como Repartidor',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Términos y condiciones
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Al postularte aceptas nuestros ',
                              ),
                              TextSpan(
                                text: 'Términos y Condiciones',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Top Bar ────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(bottom: BorderSide(color: Color(0x334A3B2D), width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            iconSize: 24,
          ),
          const Expanded(
            child: Text(
              'Registro de Repartidor',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
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
}

// ─── Label de sección ───────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ─── Campo de texto genérico ─────────────────────────────────────────────────
class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? suffix;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;

  const _AppTextField({
    required this.controller,
    required this.hint,
    this.suffix,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: textCapitalization,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0x80BFA080)),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.bgDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}

// ─── Opción de vehículo ──────────────────────────────────────────────────────
class _VehicleOption extends StatelessWidget {
  final VehicleType type;
  final String label;
  final String subtitle;
  final IconData icon;
  final VehicleType selected;
  final ValueChanged<VehicleType> onTap;

  const _VehicleOption({
    required this.type,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = type == selected;
    return GestureDetector(
      onTap: () => onTap(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderDark,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.borderDark,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dropdown de zona ────────────────────────────────────────────────────────
class _ZoneDropdown extends StatelessWidget {
  final String? value;
  final List<String> zones;
  final ValueChanged<String?> onChanged;

  const _ZoneDropdown({
    required this.value,
    required this.zones,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: const Text(
            'Selecciona una zona',
            style: TextStyle(color: Color(0x80BFA080), fontSize: 15),
          ),
          isExpanded: true,
          dropdownColor: AppColors.surfaceDark,
          iconEnabledColor: AppColors.textSecondary,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
          onChanged: onChanged,
          items: zones
              .map((z) => DropdownMenuItem(value: z, child: Text(z)))
              .toList(),
        ),
      ),
    );
  }
}

// ─── Tile de subida de documento ─────────────────────────────────────────────
class _DocumentUploadTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool uploaded;
  final VoidCallback onTap;

  const _DocumentUploadTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.uploaded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgDark.withAlpha((0.5 * 255).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: uploaded
              ? AppColors.primary.withAlpha((0.6 * 255).round())
              : AppColors.borderDark,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withAlpha((0.12 * 255).round()),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              backgroundColor: uploaded
                  ? AppColors.primary.withAlpha((0.15 * 255).round())
                  : AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              uploaded ? 'Subido' : 'Subir',
              style: TextStyle(
                color: uploaded ? AppColors.primary : Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}