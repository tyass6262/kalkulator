import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
      theme: ThemeData.dark(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String output = '0';
  String expression = '';
  int _currentIndex = 0;
  List<String> history = [];

  void calculation(String btnText) {
    setState(() {
      if (btnText == 'AC') {
        output = '0';
        expression = '';
      } else if (btnText == 'D') {
        if (output == '0') return;
        if (output.length > 1) {
          output = output.substring(0, output.length - 1);
          expression = expression.substring(0, expression.length - 1);
        } else {
          output = '0';
          expression = '';
        }
      } else if (btnText == '=') {
        try {
          final exp = Expression.parse(expression);
          final evaluator = ExpressionEvaluator();
          final result = evaluator.eval(exp, {});
          output = result.toString();
          history.add('$expression = $output');
        } catch (e) {
          output = 'Error';
        }
      } else {
        if (output == '0') {
          output = btnText;
          expression = btnText;
        } else {
          output += btnText;
          expression += btnText;
        }
      }
    });
  }

  Widget calcButton(String btnText, Color color) {
    return Container(
      margin: EdgeInsets.all(6),
      child: ElevatedButton(
        onPressed: () => calculation(btnText),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(20),
          backgroundColor: color,
          shadowColor: Colors.black.withOpacity(0.3),
          elevation: 6,
        ),
        child: Text(
          btnText,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? Center(
              child: Container(
                padding: EdgeInsets.all(20),
                constraints: BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Output
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: AnimatedDefaultTextStyle(
                        duration: Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        child: Text(output),
                      ),
                    ),
                    // Grid Buttons
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: 19,
                      itemBuilder: (context, index) {
                        List<String> buttons = [
                          'AC', 'D', '%', '/',
                          '7', '8', '9', '*',
                          '4', '5', '6', '-',
                          '1', '2', '3', '+',
                          '0', '.', '='
                        ];
                        Color color = buttons[index] == '='
                            ? Colors.blue
                            : buttons[index] == 'AC' || buttons[index] == 'D'
                                ? Colors.redAccent
                                : Colors.grey[800]!;

                        return calcButton(buttons[index], color);
                      },
                    ),
                  ],
                ),
              ),
            )
          : _currentIndex == 1
              ? HistoryScreen(history, clearHistory: () => setState(() => history.clear()))
              : ProfileScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calculator'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        backgroundColor: Colors.blue[700],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.blue[300],
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  final List<String> history;
  final VoidCallback clearHistory;

  HistoryScreen(this.history, {required this.clearHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History'), actions: [
        IconButton(icon: Icon(Icons.delete_forever), onPressed: clearHistory),
      ]),
      body: history.isEmpty
          ? Center(child: Text('Riwayat Kosong', style: TextStyle(fontSize: 20)))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  child: ListTile(
                    title: Text(history[index], style: TextStyle(fontSize: 18)),
                  ),
                );
              },
            ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto Profil dengan Border
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueAccent, width: 3),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/imut.PNG'),
                ),
              ),
              SizedBox(height: 15),

              // Nama Aplikasi
              Text(
                'Kalkulator Modern',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 5),

              // Deskripsi Singkat
              Text(
                'Mudah, Cepat, dan Akurat!',
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Informasi Kontak
              Card(
                color: Colors.grey[850],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.email, color: Colors.blueAccent),
                        title: Text('Email'),
                        subtitle: Text('support@kalkulator.com'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.phone, color: Colors.green),
                        title: Text('Telepon'),
                        subtitle: Text('+62 812-3456-7890'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Keterangan Fitur Kalkulator
              Card(
                color: Colors.blue[800],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Fitur Kalkulator',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '✔ Perhitungan cepat & akurat\n'
                        '✔ Riwayat hasil perhitungan\n'
                        '✔ Tampilan modern & mudah digunakan',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Tombol Hubungi Kami
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.contact_mail),
                label: Text('Hubungi Kami'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20), // Tambahkan jarak ekstra untuk memastikan tidak ada overflow
            ],
          ),
        ),
      ),
    );
  }
}
