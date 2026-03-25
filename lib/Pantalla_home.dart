import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1F22),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔙 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Hola, Yoiner 👋",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.person, color: Colors.white),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // 🚀 Card principal
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2B2F),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.delivery_dining, color: Colors.orange, size: 40),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Text(
                        "Tienes 3 pedidos activos",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ⚡ Acciones rápidas
              const Text(
                "Acciones rápidas",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAction(Icons.list, "Pedidos"),
                  _buildAction(Icons.map, "Mapa"),
                  _buildAction(Icons.person, "Perfil"),
                ],
              ),

              const SizedBox(height: 25),

              // 📦 Lista de pedidos
              const Text(
                "Últimos pedidos",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView(
                  children: [
                    _buildOrder("Pedido #123", "En camino"),
                    _buildOrder("Pedido #124", "Entregado"),
                    _buildOrder("Pedido #125", "Pendiente"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Widget acción
  Widget _buildAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2B2F),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.orange),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white70))
      ],
    );
  }

  // 🔹 Widget pedido
  Widget _buildOrder(String title, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B2F),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          Text(
            status,
            style: const TextStyle(color: Colors.orange),
          ),
        ],
      ),
    );
  }
}