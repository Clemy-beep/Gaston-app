import 'package:app/main.dart';
import 'package:app/services/router.dart';
import 'package:app/services/storage-services/user_storage_service.dart';
import 'package:app/widget/custom_app_bar.dart';
import 'package:app/widget/custom_bottom_nav_bar.dart';
import 'package:app/widget/custom_text_button.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key, required this.id});
  final String id;

  @override
  State<UserInfoPage> createState() => _UserInfoPage();
}

class _UserInfoPage extends State<UserInfoPage> {
  bool modify = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getIt<UserStorageService>().getUser(int.parse(widget.id)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError || snapshot.data == null || !snapshot.hasData) {
            return Row(
              children: [
                Text('Error: ${snapshot.error}'),
                CustomTextButton(
                    text: 'Retourner à l\'accueil',
                    onPressed: () => router.go('/home'))
              ],
            );
          }
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 104),
              child: CustomAppBar(links: [
                LinkModel(
                  text: 'Son profil',
                  onPressed: () {
                    router.go(
                        '/user-profile/${snapshot.data!.idUser}?username=${snapshot.data!.username}');
                  },
                ),
                LinkModel(
                  text: 'Ses infos',
                  onPressed: () {
                    router.go('/user/${snapshot.data!.idUser}/info');
                  },
                )
              ], text: 'Profil de ${snapshot.data!.username}'),
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                child: Center(
                  child: Column(
                    children: [
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16)),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(124.0),
                        child: Image.network(
                          snapshot.data!.avatar! == '{}'
                              ? 'https://icons.veryicon.com/png/o/miscellaneous/common-icons-31/default-avatar-2.png'
                              : snapshot.data!.avatar!,
                          fit: BoxFit.cover,
                          height: 160,
                          width: 160,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_2_outlined,
                            color: Color.fromRGBO(250, 82, 82, 100),
                            size: 24,
                          ),
                          Text(
                            "Pseudo: ${snapshot.data!.username} ",
                            style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: Color.fromRGBO(250, 82, 82, 100),
                            size: 24,
                          ),
                          Text(
                            "Email: ${snapshot.data!.email} ",
                            style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            color: Color.fromRGBO(250, 82, 82, 100),
                            size: 24,
                          ),
                          Text(
                            "Inscrit depuis le: ${snapshot.data!.createdAt} ",
                            style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: const CustomBottomNavBar(),
          );
        });
  }
}
