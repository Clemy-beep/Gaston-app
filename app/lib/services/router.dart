import 'package:app/main.dart';
import 'package:app/pages/add_recipe.dart';
import 'package:app/pages/all_components.dart';
import 'package:app/pages/login.dart';
import 'package:app/pages/my_profile.dart';
import 'package:app/pages/recipe_final.dart';
import 'package:app/pages/recipe_groceries_page.dart';
import 'package:app/pages/recipe_page.dart';
import 'package:app/pages/sign_up.dart';
import 'package:app/pages/signed_home.dart';
import 'package:app/pages/step_recipe_page.dart';
import 'package:app/pages/user_info.dart';
import 'package:app/pages/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) {
      return const HomePage();
    },
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) {
      return const SignedHome();
    },
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) {
      return const Login();
    },
  ),
  GoRoute(
      path: '/sign-up',
      builder: (context, state) {
        return const SignUp();
      }),
  GoRoute(
      path: '/demo',
      builder: (context, state) {
        return const MyHomePage(
          title: 'Bienvenue',
        );
      }),
  GoRoute(
      path: '/add-recipe',
      builder: (context, state) {
        return const AddRecipe();
      }),
  GoRoute(
      path: '/user-profile/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        final username = state.uri.queryParameters['username'];
        return UserProfile(
          id: int.parse(id!),
          username: username ?? '',
        );
      }),
  GoRoute(
      path: '/recipe/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'];
        return MaterialPage(child: RecipePage(id: id));
      }),
  GoRoute(
    path: '/recipe/:id/groceries',
    pageBuilder: (context, state) {
      final id = state.pathParameters['id'];
      final Object extra = state.extra ?? {};
      final String imagePath = state.uri.queryParameters['imagePath'] ?? '';
      return MaterialPage(
          child:
              RecipeGroceriesPage(id: id!, imagePath: imagePath, data: extra));
    },
  ),
  GoRoute(
      path: '/user/:id/info',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'];
        return MaterialPage(child: UserInfoPage(id: id!));
      }),
  GoRoute(
    path: '/recipe/:id/steps',
    pageBuilder: (context, state) {
      final id = state.pathParameters['id'];
      final recipeName = state.uri.queryParameters['recipeName'];
      return MaterialPage(
          child: StepRecipePage(
              id: int.parse(id!), recipeName: recipeName.toString()));
    },
  ),
  GoRoute(
      path: '/recipe/:id/final',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'];
        final recipeName = state.uri.queryParameters['recipeName'];
        return MaterialPage(
            child: RecipeFinalPage(
          id: id!,
          recipeName: recipeName,
        ));
      }),
  GoRoute(
    path: '/my-profile',
    pageBuilder: (context, state) {
      return MaterialPage(child: MyProfile());
    },
  ),
]);
