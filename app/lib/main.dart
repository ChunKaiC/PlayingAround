import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Question Page',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: Container(child: const QuestionPage(title: 'Sample Question Page')),
    );
  }
}

class QuestionPage extends StatelessWidget {
  final String title;

  const QuestionPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          children: const <Widget>[
            QuestionPrompt(),
            Blocky(),
            SizedBox(height: 50),
            MultipleChoiceButton(title: 'Answer 1'),
            MultipleChoiceButton(title: 'Answer 2'),
            MultipleChoiceButton(title: 'Answer 3'),
            MultipleChoiceButton(title: 'Answer 4')
          ],
        ),
      ),
    );
  }
}

class Blocky extends StatefulWidget {
  const Blocky({Key? key}) : super(key: key);

  @override
  State<Blocky> createState() => _BlockyState();
}

class _BlockyState extends State<Blocky> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _counter = 0;

  @override
  void initState() {
    _controller = AnimationController(
        value: 0, vsync: this, duration: Duration(seconds: 1));
    super.initState();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: (context, child) {
        // return Transform.translate(
        //     offset: Offset(_controller.value + 100, 0), child: child);
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
      },
      child: SizedBox(
          width: 100,
          height: 100,
          child: Container(
              color: Colors.grey, child: Center(child: Text('MR. BLOCKY')))),
    );
  }
}

class MultipleChoiceButton extends StatelessWidget {
  final String title;
  const MultipleChoiceButton({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          child: TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.yellow[300]),
              onPressed: () => print(title + ' Pressed!'),
              child: Text(
                title,
                style: TextStyle(color: Colors.black),
              )),
        )
      ],
    );
  }
}

class QuestionPrompt extends StatelessWidget {
  const QuestionPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        Text(
          'What is the color of the sky?',
          style: TextStyle(color: Colors.yellow),
        ),
        SizedBox(height: 50),
      ],
    );
  }
}
