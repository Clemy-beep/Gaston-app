import 'dart:io';

import 'package:app/pages/step_recipe_form.dart';
import 'package:app/services/model-services/tag_model_service.dart';
import 'package:app/services/router.dart';
import 'package:app/widget/custom_main_action_button.dart';
import 'package:app/widget/custom_subtitle.dart';
import 'package:app/widget/custom_tag.dart';
import 'package:app/widget/custom_text_input.dart';
import 'package:app/widget/custom_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_input/image_input.dart';

class AddRecipeForm extends StatefulWidget {
  final List<TagModelService> allTagsData;

  const AddRecipeForm(this.allTagsData);

  @override
  State<StatefulWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddRecipeForm> {
  String? name;
  String? description;
  String? difficulty;
  String? estimatedTime;
  String? price;
  String? filePath;

  List<int> tags = [];

  File? image;

  List<XFile> imageInputImages = [];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      position: DecorationPosition.background,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.cancel_outlined),
            onPressed: () {
              router.go('/home');
            },
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomH1Title(text: 'Créer une recette'),
                CustomSubtitle(text: 'Informations de base'),
                const Padding(padding: EdgeInsets.all(8)),
                ImageInput(
                  images: imageInputImages,
                  allowMaxImage: 1,
                  onImageSelected: (image) {
                    setState(() {
                      filePath = image.path;
                      if (image.mimeType != 'image/avif' ||
                          image.mimeType != 'image/webp')
                        imageInputImages.add(image);
                      else {
                        print(image.mimeType);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Erreur'),
                              content: const Text(
                                  'Le format de l\'image n\'est pas supporté'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    });
                  },
                  onImageRemoved: (image, index) {
                    setState(() {
                      imageInputImages.remove(image);
                    });
                  },
                ),
                const Padding(padding: EdgeInsets.all(4)),
                CustomTextInput(
                  labelText: 'Nom de la recette',
                  hintText: 'Nom de la recette',
                  onChanged: (value) => {
                    setState(() {
                      name = value;
                    })
                  },
                ),
                const Padding(padding: EdgeInsets.all(4)),
                CustomTextInput(
                  labelText: 'Ingrédents',
                  hintText: 'Ingrédients (séparés par des virgules)',
                  onChanged: (value) => {
                    setState(() {
                      description = value;
                    })
                  },
                  maxlines: 5,
                ),
                const Padding(padding: EdgeInsets.all(4)),
                CustomTextInput(
                  labelText: 'Temps de préparation',
                  hintText: 'Temps de préparation',
                  onChanged: (value) => {
                    setState(() {
                      estimatedTime = value;
                    })
                  },
                ),
                const Padding(padding: EdgeInsets.all(4)),
                CustomTextInput(
                  labelText: "Difficulté",
                  hintText: "DIfficulté sur une échelle de 1 à 5",
                  onChanged: (value) => {
                    difficulty = value,
                    setState(() {
                      difficulty = value;
                    })
                  },
                ),
                const Padding(padding: EdgeInsets.all(4)),
                CustomTextInput(
                  labelText: 'Prix',
                  hintText: 'Coût de la recette',
                  onChanged: (value) => {
                    setState(() {
                      price = value;
                    })
                  },
                ),
                const Padding(padding: EdgeInsets.all(4)),
                Text('Choisissez vos tags',
                    style: GoogleFonts.raleway(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    )),
                Wrap(
                  children: widget.allTagsData
                      .map<Widget>((tag) => InkWell(
                            onTap: () => {
                              setState(() {
                                tag.isSelect = !tag.isSelect;
                                if (tag.isSelect) {
                                  tags.add(tag.idTag);
                                } else {
                                  tags.remove(tag.idTag);
                                }
                              })
                            },
                            child: CustomTag(
                              text: tag.nameTag,
                              color: tag.colorTag,
                              isSelect: tag.isSelect,
                            ),
                          ))
                      .toList(),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                CustomMainActionButton(
                    text: 'Suivant',
                    onPressed: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return StepRecipeForm(
                                name: name,
                                description: description,
                                difficulty: difficulty,
                                estimatedTime: estimatedTime,
                                price: price,
                                tags: tags,
                                filePath: filePath,
                              );
                            }),
                          )
                        },
                    icon: Icons.skip_next),
                const Padding(padding: EdgeInsets.all(16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
