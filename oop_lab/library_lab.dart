// library_lab.dart - Campus Library System
// Name: ____________________   Roll no: ____________

const String rollNo = '04072313027'; // e.g. '21F-0347'

// ===== Seeded settings (generated from YOUR roll number). Do not edit. =====
final int seed = int.parse(rollNo.substring(rollNo.length - 2));
final int t = seed ~/ 10; // tens digit
final int u = seed % 10; // units digit

const List<String> titles = [
  'Dart Basics',
  'Flutter In Action',
  'Data Structures',
  'Operating Systems',
  'Mobile Design',
  'Clean Code',
  'Algorithms Unlocked',
  'Computer Networks',
  'Database Systems',
  'Software Testing',
];

int yearOf(int i) => 1995 + 2 * i + t; // publication year of titles[i]
final int feePerDay = 5 + t; // late fee per day, in rupees
final int daysLate = 3 + (t + u) % 6; // normal number of days late
final int daysBig = 10 + u; // a long overdue period
final int feeCap = 150 + 10 * t; // no single fee may exceed this
final int renewLimit = 1 + t % 3; // renewals allowed per item
final int renewAttempts = 2 + u; // renewal attempts made in Step 5
final int shelfSize = 3 + u % 4; // items on the shelf in Steps 9-10
// ===========================================================================

// ---------- Step 4: contract ----------
abstract class Borrowable {
  bool get isAvailable;
  void borrow();
  void giveBack();
}

// ---------- Step 5: mixin ----------
mixin Renewable {
  int renewals = 0;
  bool renew(int limit) {
    if (renewals >= limit) return false;
    renewals++;
    return true;
  }
}

abstract class LibraryItem {
  final String title;
  final int year;

  static int created = 0;
  static int capFee(int fee) => fee > feeCap ? feeCap : fee;

  LibraryItem(this.title, this.year) {
    created++;
  }

  String describe() => '$title ($year)';

  int lateFee(int days);
}

class Book extends LibraryItem with Renewable implements Borrowable {
  final int pages;
  bool _out = false;

  Book(super.title, super.year, this.pages);

  @override
  String describe() => '${super.describe()}, $pages pages';

  @override
  int lateFee(int days) => days * feePerDay;

  @override
  bool get isAvailable => !_out;

  @override
  void borrow() => _out = true;

  @override
  void giveBack() => _out = false;
}

class Magazine extends LibraryItem {
  final int issue;

  Magazine(super.title, super.year, this.issue);

  @override
  String describe() => '${super.describe()}, issue $issue';

  @override
  int lateFee(int days) => days * (feePerDay ~/ 2);
}

class Dvd extends LibraryItem with Renewable {
  final int minutes;

  Dvd(super.title, super.year, this.minutes);

  @override
  String describe() => '${super.describe()}, $minutes min';

  @override
  int lateFee(int days) => days * feePerDay * 2;
}

Book mainBook() => Book(titles[u], yearOf(u), 100 + 3 * seed);

Magazine mainMagazine() {
  final i = (u + 1) % 10;
  return Magazine(titles[i], yearOf(i), 1 + (t + u) % 12);
}

Dvd mainDvd() {
  final i = (u + 2) % 10;
  return Dvd(titles[i], yearOf(i), 90 + seed % 40);
}

// ---------- Step 6: enum ----------
enum MemberType {
  student(3, 50),
  faculty(10, 20),
  guest(1, 0);

  final int maxLoans;
  final int discountPercent;
  const MemberType(this.maxLoans, this.discountPercent);

  int applyDiscount(int fee) => fee - (fee * discountPercent) ~/ 100;
}

// ---------- Step 7: extensions ----------
extension MoneyText on int {
  String get rs => 'Rs $this';
}

extension Initials on String {
  String get initials => split(' ').map((w) => w[0]).join();
}

extension ShelfMath on List<LibraryItem> {
  int totalLateFee(int days) => fold(0, (sum, i) => sum + i.lateFee(days));
}

// ---------- Step 8: Fine ----------
class Fine {
  final int amount;
  const Fine(this.amount);

  Fine operator +(Fine o) => Fine(amount + o.amount);
  bool operator >(Fine o) => amount > o.amount;

  @override
  bool operator ==(Object other) => other is Fine && other.amount == amount;

  @override
  int get hashCode => amount.hashCode;

  @override
  String toString() => 'Fine($amount)';
}

// ---------- Step 9: shelf ----------
List<LibraryItem> buildShelf() {
  final items = <LibraryItem>[];
  for (int k = 0; k < shelfSize; k++) {
    final i = (u + k) % 10;
    if (k % 3 == 0) {
      items.add(Book(titles[i], yearOf(i), 100 + 3 * seed));
    } else if (k % 3 == 1) {
      items.add(Magazine(titles[i], yearOf(i), 1 + (t + k) % 12));
    } else {
      items.add(Dvd(titles[i], yearOf(i), 90 + seed % 40));
    }
  }
  return items;
}

// ---------- Step 10: member ----------
class Member {
  final String name;
  final MemberType type;
  Member(this.name, this.type);

  Fine feeFor(LibraryItem item, int days) {
    final fee = item.lateFee(days);
    final capped = LibraryItem.capFee(fee);
    return Fine(type.applyDiscount(capped));
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
  final b = mainBook();
  LibraryItem item = b;
  print('Step 1: ${b.title} (${b.year}), ${b.pages} pages');
  print('Step 1: stored as LibraryItem: ${item.title}');
  print('Step 1: runtimeType = ${item.runtimeType}');
  // Think: item.pages is a compile error because Dart checks the variable's
  // declared type (LibraryItem), which has no `pages`. The object really has
  // it, but the compiler only trusts the declared type.
}

void step2() {
  print('--- Step 2 ---');
  print('Step 2: ${mainBook().describe()}');
  print('Step 2: ${mainMagazine().describe()}');
  // Think: without @override, descibe() would just be a brand new method and
  // nothing would warn you; calling describe() would still run the parent's
  // version, so the output would silently be wrong.
}

void step3() {
  print('--- Step 3 ---');
  print(
    'Step 3: Book late fee for $daysLate days = ${mainBook().lateFee(daysLate)}',
  );
  print(
    'Step 3: Magazine late fee for $daysLate days = ${mainMagazine().lateFee(daysLate)}',
  );
  print(
    'Step 3: Dvd late fee for $daysLate days = ${mainDvd().lateFee(daysLate)}',
  );
  // Think: LibraryItem('x', 2000) fails ("abstract classes can't be
  // instantiated") because an abstract class has unfinished methods
  // (lateFee has no body), so an object of it could not do its job.
}

void step4() {
  print('--- Step 4 ---');
  final book = mainBook();
  print('Step 4: available? ${book.isAvailable}');
  book.borrow();
  print('Step 4: after borrow? ${book.isAvailable}');
  book.giveBack();
  print('Step 4: after return? ${book.isAvailable}');
  final List<LibraryItem> items = [book, mainMagazine(), mainDvd()];
  for (final item in items) {
    print('Step 4: ${item.runtimeType} borrowable? ${item is Borrowable}');
  }
  // Think: extends Borrowable would have given us its ready-made code for
  // free, but Borrowable has no code, and Book can only extend one class
  // (it already extends LibraryItem). We wanted just the promise.
}

void step5() {
  print('--- Step 5 ---');
  final book = mainBook();
  int ok = 0;
  for (int i = 0; i < renewAttempts; i++) {
    if (book.renew(renewLimit)) ok++;
  }
  print('Step 5: renewed $ok of $renewAttempts attempts (limit $renewLimit)');
  print('Step 5: renew once more? ${book.renew(renewLimit)}');
  print('Step 5: dvd can renew too? ${mainDvd().renew(1)}');
  // Think: putting renew in LibraryItem would give it to Magazine too, which
  // must not renew. A mixin lets us hand the code to only the classes that
  // need it, even though they are not related by inheritance.
}

void step6() {
  print('--- Step 6 ---');
  final type = MemberType.values[seed % 3];
  final fee = mainBook().lateFee(daysLate);
  print('Step 6: member type = ${type.name} (index ${type.index})');
  print('Step 6: max loans = ${type.maxLoans}');
  print('Step 6: book fee $fee -> ${type.applyDiscount(fee)} after discount');
  // Think: an enum value can't be misspelled ('studnet' is only a typo in a
  // string and fails silently); the compiler checks enums, and they carry
  // their own data and methods.
}

void step7() {
  print('--- Step 7 ---');
  final type = MemberType.values[seed % 3];
  final discounted = type.applyDiscount(mainBook().lateFee(daysLate));
  final shelf = <LibraryItem>[mainBook(), mainMagazine(), mainDvd()];
  print('Step 7: ${discounted.rs}');
  print('Step 7: initials of "${titles[u]}" = ${titles[u].initials}');
  print(
    'Step 7: shelf fee for $daysLate days = ${shelf.totalLateFee(daysLate).rs}',
  );
  // Think: 72.rs reads left to right like a property of the number, is easy
  // to find with autocomplete, and chains nicely, unlike a loose rs(72).
}

void step8() {
  print('--- Step 8 ---');
  final f1 = Fine(mainBook().lateFee(daysLate));
  final f2 = Fine(mainMagazine().lateFee(daysLate));
  print('Step 8: $f1 + $f2 = ${f1 + f2}');
  print('Step 8: first bigger? ${f1 > f2}');
  print('Step 8: equal copies? ${f1 == Fine(f1.amount)}');
  print('Step 8: set size = ${{f1, Fine(f1.amount), f2}.length}');
  // Think: without hashCode the set would use the default identity hash, so
  // equal Fines land in different buckets and the size becomes 3. Sets and
  // maps use hashCode first and == second, so the two must agree.
}

void step9() {
  print('--- Step 9 ---');
  LibraryItem.created = 0;
  buildShelf();
  final shelf = buildShelf();
  print('Step 9: items created = ${LibraryItem.created}');
  print(
    'Step 9: capped fee = ${LibraryItem.capFee(shelf.first.lateFee(daysBig))} (cap $feeCap)',
  );
  print(
    'Step 9: const copies identical? ${identical(const Fine(10), const Fine(10))}',
  );
  print('Step 9: new copies identical? ${identical(Fine(10), Fine(10))}');
  // Think: static members belong to the class itself, not to any object, so
  // they exist before any object is made.
}

void step10() {
  print('--- Step 10 ---');
  final shelf = buildShelf();
  final member = Member('S$seed', MemberType.values[seed % 3]);
  final total = shelf.fold<Fine>(
    const Fine(0),
    (sum, item) => sum + member.feeFor(item, daysLate),
  );
  final b = shelf.where((i) => i is Borrowable).length;
  final r = shelf.where((i) => i is Renewable).length;
  print('Step 10: ${shelf.length} items, $b borrowable, $r renewable');
  print('Step 10: ${member.name} (${member.type.name}) owes $total');
  print('Step 10: over the cap? ${total > Fine(feeCap)}');
}
