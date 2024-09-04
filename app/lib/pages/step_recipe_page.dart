import 'package:app/main.dart';
import 'package:app/services/router.dart';
import 'package:app/services/storage-services/step_storage_service.dart';
import 'package:app/widget/custom_bottom_nav_bar.dart';
import 'package:app/widget/custom_h2_title.dart';
import 'package:app/widget/custom_main_action_button.dart';
import 'package:app/widget/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_button/timer_button.dart';

class StepRecipePage extends StatefulWidget {
  const StepRecipePage({super.key, required this.id, required this.recipeName});
  final int id;
  final String recipeName;

  @override
  State<StepRecipePage> createState() => _StepRecipePageState();
}

class _StepRecipePageState extends State<StepRecipePage> {
  int stepNumber = 0;
  String timerButtonText = 'Minuteur';
  bool showTimer = false;
  FlutterTts _flutterTts = FlutterTts();

  List<Map> _voices = [];
  Map? _currentVoice;
  int? _currentWordStart, _currentWordEnd;

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  void initTTS() {
    _flutterTts.setProgressHandler((text, start, end, word) {
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
      });
    });
    _flutterTts.getVoices.then((data) {
      try {
        _voices = List<Map>.from(data);
        setState(() {
          _voices =
              _voices.where((_voice) => _voice["name"].contains("fr")).toList();
          _currentVoice = _voices.first;
          setVoice(_currentVoice!);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIt<StepStorageService>().getStepRecipe(widget.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError || snapshot.data == null || !snapshot.hasData) {
          return Row(
            children: [
              Text('Error: ${snapshot.error}'),
            ],
          );
        }
        print(snapshot.data![stepNumber].timer);
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 84,
            backgroundColor: Colors.white,
            title: CustomH2Title(text: '${widget.recipeName}'),
            actions: [
              IconButton(
                  onPressed: () => {router.go('/recipe/${widget.id}')},
                  icon: Icon(Icons.close))
            ],
          ),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: (stepNumber + 1) / snapshot.data!.length,
                      color: Color.fromRGBO(250, 82, 82, 100),
                      backgroundColor: Color.fromRGBO(255, 201, 201, 100),
                    ),
                    Text(
                      'Etape ${stepNumber + 1} / ${snapshot.data!.length}',
                      style: GoogleFonts.raleway(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.play_arrow_outlined, size: 24),
                          onPressed: () => {
                            _flutterTts.speak(
                                snapshot.data![stepNumber].stepDescription!)
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.stop_circle_outlined, size: 24),
                          onPressed: () => {_flutterTts.stop()},
                        ),
                        IconButton(
                          icon: Icon(Icons.replay_outlined, size: 24),
                          onPressed: () => {
                            _flutterTts.stop(),
                            _flutterTts.speak(
                                snapshot.data![stepNumber].stepDescription!)
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 64),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 64),
                      child: Text(
                        snapshot.data![stepNumber].stepDescription ?? '',
                        style: const TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Image.asset(
                      snapshot.data![stepNumber].stepCategory == 6
                          ? 'assets/images/6.png'
                          : 'assets/images/${snapshot.data![stepNumber].stepCategory}.gif',
                    ),
                    snapshot.data![stepNumber].timer != null &&
                            snapshot.data![stepNumber].timer != '0'
                        ? CustomMainActionButton(
                            text: 'Minuteur',
                            onPressed: () => {
                                  setState(() {
                                    showTimer = !showTimer;
                                    timerButtonText =
                                        '= ${snapshot.data![stepNumber].timer} min';
                                  })
                                },
                            icon: Icons.timer_outlined)
                        : const SizedBox(),
                    const SizedBox(height: 4),
                    showTimer && timerButtonText != 'Minuteur'
                        ? TimerButton(
                            label: timerButtonText,
                            timeOutInSeconds: int.parse(Duration(
                                    minutes: int.parse(
                                        snapshot.data![stepNumber].timer!))
                                .inSeconds
                                .toString()),
                            timeUpFlag: true,
                            disabledColor: Colors.transparent,
                            disabledTextStyle: GoogleFonts.raleway(
                              color: Colors.black,
                            ),
                            buttonType: ButtonType.outlinedButton,
                            color: Colors.transparent,
                            activeTextStyle: GoogleFonts.raleway(
                              color: Colors.black,
                            ),
                            onPressed: () => {},
                          )
                        : Container(),
                    const SizedBox(height: 8),
                    CustomTextButton(
                        text: 'Suivant',
                        onPressed: () => {
                              print(stepNumber),
                              print(snapshot.data!.length),
                              if (stepNumber < snapshot.data!.length - 1)
                                {
                                  setState(() {
                                    stepNumber++;
                                  })
                                }
                              else
                                {
                                  router.go(
                                      '/recipe/${widget.id}/final?recipeName=${widget.recipeName}')
                                }
                            }),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: IconButton(
              onPressed: () => {
                    if (this.stepNumber > 0)
                      {
                        setState(() {
                          this.stepNumber--;
                        })
                      }
                    else
                      {router.go('/recipe/${widget.id}')}
                  },
              icon: Icon(Icons.keyboard_backspace_rounded)),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          bottomNavigationBar: const CustomBottomNavBar(),
        );
      },
    );
  }
}
