defmodule RoaringBitmap64Test do
  use ExUnit.Case

  test "to_list/1" do
    {:ok, bitset} = RoaringBitmap64.new()

    RoaringBitmap64.insert(bitset, 1)
    RoaringBitmap64.insert(bitset, 4)

    {:ok, result} = RoaringBitmap64.to_list(bitset)
    assert result == [1, 4]
  end

  test "remove/2" do
    {:ok, bitset} = RoaringBitmap64.new()

    RoaringBitmap64.insert(bitset, 1)
    RoaringBitmap64.insert(bitset, 2)
    RoaringBitmap64.remove(bitset, 1)

    assert {:ok, false} == RoaringBitmap64.contains?(bitset, 1)
    assert {:ok, true} == RoaringBitmap64.contains?(bitset, 2)
  end

  test "contains?/2" do
    {:ok, bitset} = RoaringBitmap64.new()

    RoaringBitmap64.insert(bitset, 1)

    assert {:ok, true} == RoaringBitmap64.contains?(bitset, 1)
    assert {:ok, false} == RoaringBitmap64.contains?(bitset, 2)
  end

  test "intersection/1" do
    {:ok, bitset1} = RoaringBitmap64.new()
    RoaringBitmap64.insert(bitset1, 1)
    RoaringBitmap64.insert(bitset1, 2)
    RoaringBitmap64.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitmap64.new()
    RoaringBitmap64.insert(bitset2, 2)
    RoaringBitmap64.insert(bitset2, 3)
    RoaringBitmap64.insert(bitset2, 4)

    {:ok, bitset3} = RoaringBitmap64.new()
    RoaringBitmap64.insert(bitset3, 5)
    RoaringBitmap64.insert(bitset3, 3)
    RoaringBitmap64.insert(bitset3, 2)

    {:ok, intersection} = RoaringBitmap64.intersection([bitset1, bitset2, bitset3])
    assert {:ok, [2, 3]} == RoaringBitmap64.to_list(intersection)
  end

  test "union/1" do
    {:ok, bitset1} = RoaringBitmap64.new()
    RoaringBitmap64.insert(bitset1, 1)
    RoaringBitmap64.insert(bitset1, 2)
    RoaringBitmap64.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitmap64.new()
    RoaringBitmap64.insert(bitset2, 2)
    RoaringBitmap64.insert(bitset2, 3)
    RoaringBitmap64.insert(bitset2, 4)

    {:ok, bitset3} = RoaringBitmap64.new()
    RoaringBitmap64.insert(bitset3, 2)
    RoaringBitmap64.insert(bitset3, 3)
    RoaringBitmap64.insert(bitset3, 5)

    {:ok, union} = RoaringBitmap64.union([bitset1, bitset2, bitset3])
    assert {:ok, [1, 2, 3, 4, 5]} == RoaringBitmap64.to_list(union)
  end

  test "xor/2" do
    {:ok, bitset1} = RoaringBitmap64.new()
    RoaringBitmap64.insert(bitset1, 1)
    RoaringBitmap64.insert(bitset1, 2)
    RoaringBitmap64.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitmap64.new()
    RoaringBitmap64.insert(bitset2, 2)
    RoaringBitmap64.insert(bitset2, 3)
    RoaringBitmap64.insert(bitset2, 4)

    {:ok, xor} = RoaringBitmap64.xor(bitset1, bitset2)
    assert {:ok, [1, 4]} == RoaringBitmap64.to_list(xor)
  end

  test "difference/2" do
    {:ok, bitset1} = RoaringBitmap64.new()
    RoaringBitmap64.insert(bitset1, 1)
    RoaringBitmap64.insert(bitset1, 2)
    RoaringBitmap64.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitmap64.new()
    RoaringBitmap64.insert(bitset2, 2)
    RoaringBitmap64.insert(bitset2, 3)
    RoaringBitmap64.insert(bitset2, 4)

    {:ok, difference} = RoaringBitmap64.difference(bitset1, bitset2)
    assert {:ok, [1]} == RoaringBitmap64.to_list(difference)
  end

  test "(de)serialize" do
    {:ok, bitset1} = RoaringBitmap64.new()
    RoaringBitmap64.insert(bitset1, 1)
    RoaringBitmap64.insert(bitset1, 2)
    RoaringBitmap64.insert(bitset1, 3)

    {:ok, bytes} = RoaringBitmap64.serialize(bitset1)

    {:ok, bitset2} = RoaringBitmap64.deserialize(bytes)

    {:ok, members1} = RoaringBitmap64.to_list(bitset1)
    {:ok, members2} = RoaringBitmap64.to_list(bitset2)
    assert members1 == [1, 2, 3]
    assert members2 == [1, 2, 3]
  end

  test "equal?/2" do
    {:ok, bitset1} = RoaringBitmap64.new()
    {:ok, bitset2} = RoaringBitmap64.new()

    assert {:ok, true} == RoaringBitmap64.equal?(bitset1, bitset2)

    RoaringBitmap64.insert(bitset1, 1)

    assert {:ok, false} == RoaringBitmap64.equal?(bitset1, bitset2)

    RoaringBitmap64.insert(bitset2, 1)

    assert {:ok, true} == RoaringBitmap64.equal?(bitset1, bitset2)

    RoaringBitmap64.insert(bitset2, 2)

    assert {:ok, false} == RoaringBitmap64.equal?(bitset1, bitset2)
  end

  test "size/1" do
    {:ok, bitset} = RoaringBitmap64.new()

    assert {:ok, 0} == RoaringBitmap64.size(bitset)

    RoaringBitmap64.insert(bitset, 42)

    assert {:ok, 1} == RoaringBitmap64.size(bitset)
  end
end
