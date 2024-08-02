import 'package:flutter/material.dart';
import 'package:patterns_codelab/data.dart';

void main() {
  runApp(const DocumentApp());
}

class DocumentApp extends StatelessWidget {
  const DocumentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: DocumentScreen(
        document: Document(),
      ),
    );
  }
}

class DocumentScreen extends StatelessWidget {
  final Document document;

  const DocumentScreen({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    var (title, :modified) = document.getMetadata();
    var formattedModifiedDate = formatDate(modified);
    var blocks = document.getBlocks();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Text('Last modified $formattedModifiedDate'),
          Expanded(
            child: ListView.builder(
              itemCount: blocks.length,
              itemBuilder: (context, index) {
                return BlockWidget(block: blocks[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}

class BlockWidget extends StatelessWidget {
  final Block block;

  const BlockWidget({
    super.key,
    required this.block,
  });

  @override
  Widget build(BuildContext context) {
    //  switch express 원본
    //  switch (block.type) {
    //   case 'h1':
    //     textStyle = Theme.of(context).textTheme.displayMedium;
    //   case 'p' || 'checkbox':
    //     textStyle = Theme.of(context).textTheme.bodyMedium;
    //   case _:
    //     textStyle = Theme.of(context).textTheme.bodySmall;
    // }

    return Container(
      margin: const EdgeInsets.all(8),
      child: switch (block) {
        // ` :var text` => block이라는 객체 안에서 text라는 속성값을
        // 분해해서, 또는 뽑아내서 값을 사용하겠다는 의미
        ParagraphBlock(:var text) => Text(text),
        HeaderBlock(:var text) => Text(
            text,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        CheckboxBlock(:var text, :var isChecked) => Row(
            children: [
              Checkbox(value: isChecked, onChanged: (_) {}),
              Text(text),
            ],
          ),
      },
    );
  }
}

String formatDate(DateTime dateTime) {
  var today = DateTime.now();
  var difference = dateTime.difference(today);

  // 날짜 차이를 일 단위로 계산
  var inDays = difference.inDays;
  var inMonths = (inDays / 30).round(); // 대략적인 달 수
  var inYears = (inDays / 365).round(); // 대략적인 년 수

  return switch (difference) {
    Duration(inDays: 0) => 'today',
    Duration(inDays: 1) => 'tomorrow',
    Duration(inDays: -1) => 'yesterday',
    Duration(inDays: var days) when days >= 365 =>
      '${days ~/ 365} years from now',
    Duration(inDays: var days) when days <= -365 =>
      '${(days.abs() ~/ 365)} years ago',
    Duration(inDays: var days) when days >= 30 => '$inMonths months from now',
    Duration(inDays: var days) when days <= -30 =>
      '${inMonths.abs()} months ago',
    Duration(inDays: var days) when days > 7 => '${days ~/ 7} weeks from now',
    Duration(inDays: var days) when days < -7 => '${days.abs() ~/ 7} weeks ago',
    Duration(inDays: var days, isNegative: true) => '${days.abs()} days ago',
    Duration(inDays: var days) => '$days days from now',
  };
}
