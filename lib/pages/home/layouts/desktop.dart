import 'package:flutter/material.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';
import 'package:logger_app/pages/home/widgets/card.dart';

class DesktopHome extends StatelessWidget {
  const DesktopHome({super.key, required this.state, required this.width});

  final HomeLoaded state;
  final double width;

  @override
  Widget build(BuildContext context) {
    double padding = width > 1200 ? 32 : 24;
    int axis = width > 1200 ? 3 : 2;

    return RefreshIndicator(
      onRefresh: () async => refresh(
        context: context,
        token: state.token,
      ),
      child: GridView.builder(
        padding: EdgeInsets.only(
          top: padding,
          left: padding,
          right: padding,
          bottom: padding + 72,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: axis,
          mainAxisExtent: 162,
          crossAxisSpacing: padding,
          mainAxisSpacing: padding,
        ),
        itemBuilder: (context, index) => HomeCard(
          index: index,
          state: state,
        ),
        itemCount: state.tables.length,
      ),
    );
  }
}
