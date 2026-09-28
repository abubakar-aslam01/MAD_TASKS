// Week3.dart - Library Desk Assistant
// Name: Muhammad AbuBakar Roll no: 04072313027

final List<Map<String, dynamic>> books = [
  {
    'title': 'Dart in Action',
    'author': 'Ada',
    'year': 2021,
    'copies': 3,
    'tags': ['dart', 'programming'],
  },
  {
    'title': 'Flutter Basics',
    'author': 'Sam',
    'year': 2023,
    'copies': 0,
    'tags': ['flutter', 'mobile'],
  },
  {
    'title': 'Clean Code',
    'author': 'Martin',
    'year': 2008,
    'copies': 2,
    'tags': ['programming', 'design'],
  },
  {
    'title': 'Algorithms',
    'author': 'Knuth',
    'year': 1968,
    'copies': 1,
    'tags': ['programming', 'math'],
  },
  {
    'title': 'UI Design',
    'author': 'Nora',
    'year': 2019,
    'copies': 4,
    'tags': ['design', 'mobile'],
  },
];

//part1

double lateFee(int daysLate, double ratePerDay) => daysLate * ratePerDay;

String formatTitle(String title, [String? author]) {
  if (author == null) {
    return title;
  }

  return '$title by $author';
}

Map<String, dynamic> makeBook({
  required String title,
  required String author,
  int year = 2024,
  int copies = 1,
}) {
  return {'title': title, 'author': author, 'year': year, 'copies': copies};
}

bool isClassic(int year) => year < 2000;

//part2

List<String> transformAll(List<String> items, String Function(String) fn) {
  return items.map(fn).toList();
}

int Function() makeCounter() {
  int count = 0;

  return () {
    count++;
    return count;
  };
}

double Function(int) makeFeeCalculator(double rate) {
  return (int days) => days * rate;
}

int sumDigits(int n) {
  if (n < 10) {
    return n;
  }

  return (n % 10) + sumDigits(n ~/ 10);
}
//part3

Map<String, int> buildStock() {
  return {
    for (var book in books) book['title'] as String: book['copies'] as int,
  };
}

//partt4

class Box<T> {
  T value;

  Box(this.value);
}

T firstOr<T>(List<T> items, T fallback) {
  if (items.isEmpty) {
    return fallback;
  }

  return items.first;
}

class Pair<A, B> {
  A first;
  B second;

  Pair(this.first, this.second);

  @override
  String toString() {
    return '($first, $second)';
  }
}

//part5

class BookNotFoundException implements Exception {
  final String title;

  BookNotFoundException(this.title);
}

class BookNotAvailableException implements Exception {
  final String title;

  BookNotAvailableException(this.title);
}

void checkOut(Map<String, int> stock, String title) {
  if (!stock.containsKey(title)) {
    throw BookNotFoundException(title);
  }

  if (stock[title]! <= 0) {
    throw BookNotAvailableException(title);
  }

  stock[title] = stock[title]! - 1;
}

Map<String, dynamic> findBook(String title) {
  return books.firstWhere((book) => book['title'] == title);
}

//part6
Future<String> fetchBookOfTheDay() async {
  await Future.delayed(const Duration(seconds: 1));

  return 'Dart in Action';
}

Future<String> fetchBroken() async {
  await Future.delayed(const Duration(milliseconds: 500));

  throw Exception('Server down');
}

void part1() {
  print('--- Part 1 ---');

  print('Late fee: ${lateFee(5, 0.5)}');

  print(formatTitle('Dart in Action'));

  print(formatTitle('Dart in Action', 'Ada'));

  print(makeBook(title: 'Clean Code', author: 'Martin'));

  print(makeBook(title: 'Algorithms', author: 'Knuth', year: 1968));

  print(isClassic(1968));
  print(isClassic(2021));
}

void part2() {
  print('--- Part 2 ---');

  final items = ['Dart in Action', 'Clean Code'];

  final upperCase = transformAll(items, (item) => item.toUpperCase());

  print(upperCase);

  final withExclamation = transformAll(items, (item) => '$item!');

  print(withExclamation);

  final desk1 = makeCounter();
  final desk2 = makeCounter();

  print(desk1());
  print(desk1());
  print(desk1());

  print(desk2());

  final studentFee = makeFeeCalculator(0.25);
  final staffFee = makeFeeCalculator(0.10);

  print('Student fee: ${studentFee(4)}');
  print('Staff fee: ${staffFee(4)}');

  print('Sum of digits: ${sumDigits(116)}');
}

void part3() {
  print('--- Part 3 ---');

  final titles = books.map((book) => book['title'] as String).toList();

  print('Titles: $titles');

  final available =
      books
          .where((book) => (book['copies'] as int) > 0)
          .map((book) => book['title'] as String)
          .toList();

  print('Available: $available');

  final totalCopies = books.fold<int>(
    0,
    (sum, book) => sum + (book['copies'] as int),
  );

  print('Total copies: $totalCopies');

  final years = books.map((book) => book['year'] as int).toList();

  final oldestYear = years.reduce(
    (oldest, year) => year < oldest ? year : oldest,
  );

  print('Oldest year: $oldestYear');

  final sortedBooks = List<Map<String, dynamic>>.of(books);

  sortedBooks.sort((a, b) => (a['year'] as int).compareTo(b['year'] as int));

  final titlesByYear =
      sortedBooks.map((book) => book['title'] as String).toList();

  print('By year: $titlesByYear');

  final stock = buildStock();

  print('Stock: $stock');

  stock.forEach((title, copies) {
    if (copies == 0) {
      print('Out of stock: $title');
    }
  });

  print('Copies of Unknown: ${stock['Unknown'] ?? 0}');

  final allTags = <String>{
    for (var book in books) ...((book['tags'] as List).cast<String>()),
  };

  print('All tags: $allTags');

  final a = {'Dart in Action', 'Clean Code', 'Flutter Basics'};

  final b = {'Clean Code', 'Flutter Basics', 'Algorithms'};

  print('Union: ${a.union(b)}');
  print('Common: ${a.intersection(b)}');
  print('Only in A: ${a.difference(b)}');
}

void part4() {
  print('--- Part 4 ---');

  final intBox = Box<int>(5);
  print('Box<int>: ${intBox.value}');

  final stringBox = Box<String>('dart');
  print('Box<String>: ${stringBox.value}');

  print(firstOr(['Dart in Action', 'Clean Code'], 'none'));

  print(firstOr<String>([], 'z'));

  print(Pair<String, int>('Dart in Action', 3));
}

void part5() {
  print('--- Part 5 ---');

  final stock = buildStock();

  final titles = ['Dart in Action', 'Flutter Basics', 'Unknown Book'];

  for (final title in titles) {
    try {
      checkOut(stock, title);

      print('Checked out: $title');
    } on BookNotAvailableException {
      print('Sorry: "$title" has no copies left');
    } on BookNotFoundException {
      print('Not found: "$title"');
    } finally {
      print('Transaction logged.');
    }
  }

  print('Copies left of Dart in Action: ${stock['Dart in Action']}');

  try {
    findBook('Missing');
  } on StateError {
    print('Search failed: no such book');
  }
}

Future<void> part6() async {
  print('--- Part 6 ---');

  print('Fetching...');

  final book = await fetchBookOfTheDay();

  print('Book of the day: $book');

  try {
    await fetchBroken();
  } catch (e) {
    print('Fetch failed: $e');
  }
}

void main() async {
  part1();
  part2();
  part3();
  part4();
  part5();
  await part6();
}

//reflection questions::

// 1. When would you choose fold over reduce?
// I would choose fold when I want to provide an initial value or when the
// collection might be empty. reduce requires the collection to have an item.

// 2. What does it mean that a closure "captures" a variable? Which variable
// was captured in makeCounter?
// A closure captures a variable when it remembers and can use that variable
// after the surrounding function has finished. In makeCounter, the variable
// captured is count.

// 3. Why must on BookNotAvailableException come before a general catch (e)?
// The specific exception should be handled before a general catch because
// the general catch can catch all exceptions, including BookNotAvailableException.

// 4. Why does forgetting await still compile, but give the wrong result?
// Without await, the function returns a Future<String> instead of the actual
// String result. Dart allows this because Future<String> is a valid value,
// but printing it produces a Future representation instead of the book name.
