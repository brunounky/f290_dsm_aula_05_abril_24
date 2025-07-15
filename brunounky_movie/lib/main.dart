import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'app.dart';
import 'repositories/movie_repository_impl.dart';
import 'services/http_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(MultiProvider(
    providers: [
      Provider(create: (context) => Dio()),
      Provider(create: (context) => HttpManager(dio: context.read())),
      Provider(
          create: (context) => MovieRepositoryImpl(httpManager: context.read()))
    ],
    child: const App(),
  ));
}