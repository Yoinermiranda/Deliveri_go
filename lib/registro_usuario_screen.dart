import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// ── Constantes de color ────────────────────────────────────────────────────
const Color kPrimary = Color(0xFFF48C25);
const Color kBackground = Color(0xFF221910);
const Color kSurface = Color(0xFF2E1F12);
const Color kTextLight = Color(0xFFF1F5F9);
const Color kTextMuted = Color(0xFF94A3B8);
const Color kBorder = Color(0x33F48C25); // primary/20

class RegistroUsuarioScreen extends StatefulWidget {
  const RegistroUsuarioScreen({super.key});

  @override
  State<RegistroUsuarioScreen> createState() => _RegistroUsuarioScreenState();
}

class _RegistroUsuarioScreenState extends State<RegistroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _nombreCtrl = TextEditingController();
  final _docNumCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();

  String? _tipoDocumento;
  DateTime? _fechaNacimiento;
  File? _fotoPerfil;

  final List<Map<String, String>> _tiposDoc = [
    {'value': 'cc', 'label': 'C.C.'},
    {'value': 'dni', 'label': 'DNI'},
    {'value': 'pasaporte', 'label': 'Pasaporte'},
    {'value': 'ce', 'label': 'C.E.'},
  ];

  // ── Seleccionar foto ──────────────────────────────────────────────────────
  Future<void> _seleccionarFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 400,
    );
    if (picked != null) {
      setState(() => _fotoPerfil = File(picked.path));
    }
  }

  // ── Seleccionar fecha ─────────────────────────────────────────────────────
  Future<void> _seleccionarFecha() async {
    final hoy = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(hoy.year - 20),
      firstDate: DateTime(1920),
      lastDate: hoy,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: kPrimary,
            onPrimary: Colors.white,
            surface: kSurface,
            onSurface: kTextLight,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _fechaNacimiento = picked;
        final edad =
            hoy.year -
            picked.year -
            (hoy.month < picked.month ||
                    (hoy.month == picked.month && hoy.day < picked.day)
                ? 1
                : 0);
        _edadCtrl.text = edad.toString();
      });
    }
  }

  // ── Submit ────────────────────────────────────────────────────────────────
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('¡Registro completado exitosamente!'),
          backgroundColor: kPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _docNumCtrl.dispose();
    _edadCtrl.dispose();
    _direccionCtrl.dispose();
    super.dispose();
  }

  // ── BUILD ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: kBorder),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimary),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Registro de Usuario',
          style: TextStyle(
            color: kTextLight,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Foto de perfil ──────────────────────────────────────
              _FotoPerfilWidget(foto: _fotoPerfil, onTap: _seleccionarFoto),

              const SizedBox(height: 32),

              // ── Nombre Completo ─────────────────────────────────────
              _buildLabel('Nombre Completo'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _nombreCtrl,
                hint: 'Ej: Juan Pérez',
                prefixIcon: Icons.person_outline,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingresa tu nombre' : null,
              ),

              const SizedBox(height: 20),

              // ── Tipo y Número de Documento ──────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Tipo de Documento'),
                        const SizedBox(height: 6),
                        _buildDropdown(
                          value: _tipoDocumento,
                          items: _tiposDoc,
                          hint: 'Seleccionar',
                          onChanged: (v) => setState(() => _tipoDocumento = v),
                          validator: (v) =>
                              v == null ? 'Selecciona tipo' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Nro. Documento'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: _docNumCtrl,
                          hint: '12345678',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (v) => v == null || v.isEmpty
                              ? 'Ingresa el número'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Fecha de Nacimiento y Edad ──────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Fecha de Nacimiento'),
                        const SizedBox(height: 6),
                        _buildDateField(
                          fecha: _fechaNacimiento,
                          onTap: _seleccionarFecha,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Edad'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: _edadCtrl,
                          hint: '25',
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Requerida' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Dirección ───────────────────────────────────────────
              _buildLabel('Dirección Residencial'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _direccionCtrl,
                hint: 'Calle, Número, Barrio',
                prefixIcon: Icons.location_on_outlined,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingresa tu dirección' : null,
              ),

              const SizedBox(height: 32),

              // ── Botón submit ────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Text(
                    'Completar Registro',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  label: const Icon(Icons.arrow_forward, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    shadowColor: kPrimary.withAlpha((0.4 * 255).round()),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Términos ────────────────────────────────────────────
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text(
                      'Al registrarte, aceptas nuestros ',
                      style: TextStyle(color: kTextMuted, fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Términos y Condiciones',
                        style: TextStyle(
                          color: kPrimary,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const Text(
                      ' y ',
                      style: TextStyle(color: kTextMuted, fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Política de Privacidad',
                        style: TextStyle(
                          color: kPrimary,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const Text(
                      '.',
                      style: TextStyle(color: kTextMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers de UI ──────────────────────────────────────────────────────────

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: Color(0xFFCBD5E1), // slate-300
      fontSize: 13,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: controller,
    readOnly: readOnly,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    validator: validator,
    style: const TextStyle(color: kTextLight, fontSize: 15),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0x66F1F5F9)),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: kPrimary.withAlpha((0.6 * 255).round()),
              size: 22,
            )
          : null,
      filled: true,
      fillColor: kPrimary.withAlpha((0.08 * 255).round()),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kPrimary.withAlpha((0.2 * 255).round())),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    ),
  );

  Widget _buildDropdown({
    required String? value,
    required List<Map<String, String>> items,
    required String hint,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) => DropdownButtonFormField<String>(
    value: value,
    validator: validator,
    dropdownColor: kSurface,
    iconEnabledColor: kPrimary,
    style: const TextStyle(color: kTextLight, fontSize: 15),
    decoration: InputDecoration(
      filled: true,
      fillColor: kPrimary.withAlpha((0.08 * 255).round()),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kPrimary.withAlpha((0.2 * 255).round())),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kPrimary.withAlpha((0.2 * 255).round())),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    ),
    hint: Text(
      hint,
      style: const TextStyle(color: Color(0x66F1F5F9), fontSize: 14),
    ),
    items: items
        .map(
          (e) => DropdownMenuItem(value: e['value'], child: Text(e['label']!)),
        )
        .toList(),
    onChanged: onChanged,
  );

  Widget _buildDateField({
    required DateTime? fecha,
    required VoidCallback onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: kPrimary.withAlpha((0.08 * 255).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimary.withAlpha((0.2 * 255).round())),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: kPrimary.withAlpha((0.6 * 255).round()),
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            fecha != null
                ? '${fecha.day.toString().padLeft(2, '0')}/'
                      '${fecha.month.toString().padLeft(2, '0')}/'
                      '${fecha.year}'
                : 'DD/MM/AAAA',
            style: TextStyle(
              color: fecha != null ? kTextLight : const Color(0x66F1F5F9),
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
//  WIDGET: Foto de perfil
// ══════════════════════════════════════════════════════════════════════════════
class _FotoPerfilWidget extends StatelessWidget {
  final File? foto;
  final VoidCallback onTap;

  const _FotoPerfilWidget({required this.foto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Stack(
              children: [
                // Avatar
                Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: kPrimary.withAlpha((0.3 * 255).round()),
                      width: 4,
                    ),
                    color: kPrimary.withAlpha((0.08 * 255).round()),
                  ),
                  child: ClipOval(
                    child: foto != null
                        ? Image.file(foto!, fit: BoxFit.cover)
                        : const Icon(
                            Icons.person_outline,
                            size: 56,
                            color: Color(0x66F48C25),
                          ),
                  ),
                ),

                // Botón "+"
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: kPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(color: kBackground, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimary.withAlpha((0.4 * 255).round()),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Foto de Perfil',
            style: TextStyle(
              color: kTextLight,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Toca para subir una foto clara',
            style: TextStyle(color: kTextMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
