import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/movie_model.dart';
import '../repositories/movie_repository_impl.dart';
import './movie_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<MovieModel>>(
        future: context.read<MovieRepositoryImpl>().getUpcoming(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar os filmes."));
          }

          var data = snapshot.data;

          if (data?.isEmpty ?? true) {
            return const Center(
              child: Card(
                  child: Padding(
                padding: EdgeInsets.all(17.0),
                child: Text(
                  'Nenhum filme encontrado ou erro ao carregar. Verifique suas chaves no arquivo .env.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              )),
            );
          }

          return GridView.builder(
              itemCount: data?.length ?? 0,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 4,
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 4,
              ),
              itemBuilder: (context, index) {
                final movie = data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(movie: movie),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FadeInImage(
                      fadeInCurve: Curves.bounceInOut,
                      fadeInDuration: const Duration(milliseconds: 500),
                      image: NetworkImage(movie.getPostPathUrl()),
                      placeholder: const AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}