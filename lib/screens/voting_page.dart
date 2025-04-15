import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding
import 'dart:developer'; // For logging

class VotingPage extends StatefulWidget {
  const VotingPage({super.key});

  @override
  VotingPageState createState() => VotingPageState();
}

class VotingPageState extends State<VotingPage> {
  String _userName = "Loading...";
  String _voterId = "Loading...";
  int _selectedIndex = 0; // Track the selected tab index

  // List of elective positions
  final List<String> _positions = [
    "President",
    "Governor",
    "Senator",
    "MP",
    "Women Rep",
    "MCA",
  ];

  // Example list of candidates for each position
  final Map<String, List<Map<String, String>>> _candidates = {
    "President": [
      {"name": "Candidate A", "image": "assets/images/What.jpg"},
      {"name": "Candidate B", "image": "assets/images/What.jpg"},
      {"name": "Candidate C", "image": "assets/images/What.jpg"},
      {"name": "Candidate D", "image": "assets/images/What.jpg"},
      {"name": "Candidate E", "image": "assets/images/What.jpg"},
      {"name": "Candidate F", "image": "assets/images/What.jpg"},
      {"name": "Candidate G", "image": "assets/images/What.jpg"},

    ],
    "Governor": [
      {"name": "Candidate X", "image": "assets/images/gov.jpg"},
      {"name": "Candidate Y", "image": "assets/images/gov.jpg"},
      {"name": "Candidate Z", "image": "assets/images/gov.jpg"},
      {"name": "Candidate W", "image": "assets/images/gov.jpg"},
      {"name": "Candidate V", "image": "assets/images/gov.jpg"},
      {"name": "Candidate U", "image": "assets/images/gov.jpg"},
    ],
    "Senator": [
      {"name": "Candidate 1", "image": "assets/images/sen.jpg"},
      {"name": "Candidate 2", "image": "assets/images/sen.jpg"},
      {"name": "Candidate 3", "image": "assets/images/sen.jpg"},
      {"name": "Candidate 4", "image": "assets/images/sen.jpg"},
      {"name": "Candidate 5", "image": "assets/images/sen.jpg"},
      {"name": "Candidate 6", "image": "assets/images/sen.jpg"},
    ],
    "MP": [
      {"name": "Candidate P", "image": "assets/images/mp.jpg"},
      {"name": "Candidate Q", "image": "assets/images/mp.jpg"},
      {"name": "Candidate R", "image": "assets/images/mp.jpg"},
      {"name": "Candidate S", "image": "assets/images/mp.jpg"},
      {"name": "Candidate T", "image": "assets/images/mp.jpg"},
      {"name": "Candidate U", "image": "assets/images/mp.jpg"},
    ],
    "Women Rep": [
      {"name": "Candidate W1", "image": "assets/images/wmrep.jpg"},
      {"name": "Candidate W2", "image": "assets/images/wmrep.jpg"},
      {"name": "Candidate W3", "image": "assets/images/wmrep.jpg"},
      {"name": "Candidate W4", "image": "assets/images/wmrep.jpg"},
      {"name": "Candidate W5", "image": "assets/images/wmrep.jpg"},
      {"name": "Candidate W6", "image": "assets/images/wmrep.jpg"},
    ],
    "MCA": [
      {"name": "Candidate M1", "image": "assets/images/mca.jpg"},
      {"name": "Candidate M2", "image": "assets/images/mca.jpg"},
      {"name": "Candidate M3", "image": "assets/images/mca.jpg"},
      {"name": "Candidate M4", "image": "assets/images/mca.jpg"},
      {"name": "Candidate M5", "image": "assets/images/mca.jpg"},
      {"name": "Candidate M6", "image": "assets/images/mca.jpg"},
    ],
  };

  // Track selected candidates for each position
  final Map<String, String> _selectedCandidates = {};

  @override
  void initState() {
    super.initState();
    _loadUserSession();
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString("user_name") ?? "Unknown User";
      _voterId = prefs.getString("voter_id") ?? "Unknown";
    });
  }

  // Logout function
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears session data
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login"); // Redirect to login page
    }
  }

  // Navigate to the confirmation page
  void _navigateToConfirmationPage() {
    if (_selectedCandidates.length == _positions.length) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationPage(
            selectedCandidates: _selectedCandidates,
            voterId: _voterId, // Pass voterId as well
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select candidates for all positions."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.green),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.account_circle,
                        size: 80, color: Colors.white),
                    const SizedBox(height: 10),
                    Text(
                      _userName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Voter ID: $_voterId",
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout"),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text("Ballotify"),
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
      body: Column(
        children: [
          // Tab-like buttons for positions
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _positions.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index; // Update selected index
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      color: _selectedIndex == index
                          ? Colors.green
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        _positions[index],
                        style: TextStyle(
                          color: _selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Display candidates for the selected position
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 tiles per row
                  crossAxisSpacing: 10, // Spacing between tiles horizontally
                  mainAxisSpacing: 10, // Spacing between tiles vertically
                  childAspectRatio: 0.8, // Adjust the aspect ratio of the tiles
                ),
                itemCount: _candidates[_positions[_selectedIndex]]!.length,
                itemBuilder: (context, index) {
                  final candidate =
                      _candidates[_positions[_selectedIndex]]![index];
                  final imagePath =
                      candidate["image"] ?? "assets/images/default.jpg";
                  final name = candidate["name"] ?? "Unknown Candidate";
                  final isSelected =
                      _selectedCandidates[_positions[_selectedIndex]] == name;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCandidates[_positions[_selectedIndex]] = name;
                      });
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: isSelected ? Colors.green.withOpacity(0.3) : null,
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10)),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Text("Image not found"),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Submit button
          const Padding(
            padding: EdgeInsets.all(16.0),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToConfirmationPage,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.how_to_vote, color: Colors.white),
        label: const Text(
          "Submit",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}


// Confirmation Page
class ConfirmationPage extends StatelessWidget {
  final Map<String, String> selectedCandidates;
  final String voterId;

  const ConfirmationPage({
    super.key,
    required this.selectedCandidates,
    required this.voterId,
  });

  // Function to submit votes to the backend
  Future<void> _submitVotes(BuildContext context) async {
    const String apiUrl =
        "http://192.168.0.103:8080/submitvote.php"; // Replace with your API URL

    try {
      // Create the request body as a JSON object
      final body = jsonEncode({
        "voter_id": voterId,
        "votes": selectedCandidates,
      });
      log("Sending request to: $apiUrl");
      log("Request body: $body");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json"
        }, // Set content type to JSON
        body: body,
      );

      print("Backend response status code: ${response.statusCode}");
      print("Backend response body: ${response.body}");

      // Check if the response is JSON
      try {
        final responseData = jsonDecode(response.body);
        if (response.statusCode == 200 && responseData["success"]) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Votes submitted successfully!"),
            ),
          );
          Navigator.popUntil(context, (route) => route.isFirst);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(responseData["message"] ?? "Failed to submit votes"),
            ),
          );
        }
      } catch (e) {
        // If JSON decoding fails, log the error and show the raw response
        print("Failed to decode JSON: ${e.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Unexpected response from server: ${response.body}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred -> : ${e.toString()}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirmation"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Selected Candidates",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: selectedCandidates.length,
                itemBuilder: (context, index) {
                  final position = selectedCandidates.keys.elementAt(index);
                  final candidate = selectedCandidates[position];
                  return ListTile(
                    title: Text(position),
                    subtitle: Text(candidate!),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _submitVotes(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Confirm and Submit",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
