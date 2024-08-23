import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(PuzzleGame());
}

class PuzzleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Puzzle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PuzzleHomePage(),
    );
  }
}

class PuzzleHomePage extends StatefulWidget {
  @override
  _PuzzleHomePageState createState() => _PuzzleHomePageState();
}

class _PuzzleHomePageState extends State<PuzzleHomePage> {
  List<int> tiles = List.generate(16, (index) => index);
  int gridSize = 4;

  @override
  void initState() {
    super.initState();
    shuffleTiles();
  }

  void shuffleTiles() {
    setState(() {
      tiles.shuffle(Random());
    });
  }

  void swapTiles(int index) {
    int emptyIndex = tiles.indexOf(0);
    int rowDifference = (emptyIndex ~/ gridSize) - (index ~/ gridSize);
    int columnDifference = (emptyIndex % gridSize) - (index % gridSize);

    if ((rowDifference.abs() + columnDifference.abs()) == 1) {
      setState(() {
        tiles[emptyIndex] = tiles[index];
        tiles[index] = 0;
      });
    }
  }

  bool isSolved() {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) {
        return false;
      }
    }
    return tiles.last == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Puzzle Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: shuffleTiles,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isSolved())
            Text(
              'You Won!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemCount: tiles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => swapTiles(index),
                  child: Container(
                    margin: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: tiles[index] == 0 ? Colors.white : Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        tiles[index] == 0 ? '' : '${tiles[index]}',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
