defmodule RoaringTest do
  use ExUnit.Case
  doctest Roaring

  test "to_list/1" do
    {:ok, bitset} = Roaring.new()

    Roaring.insert(bitset, 1)
    Roaring.insert(bitset, 4)

    {:ok, result} = Roaring.to_list(bitset)
    assert result == [1, 4]
  end

  test "contains?/2" do
    {:ok, bitset} = Roaring.new()

    Roaring.insert(bitset, 1)

    assert {:ok, true} == Roaring.contains?(bitset, 1)
    assert {:ok, false} == Roaring.contains?(bitset, 2)
  end

  test "intersection/1" do
    {:ok, bitset1} = Roaring.new()
    Roaring.insert(bitset1, 1)
    Roaring.insert(bitset1, 2)
    Roaring.insert(bitset1, 3)

    {:ok, bitset2} = Roaring.new()
    Roaring.insert(bitset2, 2)
    Roaring.insert(bitset2, 3)
    Roaring.insert(bitset2, 4)

    {:ok, intersection} = Roaring.intersection([bitset1, bitset2])
    assert {:ok, [2, 3]} == Roaring.to_list(intersection)
  end

  test "union/1" do
    {:ok, bitset1} = Roaring.new()
    Roaring.insert(bitset1, 1)
    Roaring.insert(bitset1, 2)
    Roaring.insert(bitset1, 3)

    {:ok, bitset2} = Roaring.new()
    Roaring.insert(bitset2, 2)
    Roaring.insert(bitset2, 3)
    Roaring.insert(bitset2, 4)

    {:ok, union} = Roaring.union([bitset1, bitset2])
    assert {:ok, [1, 2, 3, 4]} == Roaring.to_list(union)
  end
end
