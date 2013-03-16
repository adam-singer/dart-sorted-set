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

Public Interface
----------------
```dart
library sorted_set;

import 'package:option/option.dart';

class SortedSet<V> {

  var _compare;

  List<V> _elements;

  /**
   * Vanilla constructor, just stashes away the required comparator
   *
   * @param {int(V, V)} compare - The comparator to base sort order
   */
  SortedSet(int compare(V a, V b));

  /**
   * Constructor that sets up the initial state of the set from an iterable
   *
   * @param {int(V, V)} compare - The comparator to base sort order
   * @param {Iterable<V>}
   */
  SortedSet.from(int compare(V a, V b), Iterable<V> iter);

  /**
   * Adds an element to the `SortedSet` at the correct position only if
   * it isn't already present in the `SortedSet`
   *
   * @param {V} element - The element to add to the set
   * @return {void}
   */
  void add(V element);

  /**
   * Given an `Iterable` this method adds all the iterables to the `SortedSet`
   * at their correct positions and excludes dupes
   *
   * @param {Iterable<V>} elements - The iterable to pull elements from
   * @return {void}
   */
  void addMultiple(Iterable<V> elements);

  /**
   * Given an element, remove if from the `SortedSet` if it is present in it, if
   * it isn't then this does nothing.
   *
   * @param {V} element - The element to remove from the list
   * @return {void}
   */
  void remove(V element);

  /**
   * Given an element this returns `true` if it's in the `SortedSet`
   * false otherwise
   *
   * @param {V} element - The element to check for existence
   * @return {bool}     - True when present false otherwise
   */
  bool exists(V element);

  /**
   * Given an element this method will return `Some` if it exists and `None`
   * if it doesn't exist.
   *
   * @param {V} element  - The element to check for and return if present
   * @return {Option<V>} - The optionally found element
   */
  Option<V> get(V element);

  /**
   * Given an element, this function returns the next greatest element present
   * in the set wrapped in an `Option` type. So if there is no greater element
   * in the set then `None` is returned but if there is then the next greatest
   * element is returned wrapped in a `Some`
   *
   * @param {V} element  - The element to get the next greatest of
   * @return {Option<V>} - The optional greater value
   */
  Option<V> getUpperBound(V element);

  /**
   * Given an element, this function returns the next least element present
   * in the set wrapped in an `Option` type. So if there is no lesser element
   * in the set then `None` is returned but if there is then the next least
   * element is returned wrapped in a `Some`
   *
   * @param {V} element  - The element to get the next least of
   * @return {Option<V>} - The optional lesser value
   */
  Option<V> getLowerBound(V element);

  /**
   * Returns the max element in the set
   *
   * @return {Option<V>} - The optional max value
   */
  Option<V> max();

  /**
   * Returns the min element in the set
   *
   * @return {Option<V>} - The optional min value
   */
  Option<V> min();

  /**
   * Applies the supplied mapper to the set and returns a new `SortedSet`
   *
   * @param {dynamic(V)} mapper   - The mapper to apply to all elements
   * @return {SortedSet<dynamic>} - The newly generated set
   */
  SortedSet<dynamic> map(dynamic mapper(V));

  /**
   * Given a predicate, returns a new set where all elements that don't
   * pass it are not present
   *
   * @param {bool(V)} predicate - The predicate to use for checking
   * @return {SortedSet<V>}     - The filtered set
   */
  SortedSet<V> where(bool predicate(V value));

  /**
   * Returns a list representation of the `SortedSet`
   *
   * @return {List<V>} - The list representation
   */
  List<V> toList();

  /**
   * Helper method for determining if an offset is within bounds
   *
   * @param {int} offset - The offset to perform the bounds check on
   * @return {bool}      - True when in bounds false otherwise
   */
  bool _isInBounds(int offset);

  /**
   * Helper binary search method for finding the correct location of
   * an element in the `SortedSet`
   *
   * @param {V} element - The element to find the position of
   * @return {int}      - The position that element would be at
   */
  int _binarySearch(V element);

}
```