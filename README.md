# sealed에 대한 개념

### sealed에 대한 기능
- sealed이란 `봉인하다` 라는 의미인데 가장 먼저 super class를 생성한 뒤에 class 앞에 sealed을 붙이게 되면 클래스를 봉인하게 된다.
처음엔 이게 무슨 의미가 있지라고 고민을 했는데 봉인을 하게되면 다음과 같은 효과를 얻을수있다. (2가지)

- 클래스를 봉인하게 되면 컴파일에만 코드를 칠수있으며 런타임시에는 코드를 등록할수없게 된다.
- 강제성이 부여가 되기때문에 인터페이스 마냥 `extends <봉인한 클래스>`로 등록한 클래스는 무조건 다 구현해주어야 한다.

### sealed 사용방법
```
[data.dart]
sealed class Block {
  Block();

  factory Block.fromJson(Map<String, Object?> json) {
    return switch (json) {
      {'type': 'h1', 'text': String text} => HeaderBlock(text),
      {'type': 'p', 'text': String text} => ParagraphBlock(text),
      {'type': 'checkbox', 'text': String text, 'checked': bool checked} =>
        CheckboxBlock(text, checked),
      _ => throw const FormatException('Unexpected JSON format'),
    };
  }
}

class HeaderBlock extends Block {
  final String text;
  HeaderBlock(this.text);
}

class ParagraphBlock extends Block {
  final String text;
  ParagraphBlock(this.text);
}

class CheckboxBlock extends Block {
  final String text;
  final bool isChecked;
  CheckboxBlock(this.text, this.isChecked);
}
```
-> 이렇게 선언해두고 main.dart안에서 사용하려면 HeaderBlock / ParagraphBlock / CheckboxBlock 을 모두 구현해주어야 한다.
```
class BlockWidget extends StatelessWidget {
  final Block block;

  const BlockWidget({
    super.key,
    required this.block,
  });

  @override
  Widget build(BuildContext context) {

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
```
-> 특히나 이 부분에 대해서 `final Block block` 을 매개변수로 받는데 block을 받아서 `Container` 안에서 HeaderBlock / ParagraphBlock / CheckboxBlock 를 구현해주어야 한다. 