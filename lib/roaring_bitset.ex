defmodule RoaringBitset do
  @moduledoc """
  Provides a NIF for interfacing with [Roaring Bitmaps]
  (https://github.com/RoaringBitmap/roaring-rs)

  The bitsets are managed in memory by rust behind a mutex. 
  All members are 64 bit unsigned ints

  Any method on an existing bitset ref may return {:error, :lock_fail}
  if the method is unable to obtain mutex access
  """
  alias RoaringBitset.NifBridge

  @doc """
  Return a reference to a new roaring bitset

  ## Examples

      iex> RoaringBitset.new()
      {:ok, bitset_ref}
  """
  def new() do
    NifBridge.new()
  end

  @doc """
  Create a new bitset from the list of `members`. Can take any enumerable as input, 
  but may not be performant, particularly for large lists. Prefer RoaringBitset.deserialize/1 
  if performance is critical
  ## Examples
      iex> RoaringBitset.from_list([1, 2, 22])
      {:ok, bitset_ref}
  """
  def from_list(members) do
    # TODO: implement this within the NIF
    {:ok, set} = new()
    Enum.each(members, &NifBridge.insert(set, &1))

    {:ok, set}
  end

  @doc """
  Export this bitset to a list. Leaves the `bitset_ref` still valid. May not be performant
  particularly for large lists. Prefer RoaringBitset.serialize/1 if performance is critical

  ## Examples
      iex> RoaringBitset.to_list(bitset_ref)
      {:ok, [1, 2, 22]}
  """
  def to_list(set) do
    NifBridge.to_list(set)
  end

  @doc """
  Inserts a `member` into the referenced set

  ## Examples
      iex> RoaringBitset.insert(bitset_ref, 15)
      :ok
  """
  def insert(set, member) do
    {:ok, :ok} = NifBridge.insert(set, member)
    :ok
  end

  @doc """
  Checks for set membership.

  ## Examples
      iex> RoaringBitset.insert(bitset_ref, 15)
      {:ok, false}
  """
  def contains?(set, index) do
    NifBridge.contains(set, index)
  end

  @doc """
  Returns a reference to a new set representing the intersection of 
  all supplied sets

  ## Examples
      iex> RoaringBitset.intersection([bitset_ref, bitset_ref, ...])
      {:ok, new_bitset_ref}
  """
  def intersection([set1 | rest]) do
    # TODO: Ideally we'd push down all the sets at once into the NIF
    Enum.reduce(rest, set1, fn next_set, result ->
      NifBridge.intersection(result, next_set)
    end)
  end

  def intersection(set1, set2), do: intersection([set1, set2])

  @doc """
  Returns a reference to a new set representing the union of 
  all supplied sets

  ## Examples
      iex> RoaringBitset.union([bitset_ref, bitset_ref, ...])
      {:ok, new_bitset_ref}
  """
  def union([set1 | rest]) do
    # TODO: Ideally we'd push down all the sets at once into the NIF
    Enum.reduce(rest, set1, fn next_set, result ->
      NifBridge.union(result, next_set)
    end)
  end

  def union(set1, set2), do: union([set1, set2])

  @doc """
  Serializes the bitset to the [cross platform serialization format](https://github.com/RoaringBitmap/RoaringFormatSpec/) 
  in binary form.  (64-bit)

  ## Examples
      iex> RoaringBitset.serialize(bitset_ref)
      {:ok, <<...>>}
  """
  def serialize(set) do
    NifBridge.serialize(set)
  end

  @doc """
  Deserializes a binary into a new bitset ref
  Uses the [cross platform serialization format](https://github.com/RoaringBitmap/RoaringFormatSpec/) 
  in binary form. (64-bit)

  ## Examples
      iex> RoaringBitset.deserialize(binary)
      {:ok, bitset_ref}
  """
  def deserialize(binary) do
    NifBridge.deserialize(binary)
  end

  @doc """
  Check for the equality of two sets
  """
  def equal?(set1, set2) do
    NifBridge.equal(set1, set2)
  end

  @doc """
  Returns the number of members within the set
  """
  def size(set) do
    NifBridge.size(set)
  end
end
