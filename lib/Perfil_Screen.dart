import 'package:delivery_go/Pantalla_home.dart';
import 'package:delivery_go/login_screen.dart';
import 'package:flutter/material.dart';
import 'Pedidosscreen.dart';


class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1F22),
      appBar: AppBar(
        title: const Text("Perfil"),
        backgroundColor: const Color(0xFF1E1F22),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.orange,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),

            const SizedBox(height: 10),

            const Text(
              "Yoiner",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              "Repartidor activo",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 30),

            _buildInfoCard(Icons.email, "Correo", "yoiner@email.com"),
            _buildInfoCard(Icons.phone, "Teléfono", "+57 300 000 0000"),
            _buildInfoCard(Icons.location_on, "Ciudad", "Medellín"),

            const SizedBox(height: 20),

            // 🔥 BOTONES FUNCIONANDO
            _buildButton(context, Icons.edit, "Editar perfil"),
            _buildButton(context, Icons.history, "Historial de pedidos"),
            _buildButton(context, Icons.logout, "Cerrar sesión"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B2F),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$title: $value",
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  // 🔥 AQUÍ ESTÁ LA LÓGICA
  Widget _buildButton(BuildContext context, IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2A2B2F),
          padding: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          if (text == "Editar perfil") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Editar perfil próximamente")),
            );
          } 
          else if (text == "Historial de pedidos") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PedidosScreen()),
            );
          } 
          else if (text == "Cerrar sesión") {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
        },
        child: Row(
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}