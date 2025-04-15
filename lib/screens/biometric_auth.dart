// import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';

// class BiometricAuth extends StatefulWidget {
//   const BiometricAuth({super.key});

//   @override
//   _BiometricAuthState createState() => _BiometricAuthState();
// }

// class _BiometricAuthState extends State<BiometricAuth> {
//   final LocalAuthentication _localAuth = LocalAuthentication();
//   bool _isAuthenticated = false;

//   Future<void> _authenticate() async {
//     try {
//       bool canAuthenticate = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();

//       if (!canAuthenticate) {
//         _showPINDialog(); // Use PIN fallback if biometrics are unavailable
//         return;
//       }

//       bool authenticated = await _localAuth.authenticate(
//         localizedReason: "Authenticate using fingerprint, Face ID, or Windows Hello",
//         options: const AuthenticationOptions(
//           biometricOnly: true,
//           useErrorDialogs: true,
//           stickyAuth: true,
//         ),
//       );

//       if (!authenticated) {
//         _showPINDialog(); // If biometrics fail, prompt for PIN
//       } else {
//         setState(() => _isAuthenticated = true);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Authentication Successful!")),
//         );
//       }
//     } catch (e) {
//       print("Error during authentication: $e");
//       _showPINDialog(); // Use PIN fallback in case of error
//     }
//   }

//   Future<void> _showPINDialog() async {
//     TextEditingController pinController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Enter PIN"),
//           content: TextField(
//             controller: pinController,
//             obscureText: true,
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(hintText: "Enter your PIN"),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 if (pinController.text == "1234") { // Hardcoded PIN for demonstration
//                   setState(() => _isAuthenticated = true);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Authentication Successful!")),
//                   );
//                   Navigator.pop(context);
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Incorrect PIN")),
//                   );
//                 }
//               },
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Biometric & PIN Authentication")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               _isAuthenticated ? "Authenticated!" : "Press the button to authenticate",
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _authenticate,
//               child: const Text("Authenticate"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(home: BiometricAuth()));
// }
