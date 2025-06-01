import 'package:flutter/material.dart';
import 'package:rentora/feature/home/compare_page.dart';
import 'package:rentora/feature/home/comparison_page.dart';
import 'package:rentora/feature/models/home_model.dart';
import 'package:rentora/feature/utils/homes.dart';
import 'package:rentora/feature/home/detail_page.dart';
import 'package:rentora/feature/home/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedType = 'Sotuv';
  final ComparisonService _comparisonService = ComparisonService();
  List<HomeModel> filteredHomes = [];
  bool isSearchActive = false;
  final List<String> filterTypes = [
    'Sotuv',
    'Ijara',
    'Ofis',
    'Uk Asset',
  ];

  @override
  void initState() {
    super.initState();
    filteredHomes =
        allHomes.where((home) => home.type.contains(selectedType)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text('Uylar e\'lonlari'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Badge(
              label: Text(_comparisonService.comparedHomes.length.toString()),
              isLabelVisible: _comparisonService.comparedHomes.isNotEmpty,
              child: const Icon(Icons.compare),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComparePage(
                    comparedHomes: _comparisonService.comparedHomes,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final results = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(
                    allHomes: allHomes,
                  ),
                ),
              );

              if (results != null) {
                setState(() {
                  filteredHomes = results as List<HomeModel>;
                  isSearchActive = true;
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (isSearchActive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      filteredHomes = allHomes
                          .where((home) => home.type.contains(selectedType))
                          .toList();
                      isSearchActive = false;
                    });
                  },
                  child: const Text('Filtrni tozalash',
                      style: TextStyle(color: Colors.blue)),
                ),
              ),
            ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filterTypes.length,
              itemBuilder: (context, index) {
                final type = filterTypes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: SizedBox(
                    width: 120,
                    height: 40,
                    child: ChoiceChip(
                      checkmarkColor: Colors.white,
                      label: Text(
                        type,
                        style: const TextStyle(fontSize: 18),
                      ),
                      selected: selectedType == type,
                      onSelected: (selected) {
                        setState(() {
                          selectedType = type;
                          filteredHomes = allHomes
                              .where((home) => home.type.contains(selectedType))
                              .toList();
                          isSearchActive = false;
                        });
                      },
                      selectedColor: Colors.blue,
                      labelStyle: TextStyle(
                        color:
                            selectedType == type ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredHomes.length,
              itemBuilder: (context, index) {
                final home = filteredHomes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(home: home))),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.asset(
                                home.image,
                                fit: BoxFit.cover,
                                height: 180,
                                width: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(Icons.favorite_border),
                                color: Colors.white,
                                onPressed: () {},
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  home.type,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  home.price,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  "ID: ${home.id}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              home.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    home.address,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildDetailChip(
                                    Icons.door_front_door, home.rooms),
                                _buildDetailChip(
                                    Icons.door_front_door, home.floor),
                                _buildDetailChip(
                                    Icons.square_foot, "${home.area} m²"),
                                IconButton(
                                  icon: const Icon(Icons.compare,
                                      color: Colors.blue),
                                  onPressed: () {
                                    _comparisonService.addToComparison(home);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${home.title} solishtirishga qo\'shildi'),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
