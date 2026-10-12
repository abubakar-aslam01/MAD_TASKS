# OOP Lab: Answers

**Name:** MUHAMMAD ABUBAKAR
**Roll no:** 04072313027

**Q1. What can a subclass using `extends` use for free that a class using `implements` has to write itself?**

A subclass using `extends` inherits the parent's fields and method bodies, so it can use them without writing them again. A class using `implements` only takes the shape of the other class (its method names and types), so it has to write every field and method body itself.

**Q2. Book and Dvd both use Renewable. When would you pick a mixin, and when an abstract parent class?**

I'd pick a mixin when I want to share ready-made code with only some classes that aren't naturally related, like `renew` for Book and Dvd but not Magazine. I'd pick an abstract parent class when the classes really are the same kind of thing and all of them should share the same base fields and promised methods, like `LibraryItem` with `lateFee`.

**Q3. Why must you override `hashCode` whenever you override `==`?**

Sets and maps use `hashCode` first to pick a bucket and only then use `==` to compare. If two objects are equal by `==` but have different hash codes, they land in different buckets and Dart treats them as different, so a Set can hold "duplicates" and lookups fail. Equal objects must have equal hash codes.

**Q4. An extension method on `String` and a subclass of `String` both add behaviour. Why does Dart let you write the first one but not the second?**

An extension just adds methods that the compiler resolves statically on the existing type, so it doesn't change the type itself. A subclass of `String` would need to create new `String` objects of a different type, and `String` is a built-in final class that can't be extended or implemented.
