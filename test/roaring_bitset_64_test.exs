defmodule RoaringBitset64Test do
  use ExUnit.Case

  test "to_list/1" do
    {:ok, bitset} = RoaringBitset64.new()

    RoaringBitset64.insert(bitset, 1)
    RoaringBitset64.insert(bitset, 4)

    {:ok, result} = RoaringBitset64.to_list(bitset)
    assert result == [1, 4]
  end

  test "remove/2" do
    {:ok, bitset} = RoaringBitset64.new()

    RoaringBitset64.insert(bitset, 1)
    RoaringBitset64.insert(bitset, 2)
    RoaringBitset64.remove(bitset, 1)

    assert {:ok, false} == RoaringBitset64.contains?(bitset, 1)
    assert {:ok, true} == RoaringBitset64.contains?(bitset, 2)
  end

  test "contains?/2" do
    {:ok, bitset} = RoaringBitset64.new()

    RoaringBitset64.insert(bitset, 1)

    assert {:ok, true} == RoaringBitset64.contains?(bitset, 1)
    assert {:ok, false} == RoaringBitset64.contains?(bitset, 2)
  end

  test "intersection/1" do
    {:ok, bitset1} = RoaringBitset64.new()
    RoaringBitset64.insert(bitset1, 1)
    RoaringBitset64.insert(bitset1, 2)
    RoaringBitset64.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitset64.new()
    RoaringBitset64.insert(bitset2, 2)
    RoaringBitset64.insert(bitset2, 3)
    RoaringBitset64.insert(bitset2, 4)

    {:ok, bitset3} = RoaringBitset64.new()
    RoaringBitset64.insert(bitset3, 5)
    RoaringBitset64.insert(bitset3, 3)
    RoaringBitset64.insert(bitset3, 2)

    {:ok, intersection} = RoaringBitset64.intersection([bitset1, bitset2, bitset3])
    assert {:ok, [2, 3]} == RoaringBitset64.to_list(intersection)
  end

  test "union/1" do
    {:ok, bitset1} = RoaringBitset64.new()
    RoaringBitset64.insert(bitset1, 1)
    RoaringBitset64.insert(bitset1, 2)
    RoaringBitset64.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitset64.new()
    RoaringBitset64.insert(bitset2, 2)
    RoaringBitset64.insert(bitset2, 3)
    RoaringBitset64.insert(bitset2, 4)

    {:ok, bitset3} = RoaringBitset64.new()
    RoaringBitset64.insert(bitset3, 2)
    RoaringBitset64.insert(bitset3, 3)
    RoaringBitset64.insert(bitset3, 5)

    {:ok, union} = RoaringBitset64.union([bitset1, bitset2, bitset3])
    assert {:ok, [1, 2, 3, 4, 5]} == RoaringBitset64.to_list(union)
  end

  test "xor/2" do
    {:ok, bitset1} = RoaringBitset64.new()
    RoaringBitset64.insert(bitset1, 1)
    RoaringBitset64.insert(bitset1, 2)
    RoaringBitset64.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitset64.new()
    RoaringBitset64.insert(bitset2, 2)
    RoaringBitset64.insert(bitset2, 3)
    RoaringBitset64.insert(bitset2, 4)

    {:ok, xor} = RoaringBitset64.xor(bitset1, bitset2)
    assert {:ok, [1, 4]} == RoaringBitset64.to_list(xor)
  end

  test "difference/2" do
    {:ok, bitset1} = RoaringBitset64.new()
    RoaringBitset64.insert(bitset1, 1)
    RoaringBitset64.insert(bitset1, 2)
    RoaringBitset64.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitset64.new()
    RoaringBitset64.insert(bitset2, 2)
    RoaringBitset64.insert(bitset2, 3)
    RoaringBitset64.insert(bitset2, 4)

    {:ok, difference} = RoaringBitset64.difference(bitset1, bitset2)
    assert {:ok, [1]} == RoaringBitset64.to_list(difference)
  end

  test "(de)serialize" do
    {:ok, bitset1} = RoaringBitset64.new()
    RoaringBitset64.insert(bitset1, 1)
    RoaringBitset64.insert(bitset1, 2)
    RoaringBitset64.insert(bitset1, 3)

    {:ok, bytes} = RoaringBitset64.serialize(bitset1)

    {:ok, bitset2} = RoaringBitset64.deserialize(bytes)

    {:ok, members1} = RoaringBitset64.to_list(bitset1)
    {:ok, members2} = RoaringBitset64.to_list(bitset2)
    assert members1 == [1, 2, 3]
    assert members2 == [1, 2, 3]
  end

  test "equal?/2" do
    {:ok, bitset1} = RoaringBitset64.new()
    {:ok, bitset2} = RoaringBitset64.new()

    assert {:ok, true} == RoaringBitset64.equal?(bitset1, bitset2)

    RoaringBitset64.insert(bitset1, 1)

    assert {:ok, false} == RoaringBitset64.equal?(bitset1, bitset2)

    RoaringBitset64.insert(bitset2, 1)

    assert {:ok, true} == RoaringBitset64.equal?(bitset1, bitset2)

    RoaringBitset64.insert(bitset2, 2)

    assert {:ok, false} == RoaringBitset64.equal?(bitset1, bitset2)
  end

  test "size/1" do
    {:ok, bitset} = RoaringBitset64.new()

    assert {:ok, 0} == RoaringBitset64.size(bitset)

    RoaringBitset64.insert(bitset, 42)

    assert {:ok, 1} == RoaringBitset64.size(bitset)
  end
end
