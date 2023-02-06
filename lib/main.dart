import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger_app/pages/friends-list/bloc/friends_bloc.dart';
import 'package:logger_app/pages/friends-list/page.dart';
import 'package:logger_app/pages/friends_home/bloc/friends_home_bloc.dart';
import 'package:logger_app/pages/friends_home/page.dart';
import 'package:logger_app/pages/home/bloc/home_bloc.dart';
import 'package:logger_app/pages/home/page.dart';
import 'package:logger_app/pages/home/widgets/register_view.dart';
import 'package:logger_app/pages/list/bloc/list_bloc.dart';
import 'package:logger_app/pages/list/page.dart';
import 'package:logger_app/strings.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  ThemeData light = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.light,
  );

  ThemeData dark = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.dark,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc()..add(AutoLogin())),
        BlocProvider(create: (context) => ListBloc()),
        BlocProvider(create: (context) => FriendsBloc()),
        BlocProvider(create: (context) => FriendsHomeBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Strings.appName,
        theme: light.copyWith(
          textTheme: GoogleFonts.interTextTheme(light.textTheme),
        ),
        darkTheme: dark.copyWith(
          textTheme: GoogleFonts.interTextTheme(dark.textTheme),
        ),
        scrollBehavior: const ScrollBehavior().copyWith(
          physics: const BouncingScrollPhysics(),
          scrollbars: false,
        ),
        routes: {
          Routes.home: (context) => const HomePage(),
          Routes.list: (context) => const ListPage(),
          Routes.friends: (context) => const FriendsPage(),
          Routes.register: (context) => const RegisterView(),
          Routes.friendsHome: (context) => const FriendsHomePage(),
        },
        initialRoute: Routes.home,
      ),
    ),
  );
}
