import 'package:flutter/material.dart';
import 'package:rentora/feature/home/search_result_page.dart';
import 'package:rentora/feature/models/home_model.dart';

class SearchPage extends StatefulWidget {
  final List<HomeModel> allHomes;

  const SearchPage({
    super.key,
    required this.allHomes,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _dealType = 'Sotuv';
  String _buildingCondition = 'Muhim emas';
  String _renovationType = 'Muhim emas';
  double _minPrice = 0;
  double _maxPrice = 100000;
  double _minArea = 0;
  double _maxArea = 200;
  int _minFloor = 0;
  int _maxFloor = 10;

  bool _hasCameras = false;
  bool _hasIntercom = false;
  bool _hasCodedDoor = false;
  bool _hasFireAlarm = false;
  bool _hasGuard = false;

  bool _nearMosque = false;
  bool _nearSchool = false;
  bool _nearKindergarten = false;
  bool _nearMall = false;
  bool _nearGym = false;
  bool _nearMetro = false;

  final List<String> _dealTypes = ['Sotuv', 'Ijaraga', 'Xonadosh'];
  final List<String> _buildingConditions = [
    'Muhim emas',
    'Ikkilamchi',
    'Yangi qurilish'
  ];
  final List<String> _renovationTypes = [
    'Muhim emas',
    'Kosmetik',
    'Yevro',
    'Dizayn uslubida',
    'Tamirtalab'
  ];

  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _minAreaController = TextEditingController();
  final TextEditingController _maxAreaController = TextEditingController();
  final TextEditingController _minFloorController = TextEditingController();
  final TextEditingController _maxFloorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _minPriceController.text = _minPrice.toString();
    _maxPriceController.text = _maxPrice.toString();
    _minAreaController.text = _minArea.toString();
    _maxAreaController.text = _maxArea.toString();
    _minFloorController.text = _minFloor.toString();
    _maxFloorController.text = _maxFloor.toString();
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minAreaController.dispose();
    _maxAreaController.dispose();
    _minFloorController.dispose();
    _maxFloorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Filtr'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _applyFilters(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Taklif turi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _dealTypes.map((type) {
                return ChoiceChip(
                  selectedColor: Colors.blueAccent,
                  checkmarkColor: Colors.white,
                  label: Text(
                    type,
                    style: TextStyle(
                      color: _dealType == type ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: _dealType == type,
                  onSelected: (selected) {
                    setState(() {
                      _dealType = type;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bino holati',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _buildingConditions.map((condition) {
                return ChoiceChip(
                  selectedColor: Colors.blueAccent,
                  checkmarkColor: Colors.white,
                  label: Text(
                    condition,
                    style: TextStyle(
                      color: _buildingCondition == condition
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  selected: _buildingCondition == condition,
                  onSelected: (selected) {
                    setState(() {
                      _buildingCondition = condition;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Narx oralig\'i (so\'m)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    decoration: InputDecoration(
                      labelText: 'Dan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _minPrice = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    decoration: InputDecoration(
                      labelText: 'Gacha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _maxPrice = double.tryParse(value) ?? 100000;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Ta\'mirlash',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _renovationTypes.map((type) {
                return ChoiceChip(
                  selectedColor: Colors.blueAccent,
                  checkmarkColor: Colors.white,
                  label: Text(
                    type,
                    style: TextStyle(
                      color:
                          _renovationType == type ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: _renovationType == type,
                  onSelected: (selected) {
                    setState(() {
                      _renovationType = type;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Umumiy maydon (m²)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minAreaController,
                    decoration: InputDecoration(
                      labelText: 'Dan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _minArea = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxAreaController,
                    decoration: InputDecoration(
                      labelText: 'Gacha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _maxArea = double.tryParse(value) ?? 200;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Qavat oralig\'i',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minFloorController,
                    decoration: InputDecoration(
                      labelText: 'Dan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _minFloor = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxFloorController,
                    decoration: InputDecoration(
                      labelText: 'Gacha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _maxFloor = int.tryParse(value) ?? 10;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Xavfsizlik',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildCheckbox('Kuzatuv kameralari', _hasCameras,
                (v) => setState(() => _hasCameras = v!)),
            _buildCheckbox('Interkom, Yopiq hudud', _hasIntercom,
                (v) => setState(() => _hasIntercom = v!)),
            _buildCheckbox('Kodlangan eshik', _hasCodedDoor,
                (v) => setState(() => _hasCodedDoor = v!)),
            _buildCheckbox('Yong\'in signalizatsiyasi', _hasFireAlarm,
                (v) => setState(() => _hasFireAlarm = v!)),
            _buildCheckbox(
                'Qo\'riqchi', _hasGuard, (v) => setState(() => _hasGuard = v!)),
            const SizedBox(height: 24),
            const Text(
              'Infratuzilma',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildCheckbox(
                'Masjid', _nearMosque, (v) => setState(() => _nearMosque = v!)),
            _buildCheckbox(
                'Maktab', _nearSchool, (v) => setState(() => _nearSchool = v!)),
            _buildCheckbox('Bolalar bog\'chasi', _nearKindergarten,
                (v) => setState(() => _nearKindergarten = v!)),
            _buildCheckbox('Savdo markazi', _nearMall,
                (v) => setState(() => _nearMall = v!)),
            _buildCheckbox(
                'Fitness', _nearGym, (v) => setState(() => _nearGym = v!)),
            _buildCheckbox('Metro yaqinida', _nearMetro,
                (v) => setState(() => _nearMetro = v!)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _applyFilters(context),
                child: const Text('Qo\'llash',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _applyFilters(BuildContext context) {
    final filteredHomes = widget.allHomes.where((home) {
      final priceStr = home.price.replaceAll(RegExp(r'[^0-9]'), '');
      final price = double.tryParse(priceStr) ?? 0;

      final floorParts = home.floor.split('/');
      final currentFloor = int.tryParse(floorParts[0]) ?? 0;

      if (_dealType != 'Muhim emas' && home.type != _dealType) {
        return false;
      }

      if (price < _minPrice || price > _maxPrice) {
        return false;
      }

      if (home.area < _minArea || home.area > _maxArea) {
        return false;
      }

      if (currentFloor < _minFloor || currentFloor > _maxFloor) {
        return false;
      }

      if (_buildingCondition != 'Muhim emas') {
        if (_buildingCondition == 'Yangi qurilish' &&
            home.buildingType != 'Yangi qurilish') {
          return false;
        }
        if (_buildingCondition == 'Ikkilamchi' &&
            home.buildingType == 'Yangi qurilish') {
          return false;
        }
      }

      if (_renovationType != 'Muhim emas' &&
          home.renovation != _renovationType) {
        return false;
      }

      return true;
    }).toList();

    filteredHomes.sort((a, b) {
      final aScore = _calculateMatchScore(a);
      final bScore = _calculateMatchScore(b);
      return bScore.compareTo(aScore);
    });

    Navigator.pop(context, filteredHomes);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(results: filteredHomes),
      ),
    );
  }

  int _calculateMatchScore(HomeModel home) {
    int score = 0;

    final priceStr = home.price.replaceAll(RegExp(r'[^0-9]'), '');
    final price = double.tryParse(priceStr) ?? 0;

    final floorParts = home.floor.split('/');
    final currentFloor = int.tryParse(floorParts[0]) ?? 0;

    if (home.type == _dealType) score += 10;

    final priceMiddle = (_minPrice + _maxPrice) / 2;
    final priceDiff = (price - priceMiddle).abs();
    score += (10 - (priceDiff / priceMiddle * 10).clamp(0, 10)).toInt();

    final areaMiddle = (_minArea + _maxArea) / 2;
    final areaDiff = (home.area - areaMiddle).abs();
    score += (10 - (areaDiff / areaMiddle * 10).clamp(0, 10)).toInt();

    final floorMiddle = (_minFloor + _maxFloor) / 2;
    final floorDiff = (currentFloor - floorMiddle).abs();
    score += (10 - (floorDiff / floorMiddle * 10).clamp(0, 10)).toInt();

    if (_buildingCondition != 'Muhim emas') {
      if (_buildingCondition == 'Yangi qurilish' &&
          home.buildingType == 'Yangi qurilish') {
        score += 5;
      } else if (_buildingCondition == 'Ikkilamchi' &&
          home.buildingType != 'Yangi qurilish') {
        score += 5;
      }
    }

    if (_renovationType != 'Muhim emas' && home.renovation == _renovationType) {
      score += 5;
    }

    return score;
  }

  Widget _buildCheckbox(
      String title, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}
