import 'package:flutter/material.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/pages/friends_home/bloc/friends_home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/pages/home/widgets/chart.dart';
import 'package:logger_app/widgets/fader.dart';
import 'package:marquee_widget/marquee_widget.dart';

class DesktopFriendsHome extends StatelessWidget {
  const DesktopFriendsHome(
      {super.key, required this.state, required this.width});

  final FriendsHomeLoaded state;
  final double width;

  @override
  Widget build(BuildContext context) {
    double padding = 24;
    int axis = width > 1400
        ? 3
        : width > 900
            ? 2
            : 1;

    TextTheme tTheme = Theme.of(context).textTheme;

    return Fader(
      child: Scaffold(
        appBar: AppBar(title: Text(state.friend.username)),
        body: GridView.builder(
          padding: EdgeInsets.all(padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: axis,
            mainAxisExtent: 162,
            crossAxisSpacing: padding,
            mainAxisSpacing: padding,
          ),
          itemCount: state.lists.length,
          itemBuilder: (context, i) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: favColor(
                    context: context,
                    favourite: state.lists[i].favourite,
                  ).withOpacity(0.25),
                  width: 2,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70,
                      child: LineChart(
                        data: state.lists[i].chartData,
                        favourite: state.lists[i].favourite,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Marquee(
                          forwardAnimation: Curves.easeInOut,
                          animationDuration: Duration(
                            milliseconds: (state.lists[i].name.length * 80),
                          ),
                          backDuration: const Duration(milliseconds: 500),
                          backwardAnimation: Curves.easeOutCirc,
                          pauseDuration: const Duration(seconds: 1),
                          child: Text(
                            state.lists[i].name,
                            style: tTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          subtitleCount(state.lists[i].count),
                          style: tTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
