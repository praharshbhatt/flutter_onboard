import 'package:flutter/material.dart';
import 'package:flutter_onboard/flutter_onboard.dart';
import 'package:flutter_onboard/src/contants/constants.dart';
import 'package:flutter_onboard/src/models/page_indicator_style_model.dart';
import 'package:flutter_onboard/src/widgets/page_indicator.dart';
import 'package:provider/provider.dart';

class OnBoard extends StatelessWidget {
  /// Data for OnBoard [List<OnBoardModel>]
  /// @Required
  final List<OnBoardModel> onBoardData;

  /// OnTapping skip button action
  /// @Required
  final VoidCallback onSkip;

  /// OnTapping done button action
  ///  @Required
  final VoidCallback onDone;

  /// Controller for [PageView]
  /// @Required
  final PageController pageController;

  /// Title text style
  final TextStyle titleStyles;

  /// Description text style
  final TextStyle descriptionStyles;

  /// OnBoard Image width
  final double imageWidth;

  /// OnBoard Image height
  final double imageHeight;

  /// Skip Button Widget
  final Widget skipButton;

  /// Next Button Widget
  final Widget nextButton;

  /// Next Button Widget
  final Color bottomColor;

  /// Animation [Duration] for transition from one page to another
  /// @Default [Duration(milliseconds:250)]
  final Duration duration;

  /// [Curve] used for animation
  /// @Default [Curves.easeInOut]
  final Curve curve;

  /// [PageIndicatorStyle] dot styles
  final PageIndicatorStyle pageIndicatorStyle;

  const OnBoard({
    Key key,
    @required this.onBoardData,
    @required this.onSkip,
    @required this.onDone,
    @required this.pageController,
    this.titleStyles,
    this.descriptionStyles,
    this.imageWidth,
    this.imageHeight,
    this.skipButton,
    this.bottomColor,
    this.nextButton,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOut,
    this.pageIndicatorStyle = const PageIndicatorStyle(
        width: 150, activeColor: Colors.blue, inactiveColor: Colors.blueAccent, activeSize: Size(12, 12), inactiveSize: Size(8, 8)),
  })  : assert(onBoardData != null),
        assert(onDone != null),
        assert(onSkip != null),
        assert(pageController != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnBoardState>(
      create: (BuildContext context) => OnBoardState(),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Consumer<OnBoardState>(builder: (BuildContext context, OnBoardState state, Widget child) {
                return PageView.builder(
                  controller: pageController,
                  onPageChanged: (page) => state.onPageChanged(page, onBoardData.length),
                  itemCount: onBoardData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              onBoardData[index].title,
                              textAlign: TextAlign.center,
                              style: titleStyles != null
                                  ? titleStyles
                                  : const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              onBoardData[index].description,
                              textAlign: TextAlign.center,
                              style: descriptionStyles != null
                                  ? descriptionStyles
                                  : const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              children: [
                                Image.asset(
                                  onBoardData[index].imgUrl,
                                  width: imageWidth,
                                  height: imageHeight,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),

            //Bottom
            Container(
              color: bottomColor ?? Colors.white,
              child: Column(
                children: [
                  //Indiacators
                  Consumer<OnBoardState>(
                    builder: (BuildContext context, OnBoardState state, Widget child) {
                      return Container(
                        height: pageIndicatorHeight,
                        child: PageIndicator(
                          count: onBoardData.length,
                          activePage: state.page,
                          pageIndicatorStyle: pageIndicatorStyle,
                        ),
                      );
                    },
                  ),

                  //Action buttons
                  Consumer<OnBoardState>(
                    builder: (BuildContext context, OnBoardState state, Widget child) {
                      //Next button
                      return Container(
                        height: footerContentHeight,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(),
                            ButtonTheme(
                              minWidth: 150,
                              height: 50,
                              child: nextButton != null
                                  ? nextButton
                                  : RaisedButton(
                                      shape: StadiumBorder(),
                                      elevation: 0,
                                      color: Colors.blueAccent,
                                      onPressed: () => _onNextTap(state),
                                      child: Text(
                                        state.isLastPage ? "Done" : "Next",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                            ),
                            Container(
                              padding: EdgeInsets.all(12),
                              alignment: Alignment.centerRight,
                              child: skipButton != null
                                  ? skipButton
                                  : FlatButton(
                                      onPressed: onSkip,
                                      child: const Text(
                                        "Skip",
                                        style: const TextStyle(color: Colors.blueAccent),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNextTap(OnBoardState state) {
    if (!state.isLastPage) {
      pageController.animateToPage(
        state.page + 1,
        duration: duration,
        curve: curve,
      );
    } else {
      onDone();
    }
  }
}