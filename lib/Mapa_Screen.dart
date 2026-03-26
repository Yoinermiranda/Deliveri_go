import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaScreen extends StatefulWidget {
  final LatLng destino; // Coordenada destino dinámica

  const MapaScreen({super.key, required this.destino});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  late GoogleMapController mapController;

  final LatLng _inicio = const LatLng(6.2442, -75.5812); // Ubicación inicial

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Marcadores inicial y destino
    _markers = {
      Marker(
        markerId: const MarkerId("inicio"),
        position: _inicio,
        infoWindow: const InfoWindow(title: "Ubicación inicial"),
      ),
      Marker(
        markerId: const MarkerId("destino"),
        position: widget.destino,
        infoWindow: const InfoWindow(title: "Destino"),
      ),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // Ajusta la cámara para mostrar ambos marcadores
    LatLngBounds bounds;
    if (_inicio.latitude > widget.destino.latitude &&
        _inicio.longitude > widget.destino.longitude) {
      bounds = LatLngBounds(southwest: widget.destino, northeast: _inicio);
    } else if (_inicio.longitude > widget.destino.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(_inicio.latitude, widget.destino.longitude),
          northeast: LatLng(widget.destino.latitude, _inicio.longitude));
    } else if (_inicio.latitude > widget.destino.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(widget.destino.latitude, _inicio.longitude),
          northeast: LatLng(_inicio.latitude, widget.destino.longitude));
    } else {
      bounds = LatLngBounds(southwest: _inicio, northeast: widget.destino);
    }

    // Animar cámara para que se vean ambos puntos
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa de entregas"),
        backgroundColor: const Color(0xFF1E1F22),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: widget.destino, // Centrado inicialmente en el destino
          zoom: 14,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}