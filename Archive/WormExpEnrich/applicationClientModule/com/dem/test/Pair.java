package com.dem.test;

class Pair<L,R> {
    final L left;
    final R right;

    public Pair(L left, R right) {
      this.left = left;
      this.right = right;
    }
    public L getLeft() { return left; }
    public R getRight() { return right; }
    static <L,R> Pair<L,R> of(L left, R right){
        return new Pair<L,R>(left, right);
    }
}