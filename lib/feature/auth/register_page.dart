import 'package:flutter/material.dart';
import 'package:rentora/core/services/hive_service.dart';
import 'package:rentora/feature/home/home_page.dart';
import 'package:rentora/feature/models/user_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Map<String, List<String>> regionDistricts = {
    'Toshkent': ['Olmazor', 'Yunusobod', 'Mirzo Ulug\'bek', 'Shayxontohur'],
    'Samarqand': ['Samarqand shahar', 'Oqdaryo', 'Bulung\'ur', 'Pastdarg\'om'],
    'Buxoro': ['Buxoro shahar', 'Olot', 'G\'ijduvon', 'Romitan'],
    'Andijon': ['Andijon shahar', 'Asaka', 'Baliqchi', 'Bo\'ston'],
    'Farg\'ona': ['Farg\'ona shahar', 'Marg\'ilon', 'Qo\'qon', 'Rishton'],
  };

  String? selectedRegion;
  String? selectedDistrict;
  List<String> districts = [];
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final HiveService hiveService = HiveService();
  bool isLoading = false;
  bool showPassword = false;

  Future<void> _register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        selectedRegion == null ||
        selectedDistrict == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Iltimos, barcha maydonlarni to\'ldiring')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final isRegistered = await hiveService.isEmailRegistered(email);
      if (isRegistered) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Bu email allaqachon ro\'yxatdan o\'tgan')),
        );
        return;
      }

      final user = UserModel(
        email: email,
        password: password,
        region: selectedRegion,
        district: selectedDistrict,
      );

      await hiveService.registerUser(user);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xatolik yuz berdi: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: "Ro'yhatdan o'tish ",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  const SizedBox(height: 24),
                  // Email
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F4F8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.email_outlined),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F4F8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_outline),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: passwordController,
                            obscureText: !showPassword,
                            decoration: const InputDecoration(
                              hintText: 'Parol',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Region Selection
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F4F8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_city),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButton<String>(
                                value: selectedRegion,
                                hint: const Text('Viloyatni tanlang'),
                                isExpanded: true,
                                underline: const SizedBox(),
                                items: regionDistricts.keys.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedRegion = newValue;
                                    selectedDistrict = null;
                                    districts = newValue != null
                                        ? regionDistricts[newValue]!
                                        : [];
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // District Selection
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F4F8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButton<String>(
                                value: selectedDistrict,
                                hint: const Text('Tumanni tanlang'),
                                isExpanded: true,
                                underline: const SizedBox(),
                                items: districts.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: selectedRegion == null
                                    ? null
                                    : (String? newValue) {
                                        setState(() {
                                          selectedDistrict = newValue;
                                        });
                                      },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        const Text(
                          "Allaqachon profilim bor!\t\t",
                          style: TextStyle(color: Colors.black),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Kirish",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F365B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: isLoading ? null : _register,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fixedSize: Size(
                        MediaQuery.of(context).size.width - 40,
                        63,
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Ro\'yhatdan o\'tish',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
