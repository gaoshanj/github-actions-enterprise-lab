import test from 'node:test';
import assert from 'node:assert/strict';
import { calculateTotal, discountForOrder } from '../src/orders.js';

test('calculates an order total', () => {
  assert.equal(calculateTotal([{ quantity: 2, price: 12.5 }]), 25);
});

test('returns a discount for large orders', () => {
  assert.equal(discountForOrder(100), 0.1);
  assert.equal(discountForOrder(99.99), 0);
});
