defmodule RoaringBitsetTest do
  use ExUnit.Case

  test "to_list/1" do
    {:ok, bitset} = RoaringBitset.new()

    RoaringBitset.insert(bitset, 1)
    RoaringBitset.insert(bitset, 4)

    {:ok, result} = RoaringBitset.to_list(bitset)
    assert result == [1, 4]
  end

  test "contains?/2" do
    {:ok, bitset} = RoaringBitset.new()

    RoaringBitset.insert(bitset, 1)

    assert {:ok, true} == RoaringBitset.contains?(bitset, 1)
    assert {:ok, false} == RoaringBitset.contains?(bitset, 2)
  end

  test "intersection/1" do
    {:ok, bitset1} = RoaringBitset.new()
    RoaringBitset.insert(bitset1, 1)
    RoaringBitset.insert(bitset1, 2)
    RoaringBitset.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitset.new()
    RoaringBitset.insert(bitset2, 2)
    RoaringBitset.insert(bitset2, 3)
    RoaringBitset.insert(bitset2, 4)

    {:ok, intersection} = RoaringBitset.intersection([bitset1, bitset2])
    assert {:ok, [2, 3]} == RoaringBitset.to_list(intersection)
  end

  test "union/1" do
    {:ok, bitset1} = RoaringBitset.new()
    RoaringBitset.insert(bitset1, 1)
    RoaringBitset.insert(bitset1, 2)
    RoaringBitset.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitset.new()
    RoaringBitset.insert(bitset2, 2)
    RoaringBitset.insert(bitset2, 3)
    RoaringBitset.insert(bitset2, 4)

    {:ok, union} = RoaringBitset.union([bitset1, bitset2])
    assert {:ok, [1, 2, 3, 4]} == RoaringBitset.to_list(union)
  end

  test "(de)serialize" do
    {:ok, bitset1} = RoaringBitset.new()
    RoaringBitset.insert(bitset1, 1)
    RoaringBitset.insert(bitset1, 2)
    RoaringBitset.insert(bitset1, 3)

    {:ok, bytes} = RoaringBitset.serialize(bitset1)

    {:ok, bitset2} = RoaringBitset.deserialize(bytes)

    {:ok, members1} = RoaringBitset.to_list(bitset1)
    {:ok, members2} = RoaringBitset.to_list(bitset2)
    assert members1 == [1, 2, 3]
    assert members2 == [1, 2, 3]
  end

  test "equal?/2" do
    {:ok, bitset1} = RoaringBitset.new()
    {:ok, bitset2} = RoaringBitset.new()

    assert {:ok, true} == RoaringBitset.equal?(bitset1, bitset2)

    RoaringBitset.insert(bitset1, 1)

    assert {:ok, false} ==  RoaringBitset.equal?(bitset1, bitset2)

    RoaringBitset.insert(bitset2, 1)
    
    assert {:ok, true} == RoaringBitset.equal?(bitset1, bitset2)

    RoaringBitset.insert(bitset2, 2)

    assert {:ok, false} ==  RoaringBitset.equal?(bitset1, bitset2)
  end
end
