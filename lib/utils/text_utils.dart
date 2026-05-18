String splitTitleInTwo(String title) {
  final t = _normalizeSpaces(title);
  final words = t.split(' ');
  if (words.length <= 1) return t;

  const maxWordLen = 18;
  if (words.any((w) => w.length >= maxWordLen)) {
    // не делим, если есть очень длинное слово
    return t;
  }

  final totalLen = t.length;
  var bestIndex = 1;
  var bestDiff = totalLen.toDouble();

  var leftLen = words.first.length;
  for (var i = 1; i < words.length; i++) {
    final diff = (totalLen / 2 - leftLen).abs();
    if (diff < bestDiff) {
      bestDiff = diff;
      bestIndex = i;
    }
    // +1 за пробел между словами
    leftLen += 1 + words[i].length;
  }

  final line1 = words.sublist(0, bestIndex).join(' ');
  final line2 = words.sublist(bestIndex).join(' ');
  return '$line1\n$line2';
}

String _normalizeSpaces(String value) {
  final buffer = StringBuffer();
  var sawSpace = false;

  for (final codeUnit in value.codeUnits) {
    final ch = String.fromCharCode(codeUnit);
    final isSpace = ch.trim().isEmpty;

    if (isSpace) {
      if (!sawSpace) {
        buffer.write(' ');
        sawSpace = true;
      }
    } else {
      buffer.write(ch);
      sawSpace = false;
    }
  }

  return buffer.toString().trim();
}

String fixPrepositions(String text) {
  if (text.isEmpty) return text;

  bool isWhitespace(String ch) => ch.trim().isEmpty;
  final result = StringBuffer();

  var i = 0;
  while (i < text.length) {
    final ch = text[i];

    // Копируем все пробелы/переводы строк как есть
    if (isWhitespace(ch)) {
      result.write(ch);
      i++;
      continue;
    }

    // Читаем слово до следующего пробельного символа
    final start = i;
    while (i < text.length && !isWhitespace(text[i])) {
      i++;
    }
    final word = text.substring(start, i);
    final lower = word.toLowerCase();

    // Если это короткий предлог, за которым идёт ОДИН обычный пробел
    // и дальше не пробел/перевод строки — заменяем пробел на NBSP
    if (_prepsSet.contains(lower) &&
        i < text.length &&
        text[i] == ' ' &&
        i + 1 < text.length &&
        !isWhitespace(text[i + 1])) {
      result.write(word);
      result.write('\u00A0'); // неразрывный пробел
      i++; // пропускаем тот самый обычный пробел
    } else {
      result.write(word);
    }
  }

  return result.toString();
}

final Set<String> _prepsSet = {
  'в','к','с','у','о','а','я','и','но','на','по','за','из','от','до',
  'без','при','над','под','про','об','обо','со','ко','во','для','или',
  '1','2','3','4','5','6','7','8','9',
};