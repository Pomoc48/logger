import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:log_app/pages/home/bloc/home_bloc.dart';
import 'package:log_app/pages/home/page.dart';
import 'package:log_app/pages/list/bloc/list_bloc.dart';
import 'package:log_app/pages/list/page.dart';
import 'package:log_app/strings.dart';

void main() async {
  await GetStorage.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc()..add(LoadHome())),
        BlocProvider(create: (context) => ListBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Strings.appName,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.dark,
        ),
        scrollBehavior: const ScrollBehavior().copyWith(
          physics: const BouncingScrollPhysics(),
        ),
        routes: {
          Routes.home: (context) => const HomePage(),
          Routes.list: (context) => const ListPage(),
        },
        initialRoute: Routes.home,
      ),
    ),
  );
}
