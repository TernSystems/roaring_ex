defmodule RoaringBitmap32Test do
  use ExUnit.Case

  test "to_list/1" do
    {:ok, bitset} = RoaringBitmap32.new()

    RoaringBitmap32.insert(bitset, 1)
    RoaringBitmap32.insert(bitset, 4)

    {:ok, result} = RoaringBitmap32.to_list(bitset)
    assert result == [1, 4]
  end

  test "remove/2" do
    {:ok, bitset} = RoaringBitmap32.new()

    RoaringBitmap32.insert(bitset, 1)
    RoaringBitmap32.insert(bitset, 2)
    RoaringBitmap32.remove(bitset, 1)

    assert {:ok, false} == RoaringBitmap32.contains?(bitset, 1)
    assert {:ok, true} == RoaringBitmap32.contains?(bitset, 2)
  end

  test "contains?/2" do
    {:ok, bitset} = RoaringBitmap32.new()

    RoaringBitmap32.insert(bitset, 1)

    assert {:ok, true} == RoaringBitmap32.contains?(bitset, 1)
    assert {:ok, false} == RoaringBitmap32.contains?(bitset, 2)
  end

  test "intersection/1" do
    {:ok, bitset1} = RoaringBitmap32.new()
    RoaringBitmap32.insert(bitset1, 1)
    RoaringBitmap32.insert(bitset1, 2)
    RoaringBitmap32.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitmap32.new()
    RoaringBitmap32.insert(bitset2, 2)
    RoaringBitmap32.insert(bitset2, 3)
    RoaringBitmap32.insert(bitset2, 4)

    {:ok, bitset3} = RoaringBitmap32.new()
    RoaringBitmap32.insert(bitset3, 5)
    RoaringBitmap32.insert(bitset3, 3)
    RoaringBitmap32.insert(bitset3, 2)

    {:ok, intersection} = RoaringBitmap32.intersection([bitset1, bitset2, bitset3])
    assert {:ok, [2, 3]} == RoaringBitmap32.to_list(intersection)
  end

  test "union/1" do
    {:ok, bitset1} = RoaringBitmap32.new()
    RoaringBitmap32.insert(bitset1, 1)
    RoaringBitmap32.insert(bitset1, 2)
    RoaringBitmap32.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitmap32.new()
    RoaringBitmap32.insert(bitset2, 2)
    RoaringBitmap32.insert(bitset2, 3)
    RoaringBitmap32.insert(bitset2, 4)

    {:ok, bitset3} = RoaringBitmap32.new()
    RoaringBitmap32.insert(bitset3, 2)
    RoaringBitmap32.insert(bitset3, 3)
    RoaringBitmap32.insert(bitset3, 5)

    {:ok, union} = RoaringBitmap32.union([bitset1, bitset2, bitset3])
    assert {:ok, [1, 2, 3, 4, 5]} == RoaringBitmap32.to_list(union)
  end

  test "xor/2" do
    {:ok, bitset1} = RoaringBitmap32.new()
    RoaringBitmap32.insert(bitset1, 1)
    RoaringBitmap32.insert(bitset1, 2)
    RoaringBitmap32.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitmap32.new()
    RoaringBitmap32.insert(bitset2, 2)
    RoaringBitmap32.insert(bitset2, 3)
    RoaringBitmap32.insert(bitset2, 4)

    {:ok, xor} = RoaringBitmap32.xor(bitset1, bitset2)
    assert {:ok, [1, 4]} == RoaringBitmap32.to_list(xor)
  end

  test "difference/2" do
    {:ok, bitset1} = RoaringBitmap32.new()
    RoaringBitmap32.insert(bitset1, 1)
    RoaringBitmap32.insert(bitset1, 2)
    RoaringBitmap32.insert(bitset1, 3)

    {:ok, bitset2} = RoaringBitmap32.new()
    RoaringBitmap32.insert(bitset2, 2)
    RoaringBitmap32.insert(bitset2, 3)
    RoaringBitmap32.insert(bitset2, 4)

    {:ok, difference} = RoaringBitmap32.difference(bitset1, bitset2)
    assert {:ok, [1]} == RoaringBitmap32.to_list(difference)
  end

  test "(de)serialize" do
    {:ok, bitset1} = RoaringBitmap32.new()
    RoaringBitmap32.insert(bitset1, 1)
    RoaringBitmap32.insert(bitset1, 2)
    RoaringBitmap32.insert(bitset1, 3)

    {:ok, bytes} = RoaringBitmap32.serialize(bitset1)

    {:ok, bitset2} = RoaringBitmap32.deserialize(bytes)

    {:ok, members1} = RoaringBitmap32.to_list(bitset1)
    {:ok, members2} = RoaringBitmap32.to_list(bitset2)
    assert members1 == [1, 2, 3]
    assert members2 == [1, 2, 3]
  end

  test "equal?/2" do
    {:ok, bitset1} = RoaringBitmap32.new()
    {:ok, bitset2} = RoaringBitmap32.new()

    assert {:ok, true} == RoaringBitmap32.equal?(bitset1, bitset2)

    RoaringBitmap32.insert(bitset1, 1)

    assert {:ok, false} == RoaringBitmap32.equal?(bitset1, bitset2)

    RoaringBitmap32.insert(bitset2, 1)

    assert {:ok, true} == RoaringBitmap32.equal?(bitset1, bitset2)

    RoaringBitmap32.insert(bitset2, 2)

    assert {:ok, false} == RoaringBitmap32.equal?(bitset1, bitset2)
  end

  test "size/1" do
    {:ok, bitset} = RoaringBitmap32.new()

    assert {:ok, 0} == RoaringBitmap32.size(bitset)

    RoaringBitmap32.insert(bitset, 42)

    assert {:ok, 1} == RoaringBitmap32.size(bitset)
  end

  describe "from_list/1 — bulk path" do
    alias RoaringBitmap.NifBridge

    test "empty list returns empty bitmap" do
      assert {:ok, ref} = RoaringBitmap32.from_list([])
      assert is_reference(ref)
      assert {:ok, list} = RoaringBitmap32.to_list(ref)
      assert list == []
    end

    test "small list returns bitmap with exactly those members" do
      assert {:ok, ref} = RoaringBitmap32.from_list([1, 5, 100])
      assert {:ok, list} = RoaringBitmap32.to_list(ref)
      assert Enum.sort(list) == [1, 5, 100]
    end

    test "large list (100k) succeeds" do
      members = Enum.to_list(1..100_000)
      assert {:ok, ref} = RoaringBitmap32.from_list(members)
      assert {:ok, list} = RoaringBitmap32.to_list(ref)
      assert length(list) == 100_000
    end

    test "direct NifBridge.from_list_32/1 returns ok+reference" do
      assert {:ok, ref} = NifBridge.from_list_32([1, 2, 3])
      assert is_reference(ref)
    end
  end
end
