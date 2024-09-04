import 'dart:io';

import 'package:app/main.dart';
import 'package:app/pages/add_recipe_form.dart';
import 'package:app/services/model-services/tag_model_service.dart';
import 'package:app/services/storage-services/tag_storage_service.dart';

import 'package:flutter/material.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({Key? key}) : super(key: key);

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  String? name;
  String? description;
  String? difficulty;
  String? estimatedTime;
  String? price;
  String? filePath;

  List<int> tags = [];
  List<TagModelService>? allTagsData;

  File? image;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getIt<TagStorageService>().listTag(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            // List<DropdownItem> items = [];
            // snapshot.data!.forEach((tag) {
            //   items.add(DropdownItem(tag.idTag, tag.nameTag));
            // });

            //! test
            // setState(() {
            allTagsData = snapshot.data;
            // });

            return (AddRecipeForm(allTagsData!));
          }
          return (const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )); //yolo il devrait jamais finir ca vie ici
        });
  }
}
