import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

bool bounce = false;

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => QuestionPageProvider())],
    child: const MyApp(),
  ));
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
      home: Container(
          child: const QuestionPage(title: 'Practice With Conditions')),
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
          children: <Widget>[
            QuestionPrompt(),
            Blocky(),
            CustomPaint(
              painter: MyPainter(),
            ),
            SizedBox(height: 50),
            MultipleChoiceButton(
              title: 'A: block.x == 10',
              answer: false,
            ),
            MultipleChoiceButton(
              title: 'B: block.x <= 10',
              answer: false,
            ),
            MultipleChoiceButton(
              title: 'C: block.x >= 10',
              answer: true,
            ),
            MultipleChoiceButton(
              title: 'D: block.x => 10',
              answer: false,
            )
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
        value: 0, vsync: this, duration: Duration(seconds: 2));
    super.initState();
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _update() {
    if (bounce) {
      _controller.duration = Duration(seconds: 1);
      _controller.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionPageProvider>(
      builder: (context, value, child) {
        _update();
        return AnimatedBuilder(
          animation: _controller.view,
          builder: (context, child) {
            if (!bounce) {
              return Transform.translate(
                  offset: Offset(_controller.value * 200, 0), child: child);
            }
            return Transform.translate(
                offset: Offset(_controller.value * 100, 0), child: child);
          },
          child: Transform.translate(
            offset: Offset(-100, 0),
            child: SizedBox(
                width: 100,
                height: 100,
                child: Container(
                    color: Colors.grey,
                    child: Center(child: Text('MR. BLOCKY')))),
          ),
        );
      },
    );
  }
}

class MultipleChoiceButton extends StatefulWidget {
  final String title;
  final bool answer;
  bool pressed = false;

  MultipleChoiceButton({Key? key, required this.title, required this.answer})
      : super(key: key);

  @override
  State<MultipleChoiceButton> createState() => _MultipleChoiceButtonState();
}

class _MultipleChoiceButtonState extends State<MultipleChoiceButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: widget.pressed
                      ? (widget.answer ? Colors.green : Colors.red)
                      : Colors.yellow[300]),
              onPressed: () {
                if (widget.answer) {
                  bounce = true;
                  context.read<QuestionPageProvider>().update();
                }
                widget.pressed = true;
                setState(() {});
              },
              child: Text(
                widget.title,
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
      children: const [
        SizedBox(height: 50),
        Text(
          'Mr. Block is stuck in a loop that bounces it back and forth. Suppose the line rests at x = 10, which of the following condition would be most appropriate to add in the loop alongside an if statement to bounce Mr. Block on the line?',
          style: TextStyle(color: Colors.yellow),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 50),
      ],
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(50, -120);
    final p2 = Offset(50, 20);
    final paint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class QuestionPageProvider with ChangeNotifier {
  void update() {
    notifyListeners();
  }
}
