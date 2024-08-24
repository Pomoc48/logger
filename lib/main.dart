import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger_app/bloc/list_bloc.dart';
import 'package:logger_app/pages/home/page.dart';
import 'package:logger_app/pages/list/page.dart';
import 'package:logger_app/strings.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  ColorScheme defaultLightColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
  );

  ColorScheme defaultDarkColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
  );

  runApp(
    DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      ThemeData light = ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme ?? defaultLightColorScheme,
      );

      ThemeData dark = ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme ?? defaultDarkColorScheme,
      );

      return BlocProvider(
        create: (context) => ListBloc()..add(LoadHome()),
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
          },
          onGenerateRoute: (settings) {
            if (settings.name == Routes.list) {
              return MaterialPageRoute(
                builder: (_) => ListPage(id: settings.arguments as Key),
              );
            }

            return null;
          },
          initialRoute: Routes.home,
        ),
      );
    }),
  );
}
