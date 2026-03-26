import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'mapa_screen.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  List<Map<String, dynamic>> pedidos = [
    {"id": "123", "estado": "Pendiente", "lat": 6.2442, "lng": -75.5812},
    {"id": "124", "estado": "En camino", "lat": 6.2500, "lng": -75.5800},
    {"id": "125", "estado": "Entregado", "lat": 6.2400, "lng": -75.5900},
    {"id": "126", "estado": "Pendiente", "lat": 6.2450, "lng": -75.5750},
  ];

  void actualizarEstado(int index) {
    setState(() {
      if (pedidos[index]["estado"] == "Pendiente") {
        pedidos[index]["estado"] = "En camino";
      } else if (pedidos[index]["estado"] == "En camino") {
        pedidos[index]["estado"] = "Entregado";
      }
    });
  }

  void cancelarPedido(int index) {
    setState(() {
      pedidos[index]["estado"] = "Cancelado";
    });
  }

  void confirmarCancelacion(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancelar pedido"),
        content: const Text("¿Seguro que deseas cancelar este pedido?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              cancelarPedido(index);
              Navigator.pop(context);
            },
            child: const Text("Sí"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1F22),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1F22),
        title: const Text("Pedidos"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pedidos.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                _welcomeCard(pedidos.length),
                const SizedBox(height: 20),
              ],
            );
          }

          final pedido = pedidos[index - 1];

          // Convertimos lat/lng a double seguro
          final destino = LatLng(
            pedido["lat"]?.toDouble() ?? 6.2442,
            pedido["lng"]?.toDouble() ?? -75.5812,
          );

          return _buildPedidoCard(
            pedido["id"]!,
            pedido["estado"]!,
            index - 1,
            destino,
          );
        },
      ),
    );
  }

  Widget _welcomeCard(int total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B2F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.delivery_dining, color: Colors.orange, size: 40),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              "Tienes $total pedidos 🚀",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPedidoCard(
      String id, String estado, int index, LatLng destino) {
    Color color;

    switch (estado) {
      case "Entregado":
        color = Colors.green;
        break;
      case "En camino":
        color = Colors.orange;
        break;
      case "Cancelado":
        color = Colors.grey;
        break;
      default:
        color = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B2F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pedido #$id",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  estado,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          const Text(
            "Cliente: Juan Pérez",
            style: TextStyle(color: Colors.white70),
          ),

          const Text(
            "Dirección: Calle 123 #45-67",
            style: TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              // Llamar
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call, size: 16),
                  label: const Text("Llamar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Ruta
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MapaScreen(destino: destino),
                      ),
                    );
                  },
                  icon: const Icon(Icons.map, size: 16),
                  label: const Text("Ruta"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Cancelar
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: (estado == "Entregado" || estado == "Cancelado")
                      ? null
                      : () => confirmarCancelacion(index),
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text("Cancelar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Estado dinámico
              Expanded(
                child: ElevatedButton(
                  onPressed: (estado == "Entregado" || estado == "Cancelado")
                      ? null
                      : () => actualizarEstado(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    estado == "Pendiente"
                        ? "Aceptar"
                        : estado == "En camino"
                            ? "Entregar"
                            : estado == "Cancelado"
                                ? "Cancelado"
                                : "OK",
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}