import 'package:flutter/material.dart';

class ThemeSwitcherPage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  ThemeSwitcherPage({required this.onThemeChanged, required this.isDarkMode});

  @override
  _ThemeSwitcherPageState createState() => _ThemeSwitcherPageState();
}

class _ThemeSwitcherPageState extends State<ThemeSwitcherPage> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Switcher'),
      ),
      body: Center(
        child: SwitchListTile(
          title: Text('Dark Mode'),
          value: _isDarkMode,
          onChanged: (value) {
            setState(() {
              _isDarkMode = value;
            });
            widget.onThemeChanged(_isDarkMode);
          },
        ),
      ),
    );
  }
}
