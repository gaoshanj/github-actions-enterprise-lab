export function calculateTotal(items) {
  if (!Array.isArray(items) || items.length === 0) {
    throw new TypeError('items must be a non-empty array');
  }
  return items.reduce((total, item) => {
    if (!Number.isFinite(item.quantity) || !Number.isFinite(item.price) || item.quantity < 1 || item.price < 0) {
      throw new RangeError('invalid order item');
    }
    return total + item.quantity * item.price;
  }, 0);
}

export function discountForOrder(total) {
  if (!Number.isFinite(total) || total < 0) {
    throw new RangeError('total must be a non-negative number');
  }
  return total >= 100 ? 0.1 : 0;
}
