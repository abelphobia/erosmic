import 'package:flutter/material.dart';
import 'package:erosmic/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // logo
          DrawerHeader(
            child: Center(
              child: Text(
                "E R O S M I C",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          // home tile
          Padding(
            padding: EdgeInsets.only(left: 30.0, top: 26.0),
            child: ListTile(
              title: const Text(" H O M E "),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),

          // Artists tile
          Padding(
            padding: EdgeInsets.only(left: 30.0, top: 26.0),
            child: ListTile(
              title: const Text(" A R T I S T S "),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),

          // settings
          Padding(
            padding: EdgeInsets.only(left: 30.0, top: 26.0),
            child: ListTile(
              title: const Text(" S E T T I N G S "),
              leading: Icon(Icons.settings),
              onTap: () {
                // pop drawer
                Navigator.pop(context);

                // navigate to settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
