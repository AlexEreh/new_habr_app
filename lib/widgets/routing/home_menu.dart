import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover),
              ),
              // child: Text("Puk"), // TODO: Add user icon if auth
              alignment: Alignment.bottomLeft,
            ),
          ),
          ListTile(
            trailing: const Icon(Icons.settings),
            title: Text(localization.settings),
            onTap: () => Navigator.popAndPushNamed(context, "settings"),
          ),
          ListTile(
            trailing: const Icon(Icons.archive),
            title: Text(localization.cachedArticles),
            onTap: () => Navigator.popAndPushNamed(context, 'articles/cached'),
          ),
          ListTile(
            trailing: const Icon(Icons.bookmark),
            title: Text(localization.bookmarks),
            onTap: () =>
                Navigator.popAndPushNamed(context, 'articles/bookmarks'),
          ),
          ListTile(
            trailing: const Icon(Icons.filter_alt),
            title: Text(localization.filters),
            onTap: () => Navigator.popAndPushNamed(context, 'filters'),
          ),
        ],
      ),
    );
  }
}

class DesktopHomeMenu extends StatelessWidget {
  const DesktopHomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover),
              ),
              // child: Text("Puk"), // TODO: Add user icon if auth
              alignment: Alignment.bottomLeft,
            ),
          ),
          ListTile(
            trailing: const Icon(Icons.settings),
            title: Text(localization.settings),
            onTap: () => Navigator.pushNamed(context, "settings"),
          ),
          ListTile(
            trailing: const Icon(Icons.archive),
            title: Text(localization.cachedArticles),
            onTap: () => Navigator.pushNamed(context, 'articles/cached'),
          ),
          ListTile(
            trailing: const Icon(Icons.bookmark),
            title: Text(localization.bookmarks),
            onTap: () => Navigator.pushNamed(context, 'articles/bookmarks'),
          ),
          ListTile(
            trailing: const Icon(Icons.filter_alt),
            title: Text(localization.filters),
            onTap: () => Navigator.pushNamed(context, 'filters'),
          ),
        ],
      ),
    );
  }
}
