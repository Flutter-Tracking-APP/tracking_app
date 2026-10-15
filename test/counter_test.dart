import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/counter.dart';

void main() {
  // Use group() to cluster related unit tests together
  group('Counter Class Unit Tests', () {
    late Counter counter;

    // setUp runs automatically before each individual test() block
    setUp(() {
      counter = Counter();
    });

    test('Initial counter value should be 0', () {
      expect(counter.value, 0);
    });

    test('Value should increment when increment() is called', () {
      counter.increment();
      expect(counter.value, 1);
    });

    test(
      'Value should decrement when decrement() is called on positive values',
      () {
        counter.increment(); // value is now 1
        counter.decrement(); // value is now 0

        expect(counter.value, 0);
      },
    );

    test('Value should not go below 0 when decrement() is called at 0', () {
      counter.decrement(); // Attempting decrement at 0

      expect(counter.value, 0); // Guard condition holds
    });

    test('Value should reset to 0', () {
      counter.increment();
      counter.increment(); // value is now 2
      counter.reset();

      expect(counter.value, 0);
    });
  });
}
