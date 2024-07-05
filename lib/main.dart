import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        home: LoginScreen(),
      ),
    );
  }
}

class UserProvider extends ChangeNotifier {
  String _username = '';
  String _password = '';

  String get username => _username;
  String get password => _password;

  void login(String username, String password) {
    _username = username;
    _password = password;
    notifyListeners();
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;
                if (username == '2100016029' && password == 'responsi_e') {
                  Provider.of<UserProvider>(context, listen: false)
                      .login(username, password);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  setState(() {
                    _errorMessage = 'Invalid credentials';
                  });
                }
              },
              child: Text('Login'),
            ),
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _bmiResult = '';
  String _bmiCategory = '';
  Color _bmiCategoryColor = Colors.black;

  void _calculateBMI() {
    double weight = double.parse(_weightController.text);
    double height = double.parse(_heightController.text) / 100; // convert cm to m
    double bmi = weight / (height * height);
    setState(() {
      _bmiResult = bmi.toStringAsFixed(2);
      if (bmi < 18.5) {
        _bmiCategory = 'Underweight';
        _bmiCategoryColor = Colors.red; // or Colors.yellow depending on the class
      } else if (bmi >= 18.5 && bmi <= 25) {
        _bmiCategory = 'Normal';
        _bmiCategoryColor = Colors.green;
      } else {
        _bmiCategory = 'Overweight';
        _bmiCategoryColor = Colors.yellow; // or Colors.red depending on the class
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateBMI,
              child: Text('Calculate BMI'),
            ),
            SizedBox(height: 20),
            if (_bmiResult.isNotEmpty)
              Text(
                'BMI: $_bmiResult\nCategory: $_bmiCategory',
                style: TextStyle(color: _bmiCategoryColor, fontSize: 20),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
