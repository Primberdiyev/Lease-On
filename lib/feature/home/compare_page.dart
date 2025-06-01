import 'package:flutter/material.dart';
import 'package:rentora/feature/home/comparison_page.dart';
import 'package:rentora/feature/home/detail_page.dart';
import 'package:rentora/feature/models/home_model.dart';

class ComparePage extends StatelessWidget {
  final List<HomeModel> comparedHomes;

  const ComparePage({super.key, required this.comparedHomes});

  void _showRecommendationDialog(BuildContext context) {
    if (comparedHomes.isEmpty) return;

    HomeModel? bestHome;
    double bestScore = -1;

    for (var home in comparedHomes) {
      double score = 0;

      // Baholash mezonlari
      if (home.price.contains('y.e')) {
        final price = double.tryParse(
                home.price.replaceAll('y.e.', '').replaceAll(' ', '')) ??
            999999;
        score += (20000 - price) / 2000; // Past narx – yaxshi
      }

      score += home.area / 10; // Katta maydon – yaxshi

      if (home.renovation == 'Yevro') score += 3;

      final roomCount =
          int.tryParse(RegExp(r'\d+').stringMatch(home.rooms) ?? '0') ?? 0;
      score += roomCount.toDouble();

      if (score > bestScore) {
        bestScore = score;
        bestHome = home;
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ilovaning Tavsiyasi"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                "✅ Quyidagilar hisobga olindi:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text(
                "• Narxning pastligi",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const Text(
                "• Katta maydon",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const Text(
                "• Yaxshi ta'mir holati (Yevro)",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const Text(
                "• Xonalar soni",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              if (bestHome != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "📌 Ilova tavsiya qiladigan uy:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "🏠 ${bestHome.title}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "💰 ${bestHome.price}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "📍 ${bestHome.address}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "📏 ${bestHome.area} m²",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "🛠️ ${bestHome.renovation}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "🛋️ ${bestHome.rooms}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "📢 Diqqat! Bu ilovaning avtomatik tavsiyasi hisoblanadi. "
                      "Sizning afzalliklaringizdan farq qilishi mumkin.",
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPage(home: bestHome!),
                          ),
                        );
                      },
                      child: const Text(
                        "Tavsiyalangan uyga o'tish",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Yopish"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uylarni solishtirish'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ComparisonService().clearComparison();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: comparedHomes.isEmpty
          ? const Center(
              child: Text(
                'Solishtirish uchun uylar tanlanmagan',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: comparedHomes.length,
                    itemBuilder: (context, index) {
                      final home = comparedHomes[index];
                      return Container(
                        width: 200,
                        height: 300,
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                home.image,
                                width: 180,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              home.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // Parametrlar ro'yxati
                Expanded(
                  child: ListView(
                    children: [
                      _buildComparisonRow(
                          'Narx', comparedHomes.map((e) => e.price).toList()),
                      _buildComparisonRow('Manzil',
                          comparedHomes.map((e) => e.address).toList()),
                      _buildComparisonRow('Maydoni',
                          comparedHomes.map((e) => '${e.area} m²').toList()),
                      _buildComparisonRow('Xonalar',
                          comparedHomes.map((e) => e.rooms).toList()),
                      _buildComparisonRow(
                          'Qavat', comparedHomes.map((e) => e.floor).toList()),
                      _buildComparisonRow('Ta\'mirlash',
                          comparedHomes.map((e) => e.renovation).toList()),
                      _buildComparisonRow('Xavfsizlik',
                          comparedHomes.map((e) => e.security ?? '-').toList()),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showRecommendationDialog(context),
                  icon: const Icon(
                    Icons.recommend,
                    size: 30,
                  ),
                  label: const Text(
                    "Ilovaning Tavsiyasi",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
    );
  }

  Widget _buildComparisonRow(String title, List<String> values) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: values
                    .map((value) => Container(
                          width: 180,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
