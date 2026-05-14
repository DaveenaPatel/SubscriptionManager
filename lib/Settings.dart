import 'package:flutter/material.dart';
import 'package:project/Registration.dart';
import 'settingsValues.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

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
        title:
        ValueListenableBuilder<String>(
          valueListenable: language,
          builder: (context, lang, _) {
            return Text(translate('settings'), textAlign: TextAlign.center);
          },
        ),
        // Text('Settings', textAlign: TextAlign.center),
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
                child:
                ValueListenableBuilder<String>(
                  valueListenable: language,
                  builder: (context, lang, _) {
                    return Text(translate('darkMode'), style: TextStyle(color: Colors.black));
                  },
                ),
                // Text('Dark Mode', style: TextStyle(color: Colors.black)),
              ),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: theme,
                builder: (context, mode, _) {
                  return Switch(
                    value: mode == ThemeMode.dark,
                    activeColor: Colors.green[900],

                    onChanged: (value) {
                      theme.value = value ? ThemeMode.dark : ThemeMode.light;
                    },
                  );
                },
              ),

              // Switch(
              //   value: light,
              //   // activeColor: Colors.green[900],
              //   activeColor: Color(0xFF7A9E6E),
              //   inactiveThumbColor: Colors.green[300],
              //   onChanged: (bool value) {
              //     setState(() {
              //       light = value;
              //     });
              //   },
              // ),
            ],
          ),
          TextButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Font()),
              ),
            },
            child:
            ValueListenableBuilder<String>(
              valueListenable: language,
              builder: (context, lang, _) {
                return Text(translate('font'), style: TextStyle(color: Colors.black));
              },
            ),
            // Text('Font', style: TextStyle(color: Colors.black)),
          ),

          TextButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Currency()),
              ),
            },
            child:
            ValueListenableBuilder<String>(
              valueListenable: language,
              builder: (context, lang, _) {
                return Text(translate('currency'), style: TextStyle(color: Colors.black));
              },
            ),
            // Text('Currency', style: TextStyle(color: Colors.black)),
          ),

          TextButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Languages()),
              ),
            },
            child:
            ValueListenableBuilder<String>(
              valueListenable: language,
              builder: (context, lang, _) {
                return Text(translate('languages'), style: TextStyle(color: Colors.black));
              },
            ),
            // Text('Languages', style: TextStyle(color: Colors.black)),
          ),

          Spacer(),
          TextButton(
            onPressed: () => {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (r) => false,
              ),
            },
            child:
            ValueListenableBuilder<String>(
              valueListenable: language,
              builder: (context, lang, _) {
                return Text(translate('logOut'), style: TextStyle(fontWeight: FontWeight.w900, fontSize: 40, color: Colors.black));
              },
            ),
            // Text(
            //   'Log Out',
            //   style: TextStyle(
            //     fontWeight: FontWeight.w900,
            //     fontSize: 40,
            //     color: Colors.black,
            //   ),
            // ),
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
        title:
        ValueListenableBuilder<String>(
          valueListenable: language,
          builder: (context, lang, _) {
            return Text(translate('font'), textAlign: TextAlign.center);
          },
        ),
        // Text('Font', textAlign: TextAlign.center),
        backgroundColor: Color(0xFF7A9E6E),
      ),
      body: ValueListenableBuilder<String>(
        valueListenable: font,
        builder: (context, selectedFont, _) {
          return Column(
            children: ['Roboto', 'Margarine', 'Knewave', 'Metamorphous'].map((fonts) {
              return RadioListTile<String>(
                title: Text(
                  fonts,
                  style: GoogleFonts.getFont(fonts),
                ),
                value: fonts,
                groupValue: selectedFont,
                activeColor: Color(0xFF7A9E6E),
                onChanged: (value) {
                  font.value = value!;
                },
              );
            }).toList(),
          );
        },
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
        title:
        ValueListenableBuilder<String>(
          valueListenable: language,
          builder: (context, lang, _) {
            return Text(translate('currency'), textAlign: TextAlign.center);
          },
        ),
        // Text('Currency', textAlign: TextAlign.center),
        backgroundColor: Color(0xFF7A9E6E),
      ),
      body:ValueListenableBuilder<String>(
        valueListenable: currency,
        builder: (context, selectedCurrency, _) {
          return Column(
            children: ['CAD', 'USD'].map((currencies) {
              return RadioListTile<String>(
                title: Text(currencies),
                value: currencies,
                groupValue: selectedCurrency,
                activeColor: Color(0xFF7A9E6E),
                onChanged: (value) {
                  currency.value = value!;
                },
              );
            }).toList(),
          );
        },
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
        title:
        ValueListenableBuilder<String>(
          valueListenable: language,
          builder: (context, lang, _) {
            return Text(translate('languages'), textAlign: TextAlign.center);
          },
        ),
        // Text('Languages', textAlign: TextAlign.center),
        backgroundColor: Color(0xFF7A9E6E),
      ),
      body:
      // Column(
      //   children: [
      //     RadioListTile(
      //       title: Text('English'),
      //       value: 'English',
      //       // groupValue: null,
      //       // onChanged: (value) => onFontChanged(value),
      //     ),
      //     RadioListTile(
      //       title: Text('French'),
      //       value: 'French',
      //       // groupValue: null,
      //       // onChanged: (value) => onFontChanged(value),
      //     ),
      //   ],
      // ),
      ValueListenableBuilder<String>(
        valueListenable: language,
        builder: (context, selectedLanguage, _) {
          return Column(
            children: ['English', 'Français'].map((lang) {
              return RadioListTile<String>(
                title: Text(lang),
                value: lang,
                groupValue: selectedLanguage,
                activeColor: Color(0xFF7A9E6E),
                onChanged: (value) {
                  language.value = value!;
                },
              );
            }).toList(),
          );
        },
      ),


    );
  }
}
