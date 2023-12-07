/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import 'dart:convert';
import 'dart:isolate';
import 'dart:async';
export 'src/dart_json_parsing_in_separate_base.dart';

// TODO: Export any libraries intended for clients of this package.

void decodeJsnMap(List<Object> map) {
  SendPort sendPort = map[0] as SendPort;
  String jsonString = map[1] as String;

  Map<String, dynamic> decoded = jsonDecode(jsonString);
  sendPort.send(decoded);
}

Future<Map<String, dynamic>> parseJsonInIsolate(String jsonStrng) async {
  final reciverPort = ReceivePort();
  final comp = Completer<Map<String, dynamic>>();
  final ilet = await Isolate.spawn<List<Object>>(
    decodeJsnMap,
    [reciverPort.sendPort, jsonStrng],
  );

  reciverPort.listen((message) {
    if (!comp.isCompleted) {
      comp.complete(message);
      reciverPort.close();
      ilet.kill();
    }
  });

  return comp.future;
}




/*
Practice Question 2: JSON Parsing
 in Separate Isolate
Task:
Parse a JSON string in a separate 
isolate and convert it to a map.

Example JSON String:

const jsonString = '''
{
  "language": "Dart",
  "feeling": "love it",
  "level": "intermediate"
}
''';
 */