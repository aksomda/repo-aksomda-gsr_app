import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StatisticRoomsScreen extends HookWidget {
  const StatisticRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedMonth = useState('Août 2026');
    final selectedRegion = useState('Centre');

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques & Analytique GsrApp')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtres Analytiques',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedMonth.value,
                    decoration: const InputDecoration(
                      labelText: 'Mois',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Juin 2026', 'Juillet 2026', 'Août 2026']
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (val) => selectedMonth.value = val!,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedRegion.value,
                    decoration: const InputDecoration(
                      labelText: 'Région',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Centre', 'Hauts-Bassins', 'Sahel']
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (val) => selectedRegion.value = val!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Cubage des Demandes Traitées (Salles Gratuites)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildCubeCard('Traitées', '42', Colors.blue),
                _buildCubeCard('En Cours', '12', Colors.orange),
                _buildCubeCard('Rejetées', '3', Colors.red),
                _buildCubeCard('Taux Succès', '84%', Colors.green),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Histogramme de Fréquentation par Structure',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildBar('DGI', 0.7, Colors.indigo),
                  _buildBar('DGTCP', 0.4, Colors.blue),
                  _buildBar('DGB', 0.9, Colors.teal),
                  _buildBar('DSI', 0.5, Colors.cyan),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCubeCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double factor, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 120 * factor,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
