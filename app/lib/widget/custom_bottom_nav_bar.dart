import 'package:app/main.dart';
import 'package:app/services/router.dart';
import 'package:app/services/storage-services/auth_storage_service.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 54.0,
      color: const Color.fromRGBO(255, 81, 81, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.cottage_outlined),
            color: Colors.black,
            selectedIcon: const Icon(Icons.cottage),
            iconSize: 32.0,
            onPressed: () => {router.go('/home')},
          ),
          const Padding(padding: EdgeInsets.only(left: 2.0)),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            selectedIcon: const Icon(Icons.account_circle),
            iconSize: 32.0,
            color: Colors.black,
            onPressed: () => {
              router.go('/my-profile'),
            },
          ),
          const Padding(padding: EdgeInsets.only(left: 2.0)),
          IconButton(
            icon: const Icon(Icons.info_outline),
            color: Colors.black,
            iconSize: 32.0,
            onPressed: () => {
              //TODO: Route to info page
            },
          ),
          const Padding(padding: EdgeInsets.only(left: 2.0)),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: Colors.black,
            iconSize: 32.0,
            onPressed: () => {
              //TODO: Route to settings page
            },
          ),
          const Padding(padding: EdgeInsets.only(left: 2.0)),
          IconButton(
            onPressed: () => {getIt<AuthStorageService>().logout()},
            icon: Icon(Icons.logout),
            iconSize: 32,
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
