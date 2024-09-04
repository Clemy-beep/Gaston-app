import 'package:app/services/router.dart';
import 'package:flutter/material.dart';

class AddRecipeFloatingActionButton extends StatelessWidget {
  const AddRecipeFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color.fromRGBO(250, 82, 82, 1),
      elevation: 2.0,
      clipBehavior: Clip.values[1],
      tooltip: 'Create a recipe',
      shape: ShapeBorder.lerp(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        0.5,
      ),
      onPressed: () => {router.go('/add-recipe')},
      child: const Icon(
        Icons.add,
        color: Colors.black,
      ),
    );
  }
}
