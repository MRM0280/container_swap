import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({Key? key}) : super(key: key);

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {
  final double boxSize = 55;
  Offset? boxPosition;
  double slope = 0;
  double xDistance = 0;
  int tapCount = 0;
  int imageIndex = 0;

  final List<String> images = [
    'https://imagespic2.s3.ir-thr-at1.arvanstorage.com/images/1000_F_276465407_RJGqqshdOOgERH0qmPLuqSsnMp1Rm6M4.jpg',
    'https://imagespic2.s3.ir-thr-at1.arvanstorage.com/images/59e6f68b4b6a194949cd9f1578c1c6e1.jpg',
    'https://imagespic2.s3.ir-thr-at1.arvanstorage.com/76256.jpg',
    'https://imagespic2.s3.ir-thr-at1.arvanstorage.com/images/7bf74df2c5a269a22caee484e5123b82.jpg',
    'https://imagespic2.s3.ir-thr-at1.arvanstorage.com/images/Abstract-rainbow-liquid-background-vector.jpg',
    'https://imagespic2.s3.ir-thr-at1.arvanstorage.com/images/abstract-background-waves-with-candy-color-free-vector.jpg',
    'https://imagespic2.s3.ir-thr-at1.arvanstorage.com/images/abstract-colorful-background-consisting-fluid-2070403.jpg',
    'https://imagespic2.s3.ir-thr-at1.arvanstorage.com/images/abstract-colorful-background-free-vector.jpg',
    'https://imagespic2.s3.ir-thr-at1.arvanstorage.com/images/colorful-abstract-background-free-vector.jpg',
    'https://imagespic2.s3.ir-thr-at1.arvanstorage.com/images/fluid-colorful-background-free-vector.jpg',
    'https://imagespic2.s3.ir-thr-at1.arvanstorage.com/images/istockphoto-1165346702-170667a.jpg',
    'https://imagespic2.s3.ir-thr-at1.arvanstorage.com/images/istockphoto-1200918294-612x612.jpg',
    'https://imagespic2.s3.ir-thr-at1.arvanstorage.com/images/istockphoto-155279804-170667a.jpg',
    'https://imagespic2.s3.ir-thr-at1.arvanstorage.com/images/term-bg-1-3d6355ab.jpg',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // set image index
    Random random = new Random();
    imageIndex = random.nextInt(images.length);
  }

  void moveRight(double slope, int i) {
    Timer.periodic(const Duration(milliseconds: 8), (timer) {
      if (tapCount != i) {
        timer.cancel();
        //Stop moving in this direction when the screen is tapped again
      }
      xDistance = sqrt(2 / (1 + pow(slope, 2)));
      setState(() {
        boxPosition = Offset(
            boxPosition!.dx + xDistance, boxPosition!.dy - slope * xDistance);
      });

      //if the ball bounces off the top or bottom

      if (boxPosition!.dy < 0 ||
          boxPosition!.dy > MediaQuery.of(context).size.height - boxSize) {
        timer.cancel();
        moveRight(-slope, i);
      }
      //if the ball bounces off the right
      if (boxPosition!.dx > MediaQuery.of(context).size.width - boxSize) {
        timer.cancel();
        moveLeft(-slope, i);
      }
    });
  }

  void moveLeft(double slope, int i) {
    Timer.periodic(const Duration(milliseconds: 8), (timer) {
      if (tapCount != i) {
        timer.cancel();
        //Stop moving in this direction when the screen is tapped again

      }
      xDistance = sqrt(2 / (1 + pow(slope, 2)));
      setState(() {
        boxPosition = Offset(
            boxPosition!.dx - xDistance, boxPosition!.dy + slope * xDistance);
      });

      //if the ball bounces off the top or bottom
      if (boxPosition!.dy < 0 ||
          boxPosition!.dy > MediaQuery.of(context).size.height - boxSize) {
        timer.cancel();
        moveLeft(-slope, i);
      }
      //if the ball bounces off the left
      if (boxPosition!.dx < 0) {
        timer.cancel();
        moveRight(-slope, i);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    boxPosition ??= Offset((MediaQuery.of(context).size.width - boxSize) / 2,
        (MediaQuery.of(context).size.height - boxSize) / 2);

    return Scaffold(
      body: Stack(
        children: [
          PositionedTapDetector2(
            onTap: (position) {
              tapCount++;
              // Calculate the slope between the box and the touch point
              slope = (-position.global.dy + boxPosition!.dy) /
                  (position.global.dx - boxPosition!.dx);
              // check the tap direction
              if (position.global.dx < boxPosition!.dx) {
                moveLeft(slope, tapCount);
              }
              if (position.global.dx > boxPosition!.dx) {
                moveRight(slope, tapCount);
              }
            },
          ),

          // Box
          Positioned(
            left: boxPosition!.dx,
            top: boxPosition!.dy,
            child: InkWell(
              onTap: () {
                // change image index
                Random random = new Random();
                imageIndex = random.nextInt(images.length);
              },
              child: Container(
                height: boxSize,
                width: boxSize,
                // image
                child: Image.network(
                  images[imageIndex],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      // image loading
                      return CircularProgressIndicator();
                    }
                    return child;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
