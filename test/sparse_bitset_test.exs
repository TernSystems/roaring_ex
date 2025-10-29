defmodule SparseBitsetTest do
  use ExUnit.Case
  doctest SparseBitset

  test "to_list/1" do
    {:ok, bitset} = SparseBitset.new()

    SparseBitset.insert(bitset, 1)
    SparseBitset.insert(bitset, 4)

    {:ok, result} = SparseBitset.to_list(bitset)
    assert result == [1, 4]
  end

  test "contains?/2" do
    {:ok, bitset} = SparseBitset.new()

    SparseBitset.insert(bitset, 1)

    assert {:ok, true} == SparseBitset.contains?(bitset, 1)
    assert {:ok, false} == SparseBitset.contains?(bitset, 2)
  end

  test "intersection/1" do
    {:ok, bitset1} = SparseBitset.new()
    SparseBitset.insert(bitset1, 1)
    SparseBitset.insert(bitset1, 2)
    SparseBitset.insert(bitset1, 3)

    {:ok, bitset2} = SparseBitset.new()
    SparseBitset.insert(bitset2, 2)
    SparseBitset.insert(bitset2, 3)
    SparseBitset.insert(bitset2, 4)

    {:ok, intersection} = SparseBitset.intersection([bitset1, bitset2])
    assert {:ok, [2, 3]} == SparseBitset.to_list(intersection)
  end

  test "union/1" do
    {:ok, bitset1} = SparseBitset.new()
    SparseBitset.insert(bitset1, 1)
    SparseBitset.insert(bitset1, 2)
    SparseBitset.insert(bitset1, 3)

    {:ok, bitset2} = SparseBitset.new()
    SparseBitset.insert(bitset2, 2)
    SparseBitset.insert(bitset2, 3)
    SparseBitset.insert(bitset2, 4)

    {:ok, union} = SparseBitset.union([bitset1, bitset2])
    assert {:ok, [1, 2, 3, 4]} == SparseBitset.to_list(union)
  end
end
