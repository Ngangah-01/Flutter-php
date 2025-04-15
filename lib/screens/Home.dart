import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voting_app_two/screens/login_page.dart';
import 'package:voting_app_two/screens/voting_page.dart';
import 'package:glassmorphism/glassmorphism.dart' as glass;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime electionDate = DateTime(2025, 4, 30); // Election date
  late Timer _timer;
  String _userName = "Loading...";
  String _voterId = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserSession();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {}); // Update countdown every second
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString("user_name") ?? "Unknown User";
      _voterId = prefs.getString("voter_id") ?? "Unknown";
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, "/login");
  }

  String getCountdown() {
    final now = DateTime.now();
    final difference = electionDate.difference(now);
    return "${difference.inHours}:${difference.inMinutes % 60}:${difference.inSeconds % 60}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Column(
          children: [
            // Profile Header
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              accountName: Text(
                _userName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text("Voter ID: $_voterId"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child:
                    Icon(Icons.account_circle, size: 50, color: Colors.green),
              ),
            ),

            // Menu Items
            ListTile(
              leading: const Icon(Icons.home, color: Colors.black),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.how_to_vote, color: Colors.black),
              title: const Text("Election Information"),
              onTap: () {
                // Navigate to election info page (To be implemented)
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.black),
              title: const Text("Voting History"),
              onTap: () {
                // Navigate to voting history page (To be implemented)
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.black),
              title: const Text("Help & Support"),
              onTap: () {
                // Navigate to help page (To be implemented)
              },
            ),

            const Spacer(),

            // Logout Button
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: _logout,
            ),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
        title: const Text("Ballotify", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/votingbg.jpg", fit: BoxFit.cover),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    const Text(
                      "Countdown to Election:",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    glass.GlassmorphicContainer(
                      height: 100,
                      width: 250,
                      borderRadius: 20,
                      blur: 10,
                      alignment: Alignment.center,
                      border: 2,
                      linearGradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 107, 126, 111)
                              .withOpacity(0.1),
                          const Color.fromARGB(255, 130, 156, 130)
                              .withOpacity(0.2)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.5)
                        ],
                      ),
                      child: Text(
                        getCountdown(),
                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Digital7',
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Voting Guidelines",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 0),
                  ],
                ),
              ),
              const SizedBox(height: 0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 400,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 8),
                    ),
                    items: _getGuidelineSlides(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  try {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VotingPage()),
                    );
                  } catch (e) {
                    print("Navigation error: $e");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("VOTE",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Function to Generate 3 Guidelines per Slide
  List<Widget> _getGuidelineSlides() {
    final List<String> guidelines = [
      "Bring your voter ID.",
      "Follow COVID-19 safety guidelines.",
      "Voting closes at 5 PM sharp.",
      "Respect social distancing.",
      "Use the designated ballot box.",
      "Do not take photos inside the voting area.",
      "Ask for help if unsure about the process.",
      "Check your ballot before submitting.",
      "No campaigning inside the voting station."
    ];

    List<List<String>> chunkedGuidelines = [];
    for (int i = 0; i < guidelines.length; i += 3) {
      chunkedGuidelines.add(guidelines.sublist(
          i, (i + 3) > guidelines.length ? guidelines.length : i + 3));
    }

    return chunkedGuidelines.map((guidelineGroup) {
      return Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: guidelineGroup.map((guideline) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  guideline,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }).toList();
  }
}
