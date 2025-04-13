import 'package:flutter/material.dart';
import 'package:sensorlab/models/sensor_card.dart';

class SensorSearchDelegate extends SearchDelegate {
  final List<SensorCard> sensors;

  SensorSearchDelegate({required this.sensors});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results =
        query.isEmpty
            ? sensors
            : sensors
                .where(
                  (sensor) =>
                      sensor.label.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final sensor = results[index];
        return ListTile(
          leading: Icon(sensor.icon, color: sensor.color),
          title: Text(sensor.label),
          subtitle: Text(sensor.category),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => sensor.screen),
            );
          },
        );
      },
    );
  }
}
