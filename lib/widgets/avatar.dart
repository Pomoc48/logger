import 'package:flutter/material.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/functions.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.profileUrl,
    this.size = 40,
    this.state,
    this.pop = false,
  });

  final String? profileUrl;
  final double size;
  final HomeLoaded? state;
  final bool pop;

  @override
  Widget build(BuildContext context) {
    Widget child = (profileUrl is String) ? _content() : _missing();

    if (state != null) {
      return InkWell(
        onTap: () {
          if (pop) Navigator.pop(context);

          updateUrlDialog(
            context: context,
            state: state!,
          );
        },
        borderRadius: BorderRadius.circular(999),
        child: child,
      );
    }

    return child;
  }

  ClipRRect _content() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: size,
        width: size,
        child: Image.network(
          profileUrl!,
          errorBuilder: (
            BuildContext context,
            Object exception,
            StackTrace? stackTrace,
          ) =>
              _missing(),
        ),
      ),
    );
  }

  Widget _missing() {
    return Icon(Icons.account_circle, size: size);
  }
}
