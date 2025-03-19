/// Возвращает строку для печатной строки в зависимости от количества текста.
/// @texts = Список текстов для размещения на строке.
/// @proportions = Список пропорций между (1 и 100) %.
/// @fontSize = FontSize.normal
static List<int> row({
required List<String> texts,
required List<int> proportions,
FontSize fontSize = FontSize.normal,
AlignPos align = AlignPos.left,
}) {
String textadd = "";
String reset = '\x1B@';
String enter = "\n";

// Проверка на одинаковое количество текстов и пропорций
if (proportions.length != texts.length) {
String msj = "error: La cantidad de proporciones y texts debe ser mayor igual (proportions: ${proportions.length} texts: ${texts.length})";
throw Exception(msj);
}

// Проверка на корректную сумму пропорций
int totalProporciones = 0;
for (int p in proportions) {
totalProporciones += p;
}

// Константы для разных шрифтов
const cFontNormal = '\x1b\x4d\x00'; // Стандартный шрифт ASCII (2)
const cFontCompressed = '\x1b\x4d\x01'; // Сжатый шрифт
const cDoubleHeightFont = '\x1d\x21\x11'; // Двойная высота шрифта
const cDoubleWidthFont = '\x1d\x21\x22'; // Двойная ширина шрифта
const cBigFont = '\x1d\x21\x33'; // Большой шрифт
const cTripleHeightFont = '\x1d\x21\x33'; // Тройная высота шрифта

// Для бумаги 58 мм
String fontSizeCode = "";
int maxCaracteres = 48; // для обычного размера шрифта

switch (fontSize) {
case FontSize.compressed:
maxCaracteres = 64;
fontSizeCode = cFontCompressed;
break;
case FontSize.normal:
maxCaracteres = 48;
fontSizeCode = cFontNormal;
break;
case FontSize.doubleWidth:
maxCaracteres = 32;
fontSizeCode = cDoubleWidthFont;
break;
case FontSize.doubleHeight:
maxCaracteres = 32;
fontSizeCode = cDoubleHeightFont;
break;
case FontSize.big:
maxCaracteres = 24;
fontSizeCode = cBigFont;
break;
case FontSize.superBig:
maxCaracteres = 16;
fontSizeCode = cTripleHeightFont;
break;
// Добавим поддержку бумаги 58 мм
case FontSize.size58:
maxCaracteres = 32; // Можно настроить в зависимости от того, сколько символов вмещается на бумаге 58 мм
fontSizeCode = cFontNormal; // Можно использовать другой шрифт, если требуется
break;
}

if (totalProporciones != 100) {
String msj = "error: el total de proporciones debe ser igual a 100% ($totalProporciones %)";
throw Exception(msj);
}

// Применение команд в зависимости от выравнивания
const cAlignLeft = '\x1Ba0'; // Выравнивание по левому краю
const cAlignCenter = '\x1Ba1'; // Выравнивание по центру
const cAlignRight = '\x1Ba2'; // Выравнивание по правому краю

String alignmentCode = "";
if (align == AlignPos.left) {
alignmentCode = cAlignLeft;
} else if (align == AlignPos.center) {
alignmentCode = cAlignCenter;
} else if (align == AlignPos.right) {
alignmentCode = cAlignRight;
}

// Формирование строки с учётом пропорций
textadd = "";
List<int> caracteres = [];
for (int proporcion in proportions) {
int ctrs = (proporcion * maxCaracteres) ~/ 100;
caracteres.add(ctrs);
}

// Формируем текст для каждой части с учётом количества символов
for (int i = 0; i < texts.length; i++) {
String text = texts[i];
int ctrs = caracteres[i];
if (text.length >= ctrs) {
text = "${text.substring(0, ctrs - 2)}  "; // Обрезаем текст до нужной длины, добавляем пробелы
} else {
int espacios = ctrs - text.length;
for (int j = 0; j < espacios; j++) {
text += " "; // Добавляем пробелы, если текста недостаточно
}
}

textadd += text;
}

// Формируем итоговую строку с кодами для шрифта, выравнивания и текста
String textfinal = "$reset$fontSizeCode$alignmentCode$textadd$enter";

return textfinal.codeUnits;
}