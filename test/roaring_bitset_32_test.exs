defmodule RoaringBitset32Test do
  use ExUnit.Case

  test "to_list/1" do
    {:ok, bitset} = RoaringBitset32.new()

    RoaringBitset32.insert(bitset, 1)
    RoaringBitset32.insert(bitset, 4)

    {:ok, result} = RoaringBitset32.to_list(bitset)
    assert result == [1, 4]
  end

  test "remove/2" do
    {:ok, bitset} = RoaringBitset32.new()

    RoaringBitset32.insert(bitset, 1)
    RoaringBitset32.insert(bitset, 2)
    RoaringBitset32.remove(bitset, 1)

    assert {:ok, false} == RoaringBitset32.contains?(bitset, 1)
    assert {:ok, true} == RoaringBitset32.contains?(bitset, 2)
  end

  test "contains?/2" do
    {:ok, bitset} = RoaringBitset32.new()

    RoaringBitset32.insert(bitset, 1)

    assert {:ok, true} == RoaringBitset32.contains?(bitset, 1)
    assert {:ok, false} == RoaringBitset32.contains?(bitset, 2)
  end

  test "intersection/1" do
    {:ok, bitset1} = RoaringBitset32.new()
    RoaringBitset32.insert(bitset1, 1)
    RoaringBitset32.insert(bitset1, 2)
    RoaringBitset32.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitset32.new()
    RoaringBitset32.insert(bitset2, 2)
    RoaringBitset32.insert(bitset2, 3)
    RoaringBitset32.insert(bitset2, 4)

    {:ok, bitset3} = RoaringBitset32.new()
    RoaringBitset32.insert(bitset3, 5)
    RoaringBitset32.insert(bitset3, 3)
    RoaringBitset32.insert(bitset3, 2)

    {:ok, intersection} = RoaringBitset32.intersection([bitset1, bitset2, bitset3])
    assert {:ok, [2, 3]} == RoaringBitset32.to_list(intersection)
  end

  test "union/1" do
    {:ok, bitset1} = RoaringBitset32.new()
    RoaringBitset32.insert(bitset1, 1)
    RoaringBitset32.insert(bitset1, 2)
    RoaringBitset32.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitset32.new()
    RoaringBitset32.insert(bitset2, 2)
    RoaringBitset32.insert(bitset2, 3)
    RoaringBitset32.insert(bitset2, 4)

    {:ok, bitset3} = RoaringBitset32.new()
    RoaringBitset32.insert(bitset3, 2)
    RoaringBitset32.insert(bitset3, 3)
    RoaringBitset32.insert(bitset3, 5)

    {:ok, union} = RoaringBitset32.union([bitset1, bitset2, bitset3])
    assert {:ok, [1, 2, 3, 4, 5]} == RoaringBitset32.to_list(union)
  end

  test "xor/2" do
    {:ok, bitset1} = RoaringBitset32.new()
    RoaringBitset32.insert(bitset1, 1)
    RoaringBitset32.insert(bitset1, 2)
    RoaringBitset32.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitset32.new()
    RoaringBitset32.insert(bitset2, 2)
    RoaringBitset32.insert(bitset2, 3)
    RoaringBitset32.insert(bitset2, 4)

    {:ok, xor} = RoaringBitset32.xor(bitset1, bitset2)
    assert {:ok, [1, 4]} == RoaringBitset32.to_list(xor)
  end

  test "difference/2" do
    {:ok, bitset1} = RoaringBitset32.new()
    RoaringBitset32.insert(bitset1, 1)
    RoaringBitset32.insert(bitset1, 2)
    RoaringBitset32.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitset32.new()
    RoaringBitset32.insert(bitset2, 2)
    RoaringBitset32.insert(bitset2, 3)
    RoaringBitset32.insert(bitset2, 4)

    {:ok, difference} = RoaringBitset32.difference(bitset1, bitset2)
    assert {:ok, [1]} == RoaringBitset32.to_list(difference)
  end

  test "(de)serialize" do
    {:ok, bitset1} = RoaringBitset32.new()
    RoaringBitset32.insert(bitset1, 1)
    RoaringBitset32.insert(bitset1, 2)
    RoaringBitset32.insert(bitset1, 3)

    {:ok, bytes} = RoaringBitset32.serialize(bitset1)

    {:ok, bitset2} = RoaringBitset32.deserialize(bytes)

    {:ok, members1} = RoaringBitset32.to_list(bitset1)
    {:ok, members2} = RoaringBitset32.to_list(bitset2)
    assert members1 == [1, 2, 3]
    assert members2 == [1, 2, 3]
  end

  test "equal?/2" do
    {:ok, bitset1} = RoaringBitset32.new()
    {:ok, bitset2} = RoaringBitset32.new()

    assert {:ok, true} == RoaringBitset32.equal?(bitset1, bitset2)

    RoaringBitset32.insert(bitset1, 1)

    assert {:ok, false} == RoaringBitset32.equal?(bitset1, bitset2)

    RoaringBitset32.insert(bitset2, 1)

    assert {:ok, true} == RoaringBitset32.equal?(bitset1, bitset2)

    RoaringBitset32.insert(bitset2, 2)

    assert {:ok, false} == RoaringBitset32.equal?(bitset1, bitset2)
  end

  test "size/1" do
    {:ok, bitset} = RoaringBitset32.new()

    assert {:ok, 0} == RoaringBitset32.size(bitset)

    RoaringBitset32.insert(bitset, 42)

    assert {:ok, 1} == RoaringBitset32.size(bitset)
  end
end
