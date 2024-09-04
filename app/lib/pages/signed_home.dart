import 'package:app/main.dart';
import 'package:app/services/router.dart';
import 'package:app/services/storage-services/recipies_storage_service.dart';
import 'package:app/services/storage-services/tag_storage_service.dart';
import 'package:app/services/storage-services/user_storage_service.dart';
import 'package:app/widget/add_recipe_floating_action_button.dart';
import 'package:app/widget/carousel.dart';
import 'package:app/widget/custom_bottom_nav_bar.dart';
import 'package:app/widget/custom_h2_title.dart';
import 'package:app/widget/custom_tag.dart';
import 'package:app/widget/custom_title.dart';
import 'package:app/widget/search_input_widget.dart';
import 'package:flutter/material.dart';

class SignedHome extends StatelessWidget {
  const SignedHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder(
                    future: getIt<UserStorageService>().getMe(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return Row(
                        children: [
                          CustomH1Title(
                              text:
                                  'Bienvenue ${snapshot.data?.username ?? ''}'),
                        ],
                      );
                    }),
                SearchInputWidget(
                    labelText: '',
                    hintText: '',
                    controller: TextEditingController(),
                    onSearch: (search) {
                      print('search');
                    }),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: CustomH2Title(text: 'Dernières recettes'),
                    )
                  ],
                ),
                SizedBox(
                  child: FutureBuilder(
                      future: getIt<RecipiesStorageService>().fetchRecipes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return Text('Error: ${snapshot.error}');
                        }
                        if (snapshot.data == null) {
                          return const Text('No recipes');
                        }
                        if (snapshot.data != null && snapshot.data!.isEmpty) {
                          return const Text('No recipes');
                        }
                        return Carousel(recipes: snapshot.data!.toList());
                      }),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: CustomH2Title(text: 'Par tags'),
                    ),
                    IconButton(
                        onPressed: () => router.go('/home'),
                        icon: const Icon(Icons.read_more,
                            size: 36, color: Color.fromRGBO(255, 81, 81, 1)))
                  ],
                ),
                FutureBuilder(
                  future: getIt<TagStorageService>().listTag(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.data == null) {
                      return const Text('No tags');
                    }
                    return Wrap(
                      children: snapshot.data!
                          .map<Widget>((tag) => CustomTag(
                                text: tag.nameTag,
                                color: tag.colorTag,
                                isSelect: true,
                              ))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const AddRecipeFloatingActionButton(),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
