import 'package:flutter/material.dart';

class CommentFloatingActionButton extends StatelessWidget {
  const CommentFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => {
        //TODO: Catch url with go router to determine if comment is for a recipe or a step
        //TODO: POST comment to API
      },
      backgroundColor: const Color.fromRGBO(255, 201, 201, 1),
      clipBehavior: Clip.values[1],
      tooltip: 'Post a comment',
      shape: ShapeBorder.lerp(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        0.5,
      ),
      elevation: 4.0,
      child: const Icon(
        Icons.mode_comment_outlined,
        color: Colors.black,
      ),
    );
  }
}
