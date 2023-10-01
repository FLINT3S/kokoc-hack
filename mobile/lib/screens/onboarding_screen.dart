import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/services/onboarding_service.dart';

import '../model/onboarding/data/onboarding_data.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  CarouselController buttonCarouselController = CarouselController();
  int currentPage = 0;

  void onPageChanged(int page, CarouselPageChangedReason reason) {
    setState(() {
      currentPage = page;
    });
  }

  void onPressedNext() {
    if (currentPage == (onboardingData.length - 1)) {
      GetIt.I<OnboardingService>()
          .setOnboardingCompleted()
          .then((value) => {AutoRouter.of(context).replaceNamed('/')});
    } else {
      buttonCarouselController.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: true,
      bottom: true,
      child: Column(
        children: [
          Expanded(
              flex: 7,
              child: CarouselSlider(
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    onPageChanged: onPageChanged,
                    height: MediaQuery.of(context).size.height - 150,
                    enableInfiniteScroll: false,
                    viewportFraction: 1),
                items: onboardingData.map((onboardingItem) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: null,
                          child: Column(children: [
                            Expanded(
                                flex: 6,
                                child: SvgPicture.asset(
                                  onboardingItem.imageAsset,
                                  alignment: Alignment.center,
                                  width: 300,
                                  height: 400,
                                )),
                            Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(onboardingItem.header,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                            fontSize: 32,
                                            color: Theme.of(context)
                                                .primaryColor))),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(onboardingItem.description,
                                      textAlign: TextAlign.center),
                                )
                              ],
                            )
                          ]));
                    },
                  );
                }).toList(),
              )),
          Expanded(
              flex: 2,
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 30),
                  child: Center(
                      child: DotsIndicator(
                    dotsCount: onboardingData.length,
                    position: currentPage,
                  )),
                ),
                SizedBox(
                    width: double.maxFinite,
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: FilledButton(
                          onPressed: onPressedNext,
                          child: Text(currentPage == (onboardingData.length - 1)
                              ? 'Поехали!'
                              : 'Дальше'),
                        )))
              ]))
        ],
      ),
    ));
  }
}
