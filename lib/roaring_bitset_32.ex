defmodule RoaringBitmap32 do
  @moduledoc """
  Provides a NIF for interfacing with [Roaring Bitmaps](https://github.com/RoaringBitmap/roaring-rs)

  The bitsets are managed in memory by Rust behind a mutex.
  All members are 32-bit unsigned integers (u32, max value 4,294,967,295).

  Use `RoaringBitmap` instead if you need 64-bit integer support.

  Any method on an existing bitset ref may return `{:error, :lock_fail}`
  if the method is unable to obtain mutex access.
  """
  alias RoaringBitmap.NifBridge

  @doc """
  Return a reference to a new 32-bit roaring bitset.

  ## Examples

      iex> RoaringBitmap32.new()
      {:ok, bitset_ref}
  """
  def new() do
    NifBridge.new_32()
  end

  @doc """
  Create a new 32-bit bitset from the list of `members`. Can take any enumerable
  as input, but may not be performant for large lists. Prefer
  `RoaringBitmap32.deserialize/1` if performance is critical.

  ## Examples

      iex> RoaringBitmap32.from_list([1, 2, 22])
      {:ok, bitset_ref}
  """
  def from_list(members) when is_list(members), do: NifBridge.from_list_32(members)
  def from_list(members), do: NifBridge.from_list_32(Enum.to_list(members))

  @doc """
  Export this bitset to a list of 32-bit integers. Leaves the `bitset_ref`
  still valid. May not be performant for large lists. Prefer
  `RoaringBitmap32.serialize/1` if performance is critical.

  ## Examples

      iex> RoaringBitmap32.to_list(bitset_ref)
      {:ok, [1, 2, 22]}
  """
  def to_list(set) do
    NifBridge.to_list_32(set)
  end

  @doc """
  Inserts a `member` (u32) into the referenced set.

  ## Examples

      iex> RoaringBitmap32.insert(bitset_ref, 15)
      :ok
  """
  def insert(set, member) do
    {:ok, :ok} = NifBridge.insert_32(set, member)
    :ok
  end

  @doc """
  Removes a `member` (u32) from the referenced set.

  ## Examples

      iex> RoaringBitmap32.remove(bitset_ref, 15)
      :ok
  """
  def remove(set, member) do
    {:ok, :ok} = NifBridge.remove_32(set, member)
    :ok
  end

  @doc """
  Checks for set membership.

  ## Examples

      iex> RoaringBitmap32.contains?(bitset_ref, 15)
      {:ok, true}
  """
  def contains?(set, index) do
    NifBridge.contains_32(set, index)
  end

  @doc """
  Returns a reference to a new set representing the intersection of
  all supplied sets.

  ## Examples

      iex> RoaringBitmap32.intersection([bitset_ref1, bitset_ref2])
      {:ok, new_bitset_ref}
  """
  def intersection([set1 | rest]) do
    # TODO: Ideally we'd push down all the sets at once into the NIF
    new_set =
      Enum.reduce(rest, set1, fn next_set, result ->
        {:ok, updated} = NifBridge.intersection_32(result, next_set)

        updated
      end)

    {:ok, new_set}
  end

  def intersection(set1, set2), do: intersection([set1, set2])

  @doc """
  Returns a reference to a new set representing the union of
  all supplied sets.

  ## Examples

      iex> RoaringBitmap32.union([bitset_ref1, bitset_ref2])
      {:ok, new_bitset_ref}
  """
  def union([set1 | rest]) do
    # TODO: Ideally we'd push down all the sets at once into the NIF
    new_set =
      Enum.reduce(rest, set1, fn next_set, result ->
        {:ok, updated} = NifBridge.union_32(result, next_set)

        updated
      end)

    {:ok, new_set}
  end

  def union(set1, set2), do: union([set1, set2])

  @doc """
  Returns a reference to a new set representing the symmetric difference (XOR)
  of two sets.

  ## Examples

      iex> RoaringBitmap32.xor(bitset_ref1, bitset_ref2)
      {:ok, new_bitset_ref}
  """
  def xor(set1, set2) do
    NifBridge.xor_32(set1, set2)
  end

  @doc """
  Returns a reference to a new set representing the difference of two sets
  (elements in `set1` that are not in `set2`).

  ## Examples

      iex> RoaringBitmap32.difference(bitset_ref1, bitset_ref2)
      {:ok, new_bitset_ref}
  """
  def difference(set1, set2) do
    NifBridge.difference_32(set1, set2)
  end

  @doc """
  Serializes the bitset to the
  [cross-platform serialization format](https://github.com/RoaringBitmap/RoaringFormatSpec/)
  in binary form. (32-bit)

  ## Examples

      iex> RoaringBitmap32.serialize(bitset_ref)
      {:ok, <<...>>}
  """
  def serialize(set) do
    NifBridge.serialize_32(set)
  end

  @doc """
  Deserializes a binary into a new 32-bit bitset ref.
  Uses the [cross-platform serialization format](https://github.com/RoaringBitmap/RoaringFormatSpec/)
  in binary form. (32-bit)

  ## Examples

      iex> RoaringBitmap32.deserialize(binary)
      {:ok, bitset_ref}
  """
  def deserialize(binary) do
    NifBridge.deserialize_32(binary)
  end

  @doc """
  Check for the equality of two sets.
  """
  def equal?(set1, set2) do
    NifBridge.equal_32(set1, set2)
  end

  @doc """
  Returns the number of members within the set.
  """
  def size(set) do
    NifBridge.size_32(set)
  end
end
