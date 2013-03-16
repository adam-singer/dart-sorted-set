Sorted Set
==========
An array backed sorted set. The main driving force between creating this library
instead of using the Dart native `Set` is to have an effecient way of finding
the next greatest element in a set or the next least element in a set.

Example
-------
```dart
import 'package:sorted_set/sorted_set.dart';

main() {

  SortedSet<int> set = new SortedSet((int a, int b) => a - b);

  // init the sorted set, will sort and remove dupes
  set.addMultiple([5,3,9,9,9,6,1,5,5,5,5,7,9,2,4,8,3,3,3]);

  // attempt to add a dupe, will be rejected
  set.add(6);

  // add new element, it will insert at the correct location
  set.add(10);

  // will remove an element if it exists in the set
  set.remove(3);

  // attempt to remove an element that no longer exists, nothing will change
  set.remove(3);

  // verify if an element exists in the set
  bool exists = set.exists(9);

  // get an element if it exists or null
  var orNull = set.get(5).orNull();

  // get the upper bound (next greatest) of an element in the set
  var upper = set.getUpperBound(3).orNull();

  // get the lower bound (next least) of an element in the set
  var lower = set.getLowerBound(3).orNull();

  // get the max value of the set
  var max = set.max().orNull();

  // get the min value of the set
  var min = set.min().orNull();

  // map over a set, removing dupes and returning a new sorted set
  var mapped = set.map((v) => v * 2);

  // filter over a set, returning a new sorted set
  var filtered = set.where((v) => (v % 2) == 0);

  // return the list representation of the sorted set
  List<int> list = set.toList();
}
```