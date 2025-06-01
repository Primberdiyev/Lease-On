import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  final List<User> users = [
    User(
        name: 'Azizbek Karimov',
        phone: '+998 90 123 45 67',
        avatar: '👨‍💼',
        lookingFor: 'Kvartira',
        preferences: 'Yangi qurilish, 2-3 xonali, Toshkent shahar markazi',
        activeListings: 5,
        imageAsset: 'assets/images/user1.jpeg'),
    User(
        name: 'Nodirbek  Orifjonov',
        phone: '+998 91 234 56 78',
        avatar: '👩‍⚕️',
        lookingFor: 'Uy',
        preferences: 'Hovli, 4 xonali, Yangiyo‘l tumani',
        activeListings: 3,
        imageAsset: 'assets/images/user2.jpeg'),
    User(
        name: 'Jasur Tursunov',
        phone: '+998 93 345 67 89',
        avatar: '👨‍🔧',
        lookingFor: 'Xonadosh',
        preferences: 'Yangi qurilish, alohida xona, Yunusobod tumani',
        activeListings: 2,
        imageAsset: 'assets/images/user5.jpeg'),
    User(
        name: 'Muhammadqodir Abdullajonov',
        phone: '+998 94 456 78 90',
        avatar: '👩‍🎓',
        lookingFor: 'Kvartira',
        preferences: 'Yevrota’mir, 1 xonali, Chilonzor tumani',
        activeListings: 7,
        imageAsset: 'assets/images/user3.jpeg'),
    User(
        name: 'Shahzod Raxmatov',
        phone: '+998 95 567 89 01',
        avatar: '👨‍💻',
        lookingFor: 'Ofis',
        preferences: '100-150 m², Markaziy lokatsiya, yangi qurilish',
        activeListings: 4,
        imageAsset: 'assets/images/user4.jpeg'),
  ];

  UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foydalanuvchilar'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                _showUserDetails(context, user);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipOval(
                      child: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        radius: 32,
                        child: Image.asset(
                          user.imageAsset,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.search,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Qidirayotgan: ${user.lookingFor}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${user.activeListings} ta aktiv e\'lon',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUserDetails(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  radius: 40,
                  child: Text(
                    user.avatar,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  user.phone,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Qidirayotgan turi:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.lookingFor,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Afzalliklari:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.preferences,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Yopish'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${user.phone} ga bog\'lanmoqda...'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Bog\'lanish',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class User {
  final String name;
  final String phone;
  final String avatar;
  final String lookingFor;
  final String preferences;
  final int activeListings;
  final String imageAsset;

  User({
    required this.name,
    required this.phone,
    required this.avatar,
    required this.lookingFor,
    required this.preferences,
    required this.activeListings,
    required this.imageAsset,
  });
}
