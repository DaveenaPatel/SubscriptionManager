import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Settings(), debugShowCheckedModeBanner: false);
  }
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', textAlign: TextAlign.center),
        backgroundColor: Color(0xFF7A9E6E),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () => {},
                child: Text('Dark Mode', style: TextStyle(color: Colors.black)),
              ),
              Switch(
                value: light,
                activeColor: Colors.green[900],
                onChanged: (bool value) {
                  setState(() {
                    light = value;
                  });
                },
              ),
            ],
          ),
          TextButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Font()),
              ),
            },
            child: Text('Font', style: TextStyle(color: Colors.black)),
          ),

          TextButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Currency()),
              ),
            },
            child: Text('Currency', style: TextStyle(color: Colors.black)),
          ),

          TextButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Languages()),
              ),
            },
            child: Text('Languages', style: TextStyle(color: Colors.black)),
          ),

          Spacer(),
          TextButton(
            onPressed: () => {},
            child: Text(
              'Log Out',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 40,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Font extends StatefulWidget {
  const Font({super.key});

  @override
  State<Font> createState() => _FontState();
}

class _FontState extends State<Font> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Font', textAlign: TextAlign.center),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          RadioListTile(
            title: Text('Roboto'),
            value: 'font1',

            // groupValue: null,
            // onChanged: (value) => onFontChanged(value),
          ),
          RadioListTile(
            title: Text('font2'),
            value: 'font2',
            // groupValue: null,
            // onChanged: (value) => onFontChanged(value),
          ),
        ],
      ),
    );
  }
}

class Currency extends StatefulWidget {
  const Currency({super.key});

  @override
  State<Currency> createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency', textAlign: TextAlign.center),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          RadioListTile(
            title: Text('Cad'),
            value: 'Cad',

            // groupValue: null,
            // onChanged: (value) => onFontChanged(value),
          ),
          RadioListTile(
            title: Text('Usd'),
            value: 'Usd',
            // groupValue: null,
            // onChanged: (value) => onFontChanged(value),
          ),
        ],
      ),
    );
  }
}

class Languages extends StatefulWidget {
  const Languages({super.key});

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Languages', textAlign: TextAlign.center),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          RadioListTile(
            title: Text('English'),
            value: 'English',

            // groupValue: null,
            // onChanged: (value) => onFontChanged(value),
          ),
          RadioListTile(
            title: Text('French'),
            value: 'French',
            // groupValue: null,
            // onChanged: (value) => onFontChanged(value),
          ),
        ],
      ),
    );
  }
}
