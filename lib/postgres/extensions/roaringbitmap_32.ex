defmodule Roaring.Postgres.Extensions.RoaringBitmap32 do
  @moduledoc """
  Supports the pg_roaringbitmap Postgres extension
  """

  # Implements the Postgrex.Extension behavior but doesn't
  # depend on it
  # @behaviour Postgrex.Extension

  def init(opts) do
    Keyword.get(opts, :decode_copy, :copy)
  end

  def matching(_) do
    [type: "roaringbitmap"]
  end

  def format(_) do
    :binary
  end

  def encode(_opts) do
    quote location: :keep do
      %x{} = bitset when x == RoaringBitset32 ->
        [RoaringBitset32.serialize(bitset)]
    end
  end

  def decode(:reference) do
    quote location: :keep do
      <<len::integer-size(32), data::binary-size(len)>> ->
        {:ok, bitset} = RoaringBitset32.deserialize(data)
        bitset
    end
  end

  def decode(:copy) do
    quote location: :keep do
      <<len::integer-size(32), data::binary-size(len)>> ->
        {:ok, bitset} = RoaringBitset32.deserialize(data)
        bitset
    end
  end
end
