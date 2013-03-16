library sorted_set;

import 'package:option/option.dart';

class SortedSet<V> {

  var _compare;
  List<V> _elements;

  SortedSet(int compare(V a, V b)) {
    this._compare  = compare;
    this._elements = <V>[];
  }

  SortedSet.from(int compare(V a, V b), Iterable<V> iter){
    this._compare = compare;
    this._elements = <V>[];
    for (var i in iter) {
      this.add(iter[i]);
    }
  }

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

  void addMultiple(Iterable<V> elements) {
    for (V element in elements) {
      this.add(element);
    }
  }

  void remove(V element) {
    int position = this._binarySearch(element);
    if (this._isInBounds(position) && this._elements[position] == element) {
      this._elements.removeAt(position);
    }
  }

  bool exists(V element) {
    int position = this._binarySearch(element);
    return this._isInBounds(position) && this._elements[position] == element;
  }

  Option<V> get(V element) {
    int position = this._binarySearch(element);
    if (this._isInBounds(position) && this._elements[position] == element) {
      return new Some(element);
    } else {
      return new None<V>();
    }
  }

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

  Option<V> max() {
    if (this._elements.length > 0) {
      return new Some(this._elements.last);
    } else {
      return new None<V>();
    }
  }

  Option<V> min() {
    if (this._elements.length > 0) {
      return new Some(this._elements.first);
    } else {
      return new None<V>();
    }
  }

  SortedSet<dynamic> map(dynamic mapper(V)) {
    var mapped = this._elements.map(mapper);
    var newSet = new SortedSet<dynamic>(this._compare);
    newSet.addMultiple(mapped.toList());
    return newSet; 
  }

  SortedSet<V> where(bool predicate(V value)) {
    var filtered = this._elements.where(predicate);
    var newSet   = new SortedSet<dynamic>(this._compare);
    newSet.addMultiple(filtered.toList());
    return newSet;
  }

  List<V> toList() {
    return this._elements;
  }

  bool _isInBounds(int offset) {
    return (offset >= 0 && offset < this._elements.length);
  }

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