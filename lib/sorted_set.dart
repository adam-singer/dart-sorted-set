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
  SortedSet(int compare(V a, V b)) {
    this._compare  = compare;
    this._elements = <V>[];
  }

  /**
   * Constructor that sets up the initial state of the set from an iterable
   *
   * @param {int(V, V)} compare - The comparator to base sort order
   * @param {Iterable<V>}
   */
  SortedSet.from(int compare(V a, V b), Iterable<V> iter){
    this._compare = compare;
    this._elements = <V>[];
    for (var i in iter) {
      this.add(iter[i]);
    }
  }

  /**
   * Adds an element to the `SortedSet` at the correct position only if
   * it isn't already present in the `SortedSet`
   *
   * @param {V} element - The element to add to the set
   * @return {void}
   */
  void add(V element) {
    if (this._elements.length == 0) {
      this._elements.add(element);
    } else {
      int position = this._binarySearch(element);
      if (position >= this._elements.length) {
        this._elements.add(element);
      } else {
        if (this._isInBounds(position) && this._elements[position] != element) {
          this._elements.insertRange(position, 1, element);
        }
      }
    }
  }

  /**
   * Given an `Iterable` this method adds all the iterables to the `SortedSet`
   * at their correct positions and excludes dupes
   *
   * @param {Iterable<V>} elements - The iterable to pull elements from
   * @return {void}
   */
  void addMultiple(Iterable<V> elements) {
    for (V element in elements) {
      this.add(element);
    }
  }

  /**
   * Given an element, remove if from the `SortedSet` if it is present in it, if
   * it isn't then this does nothing.
   *
   * @param {V} element - The element to remove from the list
   * @return {void}
   */
  void remove(V element) {
    int position = this._binarySearch(element);
    if (this._isInBounds(position) && this._elements[position] == element) {
      this._elements.removeAt(position);
    }
  }

  /**
   * Given an element this returns `true` if it's in the `SortedSet`
   * false otherwise
   *
   * @param {V} element - The element to check for existence
   * @return {bool}     - True when present false otherwise
   */
  bool exists(V element) {
    int position = this._binarySearch(element);
    return this._isInBounds(position) && this._elements[position] == element;
  }

  /**
   * Given an element this method will return `Some` if it exists and `None`
   * if it doesn't exist.
   *
   * @param {V} element  - The element to check for and return if present
   * @return {Option<V>} - The optionally found element
   */
  Option<V> get(V element) {
    int position = this._binarySearch(element);
    if (this._isInBounds(position) && this._elements[position] == element) {
      return new Some(element);
    } else {
      return new None<V>();
    }
  }

  /**
   * Given an element, this function returns the next greatest element present
   * in the set wrapped in an `Option` type. So if there is no greater element
   * in the set then `None` is returned but if there is then the next greatest
   * element is returned wrapped in a `Some`
   *
   * @param {V} element  - The element to get the next greatest of
   * @return {Option<V>} - The optional greater value
   */
  Option<V> getUpperBound(V element) {
    int position = this._binarySearch(element);
    int upper    = position + 1;

    if (!this._isInBounds(position)) {
      return new None<V>();
    }

    if (this._elements[position] != element) {
      return new Some(this._elements[position]);
    }

    if (!this._isInBounds(upper)){
      return new None<V>();
    }

    return new Some(this._elements[upper]);
  }

  /**
   * Given an element, this function returns the next least element present
   * in the set wrapped in an `Option` type. So if there is no lesser element
   * in the set then `None` is returned but if there is then the next least
   * element is returned wrapped in a `Some`
   *
   * @param {V} element  - The element to get the next least of
   * @return {Option<V>} - The optional lesser value
   */
  Option<V> getLowerBound(V element) {
    int position = this._binarySearch(element);
    int lower    = position - 1;

    if (!this._isInBounds(position)) {
      return new None<V>();
    }

    if (!this._isInBounds(lower)) {
      return new None<V>();
    }

    return new Some(this._elements[lower]);
  }

  /**
   * Returns the max element in the set
   *
   * @return {Option<V>} - The optional max value
   */
  Option<V> max() {
    if (this._elements.length > 0) {
      return new Some(this._elements.last);
    } else {
      return new None<V>();
    }
  }

  /**
   * Returns the min element in the set
   *
   * @return {Option<V>} - The optional min value
   */
  Option<V> min() {
    if (this._elements.length > 0) {
      return new Some(this._elements.first);
    } else {
      return new None<V>();
    }
  }

  /**
   * Applies the supplied mapper to the set and returns a new `SortedSet`
   *
   * @param {dynamic(V)} mapper   - The mapper to apply to all elements
   * @return {SortedSet<dynamic>} - The newly generated set
   */
  SortedSet<dynamic> map(dynamic mapper(V)) {
    var mapped = this._elements.map(mapper);
    var newSet = new SortedSet<dynamic>(this._compare);
    newSet.addMultiple(mapped.toList());
    return newSet; 
  }

  /**
   * Given a predicate, returns a new set where all elements that don't
   * pass it are not present
   *
   * @param {bool(V)} predicate - The predicate to use for checking
   * @return {SortedSet<V>}     - The filtered set
   */
  SortedSet<V> where(bool predicate(V value)) {
    var filtered = this._elements.where(predicate);
    var newSet   = new SortedSet<dynamic>(this._compare);
    newSet.addMultiple(filtered.toList());
    return newSet;
  }

  /**
   * Returns a list representation of the `SortedSet`
   *
   * @return {List<V>} - The list representation
   */
  List<V> toList() {
    return this._elements;
  }

  /**
   * Helper method for determining if an offset is within bounds
   *
   * @param {int} offset - The offset to perform the bounds check on
   * @return {bool}      - True when in bounds false otherwise
   */
  bool _isInBounds(int offset) {
    return (offset >= 0 && offset < this._elements.length);
  }

  /**
   * Helper binary search method for finding the correct location of
   * an element in the `SortedSet`
   *
   * @param {V} element - The element to find the position of
   * @return {int}      - The position that element would be at
   */
  int _binarySearch(V element) {
    int min = 0;
    int max = this._elements.length - 1;

    if (max < 0) {
      return 0;
    }

    while (max >= min) {
      int mid = (((max - min) / 2) + min).ceil().toInt();
      int cmp = this._compare(this._elements[mid], element);
      if (cmp < 0) {
        min = mid + 1;
      } else if (cmp > 0) {
        max = mid - 1;
      } else {
        return mid;
      }
    }

    return min;
  }

}