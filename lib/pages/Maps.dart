import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart'; // Assurez-vous d'importer cette bibliothèque si vous utilisez GeoPoint

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _initialPosition = LatLng(48.8588443, 2.2943506); // Position par défaut (Tour Eiffel)
  LatLng? _destination;
  List<LatLng> polylineCoordinates = [];
  late MapController _mapController;
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  late GeoPoint localisation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    _getUserLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Récupération de la variable localisation de type GeoPoint
    localisation = (ModalRoute.of(context)?.settings.arguments as GeoPoint?) ?? GeoPoint(48.8588443, 2.2943506);

    // Initialiser _endController avec la valeur de localisation
    _endController.text = '${localisation.latitude}, ${localisation.longitude}';
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Le service de localisation est désactivé.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Les permissions de localisation sont refusées');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Les permissions de localisation sont refusées de manière permanente, nous ne pouvons pas demander de permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _startController.text = '${position.latitude}, ${position.longitude}';
      _mapController.move(_initialPosition, 13.0);
    });
  }

  Future<void> _setDestinationAndRoute(LatLng destination) async {
    setState(() {
      _destination = destination;
    });

    if (_initialPosition != null && _destination != null) {
      final url = Uri.parse(
          'http://router.project-osrm.org/route/v1/driving/${_initialPosition.longitude},${_initialPosition.latitude};${_destination?.longitude},${_destination?.latitude}?geometries=geojson');
      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final route = data['routes'][0]['geometry']['coordinates'] as List;
          setState(() {
            polylineCoordinates = route.map((point) {
              return LatLng(point[1], point[0]);
            }).toList();
          });

          // Recentre la carte sur la destination
          _mapController.move(_destination!, 13.0);
        } else {
          throw Exception('Failed to load route');
        }
      } catch (e) {
        print('Error fetching route: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          // Carte
          Expanded(
            flex: 2,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _initialPosition,
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                if (polylineCoordinates.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: polylineCoordinates,
                        strokeWidth: 4.0,
                        color: Colors.brown,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    if (_destination != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _destination!,
                        builder: (ctx) => const Icon(
                          Icons.location_pin,
                          color: Colors.black,
                          size: 40.0,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Champs de saisie et boutons
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _startController,
                              decoration: const InputDecoration(
                                labelText: 'Départ',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.my_location),
                            onPressed: _getUserLocation,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _endController,
                        decoration: const InputDecoration(
                          labelText: 'Destination',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          final coords = value.split(',');
                          if (coords.length == 2) {
                            final lat = double.tryParse(coords[0].trim());
                            final lng = double.tryParse(coords[1].trim());
                            if (lat != null && lng != null) {
                              _setDestinationAndRoute(LatLng(lat, lng));
                            }
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        icon: Icon(Icons.directions),
                        onPressed: () {
                          final coords = _endController.text.split(',');
                          if (coords.length == 2) {
                            final lat = double.tryParse(coords[0].trim());
                            final lng = double.tryParse(coords[1].trim());
                            if (lat != null && lng != null) {
                              _setDestinationAndRoute(LatLng(lat, lng));
                            }
                          }
                        },
                        label: Text("Tracer l\'itinéraire"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
