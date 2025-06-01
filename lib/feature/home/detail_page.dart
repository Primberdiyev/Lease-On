import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rentora/feature/home/chat_user_page.dart';
import 'package:rentora/feature/models/home_model.dart';

class DetailPage extends StatefulWidget {
  final HomeModel home;

  const DetailPage({super.key, required this.home});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      // Audio fayl manzilini to'g'ri ko'rsating
      await _audioPlayer.play(AssetSource('audios/contract_audio.mp3'));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _showContractDialog(BuildContext context) {
    final contractText = """
    IJARA SHARTNOMASI
    
    1. TOMONLAR:
    Ijarachi: _______________
    Ijara beruvchi: ${'Dilshodbek Primberdiyev' ?? "Ma'lumot kiritilmagan"}
    
    2. IJARA PREDMETI:
    ${widget.home.address} manzilida joylashgan ${widget.home.rooms} xonali kvartira
    
    3. IJARA MUDDATI:
    Shartnoma 1 yil muddatga tuziladi
    
    4. IJARA HAQQI:
    Oylik ijara haqqi: ${widget.home.price}
    To'lov har oyning 10-sanasigacha amalga oshiriladi
    
    5. TOMONLARNING MAJBURIYATLARI:
    - Ijarachi kvartirani berilgan holatida saqlashi shart
    - Ijara beruvchi kommunal xizmatlar to'lovlarini o'z vaqtida amalga oshirishi shart
    - Ijarachi binoga zarar yetkazsa, uni qoplashi shart
    - Ijara beruvchi kerakli ta'mirlash ishlarini o'z vaqtida bajarsih shart
    
    6. QO'SHIMCHA SHARTLAR:
    - Shartnoma muddati tugagach, avtomatik ravishda uzaytiriladi
    - Har ikki tomon ham shartnomani 1 oy oldindan xabar qilgan holda bekor qilishi mumkin
    """;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text(
            'Ijara Shartnomasi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Quyidagi shartnoma bilan diqqat bilan tanishib chiqing:",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  contractText,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 36,
                    color: Colors.blue,
                    onPressed: _toggleAudio,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    iconSize: 36,
                    color: Colors.red,
                    onPressed: () async {
                      await _audioPlayer.stop();
                      setState(() {
                        _isPlaying = false;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(200, 40),
              ),
              onPressed: () {
                Navigator.pop(context);
                _audioPlayer.stop();
                setState(() {
                  _isPlaying = false;
                });
              },
              child: const Text(
                'TUSHUNARLI',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kvartira haqida'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Asosiy rasm
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.home.image,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  color: Colors.grey[200],
                  child: const Icon(Icons.home, size: 50, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Narx va ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.home.price,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "ID: ${widget.home.id}",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Sarlavha
            Text(
              widget.home.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        _buildInfoChip("${widget.home.rooms} xonali"),
                        const SizedBox(width: 8),
                        _buildInfoChip("${widget.home.floor} qavat"),
                        const SizedBox(width: 8),
                        _buildInfoChip("${widget.home.area} m²"),
                      ],
                    );
                  }),
            ),
            const SizedBox(height: 16),

            // Ko'rishlar va vaqt
            Row(
              children: [
                const Icon(Icons.remove_red_eye, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "${widget.home.views} ta ko'rildi",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  widget.home.time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const Divider(height: 32),

            // Manzil bo'limi
            const Text(
              "Manzil",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.home.address,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Xarita joylashuvi
            Stack(
              children: [
                Image.asset('assets/images/map.png'),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    height: 30,
                    width: 250,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Text(
                      widget.home.address,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            // Tavsif bo'limi
            const Center(
              child: Text(
                "Tavsif",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.home.description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const Divider(height: 32),

            // Parametrlar bo'limi
            const Center(
              child: Text(
                "Parametrlar",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                _buildParameterRow(
                    "Xonalar soni", "${widget.home.rooms} xonali"),
                _buildParameterRow("Qavat", widget.home.floor.toString()),
                _buildParameterRow(
                    "Qavatlar soni", "${widget.home.floor} qavat"),
                _buildParameterRow("Umumiy maydon", "${widget.home.area} m²"),
                _buildParameterRow(
                    "Yashash maydoni", "${widget.home.livingArea} m²"),
                _buildParameterRow("Ta'mirlash", widget.home.renovation),
                _buildParameterRow("Uy turi", widget.home.buildingType),
                _buildParameterRow("Hammom", widget.home.bathroomType),
                _buildParameterRow("Balkon", widget.home.balcony),
                _buildParameterRow(
                    "Xavfsizlik", widget.home.security ?? "Mavjud emas"),
              ],
            ),
            const Divider(height: 32),

            // Shartnoma bilan tanishish tugmasi
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _showContractDialog(context),
                  child: const Text(
                    "Kelishuv va shartnomalar bilan tanishish",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bog'lanish tugmasi
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatUserPage()));
                  },
                  child: const Text(
                    "Bog'lanish",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue[800],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildParameterRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
