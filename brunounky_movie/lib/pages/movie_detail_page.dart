import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/movie_model.dart';
import '../repositories/movie_repository_impl.dart';

class MovieDetailPage extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  double _currentRating = 0.0;
  bool _isLoading = false;

  void _submitRating() async {
    if (_currentRating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Selecione uma avaliação antes de enviar.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await context.read<MovieRepositoryImpl>().addRating(
          widget.movie.id.toString(),
          _currentRating,
        );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Avaliação enviada com sucesso'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Falha ao enviar avaliação. Verifique seu token.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(widget.movie.getPostPathUrl()),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              widget.movie.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              widget.movie.overview,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),

            const Text(
              'Sua Avaliação:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _currentRating,
                    min: 0.0,
                    max: 10.0,
                    divisions: 20,
                    label: _currentRating.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _currentRating = value;
                      });
                    },
                  ),
                ),
                Text(
                  _currentRating.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitRating,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                      child: const Text('Avaliar o Filme'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}