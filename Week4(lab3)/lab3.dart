// lab3.dart - Campus Cafe Order System
// Name: MUHAMMAD ABUBAKAR Roll no: 04072313027
const String rollNo = '04072313027';

final int seed = int.parse(rollNo.substring(rollNo.length - 2));
final int t = seed ~/ 10;
final int u = seed % 10;
const List<String> menu = [
  'Chai',
  'Latte',
  'Mocha',
  'Samosa',
  'Brownie',
  'Sandwich',
  'Cold Coffee',
  'Fries',
  'Pakora',
  'Zinger Wrap',
];
int priceOf(int i) => 100 + 7 * i + 3 * t; // price of menu[i], in rupees
final int priceFloor = 60 + 5 * t;
final int taxPercent = 5 + t;
final int bigOrderLimit = 450 + 20 * t;
final int balanceCap = 600 + 20 * t;
final int couponPercent = 5 + t + u;

// stepp1 : dish

class Dish {
  late String name;
  late int price;
}

// step 2 3 and 8
class MenuItem {
  String name;
  int price;

  // Verbose version (Task 2.1), replaced by the shorthand below:
  // MenuItem(String name, int price) { this.name = name; this.price = price; }

  MenuItem(this.name, this.price) {
    if (this.price < priceFloor) {
      this.price = priceFloor;
    }
  }

  // giveaway items
  MenuItem.free(this.name) : price = 0;

  // text like 'chai:135'
  MenuItem.fromString(String text)
    : name = text.split(':')[0],
      price = int.parse(text.split(':')[1]);

  @override
  String toString() => '$name (Rs $price)';
}

// step4

class OrderLog {
  static OrderLog? _instance;
  final List<String> entries = [];

  OrderLog._internal();

  factory OrderLog() {
    _instance ??= OrderLog._internal();
    return _instance!;
  }

  void add(String msg) => entries.add(msg);
}

// stepp5 and 6

class OrderLine {
  final MenuItem item;
  final int qty;
  final int total;
  final int tax;

  OrderLine(this.item, this.qty)
    : total = item.price * qty,
      tax = item.price * qty * taxPercent ~/ 100,
      assert(qty > 0, 'qty must be positive');

  //getters
  int get grand => total + tax;
  bool get isBigOrder => grand > bigOrderLimit;
  String get label => '${item.name} x$qty';
}

OrderLine mainOrder() {
  return OrderLine(MenuItem(menu[u], priceOf(u)), 2 + (t + u) % 5);
}

// step7
class StudentCard {
  final String owner;
  int _balance;

  StudentCard(this.owner) : _balance = 0;

  int get balance => _balance;

  set balance(int v) {
    if (v < 0) {
      _balance = 0;
    } else if (v > balanceCap) {
      _balance = balanceCap;
    } else {
      _balance = v;
    }
  }
}

// step8
List<MenuItem> buildMenu() {
  return [
    for (int k = 0; k < 4; k++)
      MenuItem.fromString(
        '${menu[(u + 3 * k) % 10]}:${priceOf((u + 3 * k) % 10)}',
      ),
  ];
}

// step9
List<OrderLine> buildReceipt() {
  final items = buildMenu().take(3).toList();
  return [for (int k = 0; k < 3; k++) OrderLine(items[k], 1 + (t + k) % 4)];
}

// stepp10
class Coupon {
  static final Map<String, Coupon> _cache = {};

  final String code;
  final int percent;
  final int minSpend;

  Coupon(this.code, this.percent)
    : minSpend = percent * 70,
      assert(percent >= 1 && percent <= 50, 'percent must be 1 to 50');

  factory Coupon.fromCode(String code) {
    return _cache.putIfAbsent(code, () => Coupon(code, couponPercent));
  }

  int discountOn(int amount) {
    if (amount >= minSpend) {
      return amount * percent ~/ 100;
    }
    return 0;
  }
}

void main() {
  print('Seed: $seed (t=$t, u=$u)');
  step1();
  step2();
  step3();
  step4();
  step5();
  step6();
  step7();
  step8();
  step9();
  step10();
}

void step1() {
  print('--- Step 1 ---');
  final item1 = Dish();
  item1.name = menu[u];
  item1.price = priceOf(u);

  final item2 = Dish();
  item2.name = menu[(u + 1) % 10];
  item2.price = priceOf((u + 1) % 10);
  item2.price = item2.price - u;

  print('Step 1: ${item1.name} Rs ${item1.price}');
  print('Step 1: ${item2.name} Rs ${item2.price}');
}

void step2() {
  print('--- Step 2 ---');
  final a = MenuItem(menu[u], priceOf(u));
  final b = MenuItem('Test Special', 15 * u);
  print('Step 2: ${a.name} Rs ${a.price}');
  print('Step 2: Test Special Rs ${b.price}');

  // Think: Why could price not be declared final in this version of the class?
  // answer
  // a final field can only be assigned once at the toime of creation so in the constructor body we sometime change
  // this.price , which is a second assignment which final would not allow it
}

void step3() {
  print('--- Step 3 ---');
  final freebie = MenuItem.free('Water');
  final i = (u + 2) % 10;
  final parsed = MenuItem.fromString('${menu[i]}:${priceOf(i)}');
  print('Step 3: ${freebie.name} Rs ${freebie.price}');
  print('Step 3: ${parsed.name} Rs ${parsed.price}');
  print('Step 3: floor=$priceFloor, free price=${freebie.price}');

  // Think: The floor is, say, 80 but free() produced 0. Why did the floor logic not run?
  // answer
  // a floor check lives in th body of the MAIN constructor only and a named constructor is a separtae way of building the object
  // MenuItem.free never calls the main sonstructor so its body never runs
}

void step4() {
  print('--- Step 4 ---');
  final log1 = OrderLog();
  final log2 = OrderLog();
  for (int i = 1; i <= u + 2; i++) {
    final msg = 'order #${100 * t + i}';
    if (i.isOdd) {
      log1.add(msg);
    } else {
      log2.add(msg);
    }
  }
  print('Step 4: same object? ${identical(log1, log2)}');
  print('Step 4: entries = ${log1.entries.length}');
  print('Step 4: last = ${log2.entries.last}');

  // Think: Why do _instance and _internal start with an underscore? What could go wrong if they did not?
  // answer
  // the underscore makes them private to the library or file so if they were public , other code could call OrderLog._internal() or overwrite
  // the _instance and create the extra logs which breaks the "only one log " gurrantee
}

void step5() {
  print('--- Step 5 ---');
  final line = mainOrder();
  print('Step 5: ${line.item.name} x${line.qty}');
  print('Step 5: total=${line.total} tax=${line.tax}');

  try {
    OrderLine(line.item, 0);
    print('Step 5: assert did NOT fire');
  } on AssertionError {
    print('Step 5: assert fired');
  }

  // Think: Try writing tax = total * taxPercent ~/ 100. Why can an initializer list not read another field of the same object?
  // answer
  // the initalizer list runs before the object is fullu built so "this" is not available yet
  // fields are not guranteed to be set so dart blocks it
}

void step6() {
  print('--- Step 6 ---');
  final line = mainOrder();
  print('Step 6: grand=${line.grand}');
  print('Step 6: big order? ${line.isBigOrder} (limit $bigOrderLimit)');
  print('Step 6: label=${line.label}');

  // line.grand = 5; // compile error: no setter

  // Think: Why does that line fail? What would you have to add to make it legal?
  // answer
  // grand is a getter only so there is no way to assign to it
  // to make it legal i would add a setter
}

void step7() {
  print('--- Step 7 ---');
  final card = StudentCard('S$seed');

  card.balance = seed * 10 + 50;
  print('Step 7: topped up -> ${card.balance}');

  card.balance = -seed - 1;
  print('Step 7: bad value -> ${card.balance}');

  card.balance = balanceCap - u;
  print('Step 7: reset -> ${card.balance}');

  card.balance = card.balance - mainOrder().grand;
  print('Step 7: paid order -> ${card.balance}');

  // Think: The setter silently clamps a bad value. What is one other thing a setter could do with an invalid value?
  // answer
  // it could throw an error or log a warning instead of silently changing the value so the caller knows it was wrong
}

void step8() {
  print('--- Step 8 ---');
  final items = buildMenu();
  final priciest = items.reduce((a, b) => a.price >= b.price ? a : b);
  final sum = items.fold(0, (s, item) => s + item.price);
  print('Step 8: menu = $items');
  print('Step 8: priciest = ${priciest.name}');
  print('Step 8: sum = $sum');
}

void step9() {
  print('--- Step 9 ---');
  final receipt = buildReceipt();
  int sum = 0;
  for (final line in receipt) {
    print('Step 9: ${line.label} = ${line.grand}');
    OrderLog().add('receipt: ${line.label}');
    sum += line.grand;
  }
  print('Step 9: receipt total = $sum');
  print('Step 9: log size = ${OrderLog().entries.length}');
}

void step10() {
  print('--- Step 10 ---');
  final code = 'CAFE${seed.toString().padLeft(2, '0')}';
  final c1 = Coupon.fromCode(code);
  final c2 = Coupon.fromCode(code);

  int receipt = 0;
  for (final line in buildReceipt()) {
    receipt += line.grand;
  }
  final discount = c1.discountOn(receipt);

  print('Step 10: $code gives ${c1.percent}% off, min spend ${c1.minSpend}');
  print('Step 10: cached? ${identical(c1, c2)}');
  print(
    'Step 10: receipt $receipt, discount $discount, payable ${receipt - discount}',
  );
}

// Reflection questions
//
// Q1:
// it saves the time to write the parameter names double time and this.name = name and this.type= type line,
// duw to this less boilerplate is used and the constructor is easier to read
//
// Q2:
// when i want another way to build a new Object then i will use named constructor .
// and when i want to return an existing object or decide what i want to return then i will use factory constructor
//
// Q3:
// the initailizer list runs before the body while the object is still being built so it can set final fields and run asserts,
// the body run after so final field can not be assigned there because they would be set already
//
// Q4:
// getter: the value is computed from other fields soi it never gets out of date
// setter: it can validate the value before storing it instead of letting anyone set the junk
