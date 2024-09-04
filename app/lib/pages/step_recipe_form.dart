import 'package:app/main.dart';
import 'package:app/services/model-services/step_model_service.dart';
import 'package:app/services/storage-services/recipies_storage_service.dart';
import 'package:app/widget/custom_bottom_nav_bar.dart';
import 'package:app/widget/custom_dropdown_menu.dart';
import 'package:app/widget/custom_h2_title.dart';
import 'package:app/widget/custom_subtitle.dart';
import 'package:app/widget/custom_text_button.dart';
import 'package:app/widget/custom_title.dart';
import 'package:flutter/material.dart';

import '../widget/custom_main_action_button.dart';
import '../widget/custom_text_input.dart';

class StepRecipeForm extends StatefulWidget {
  const StepRecipeForm(
      {super.key,
      required this.name,
      required this.description,
      required this.difficulty,
      required this.estimatedTime,
      required this.price,
      required this.tags,
      required this.filePath});
  final String? name;
  final String? description;
  final String? difficulty;
  final String? estimatedTime;
  final String? price;
  final String? filePath;
  final List<int> tags;

  @override
  State<StepRecipeForm> createState() => _StepState();
}

class _StepState extends State<StepRecipeForm> {
  int stepNumber = 1;
  int? selectedItem;
  String? biography;
  List<StepModelservice> steps = [];
  List<DropdownItem> myItems = [
    DropdownItem(1, 'Chauffer'), //le four
    DropdownItem(2, 'Mélanger'), // le mixer
    DropdownItem(3, 'Decouper'), // le couteau
    DropdownItem(4, 'Étaler'), // le rouleau
    DropdownItem(5, 'Mijoter'), //le mixer
    DropdownItem(6, 'Préparer'), // rien
  ];

  @override
  Widget build(BuildContext context) {
    String? success;
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      position: DecorationPosition.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(padding: EdgeInsets.all(32)),
                const CustomH1Title(text: 'Créer une recette'),
                const Padding(padding: EdgeInsets.all(4)),
                const CustomSubtitle(text: 'Etapes de la recette'),
                const Padding(padding: EdgeInsets.all(8)),
                CustomTextButton(
                    text: '< Précédent',
                    onPressed: () => Navigator.pop(context)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stepNumber,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CustomH2Title(text: 'Etape N°${index + 1}'),
                        const SizedBox(height: 8),
                        CustomDropdownMenu(
                          items: myItems,
                          hint: 'Choisir un item',
                          dropdownValue: selectedItem ?? myItems[0].key,
                          onChanged: (value) {
                            selectedItem = value;
                            if (index < steps.length) {
                              setState(() {
                                steps[index].stepCategory = value;
                              });
                            } else {
                              setState(() {
                                steps
                                    .add(StepModelservice(stepCategory: value));
                              });
                            }
                          },
                        ),
                        const Padding(padding: EdgeInsets.all(8)),
                        CustomTextInput(
                          labelText: 'Ajouter un chrono (en minutes)',
                          hintText: '(minutes)',
                          maxlines: 1,
                          onChanged: (value) {
                            setState(() {
                              steps[index].timer = value;
                            });
                          },
                        ),
                        const Padding(padding: EdgeInsets.all(8)),
                        CustomTextInput(
                          labelText: 'Décrivez l\'étape',
                          hintText: 'Décrivez l\'étape',
                          maxlines: 3,
                          onChanged: (value) {
                            setState(() {
                              steps[index].stepDescription = value;
                            });
                          },
                        ),
                        const Padding(padding: EdgeInsets.all(16)),
                      ],
                    );
                  },
                ),
                Center(
                  child: Column(
                    children: [
                      CustomTextButton(
                        text: '+ Ajouter une étape',
                        onPressed: () {
                          setState(() {
                            stepNumber++;
                          });
                        },
                      ),
                      const Padding(padding: EdgeInsets.all(8)),
                      CustomMainActionButton(
                        text: 'Terminer',
                        icon: Icons.done_outline,
                        onPressed: () async {
                          for (var step in steps) {
                            step.stepNumber = steps.indexOf(step) + 1;
                          }
                          try {
                            getIt<RecipiesStorageService>().createRecipe(
                                widget.name,
                                widget.description,
                                widget.difficulty,
                                widget.estimatedTime,
                                widget.filePath,
                                steps,
                                widget.tags);
                            setState(() {
                              success = 'Recette créée avec succès';
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                      if (success != null) Text(success!),
                      const Padding(padding: EdgeInsets.all(16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }
}
