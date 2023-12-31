// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: Inicio(),
      ),
    ),
  );
}

final cronometroProvider = StateProvider((ref) => true);
final elapsedProvider = StateProvider((ref) => Duration.zero);

class Inicio extends ConsumerWidget {
  Stopwatch stopwatch = Stopwatch();
  Duration elapsed = Duration.zero;

  void cronometroAction(WidgetRef ref) {
    ref.read(elapsedProvider.notifier).state = stopwatch.elapsed;
    Timer(const Duration(milliseconds: 1), () => cronometroAction(ref));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isOn = ref.watch(cronometroProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cronômetro'),
        leading: ElevatedButton(
          child: Icon(Icons.info),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Sobre()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Image(
              image: AssetImage("timer.jpg"),
              width: 250,
              height: 250,
            ),
            Consumer(
              builder: (context, ref, _) {
                final elapsed = ref.watch(elapsedProvider);
                return Text(elapsed.toString());
              },
            ),
            ElevatedButton(
                onPressed: () {
                  ref.read(cronometroProvider.notifier).state = !isOn;

                  if (isOn == true) {
                    stopwatch.start();
                    cronometroAction(ref);
                  } else {
                    stopwatch.stop();
                  }
                },
                child: Text('Iniciar/Pausar')),
          ],
        ),
      ),
    );
  }
}

class Sobre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
        leading: ElevatedButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Image(
              image: AssetImage("timer.jpg"),
              width: 250,
              height: 250,
            ),
            Text('Cronômetro'),
            Text('Versão 1.0'),
            Text('Desenvolvido por:'),
            Text('Gabriel da Silva Azevedo'),
            Text('07/2023'),
          ],
        ),
      ),
    );
  }
}
