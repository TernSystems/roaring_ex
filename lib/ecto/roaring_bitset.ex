defmodule Ecto.RoaringBitset do
  use Ecto.Type

  def type(), do: :binary

  def cast(nil), do: {:ok, nil}

  def cast(bitset) when is_reference(bitset) do
   {:ok, bitset} 
  end

  def cast(data) when is_binary(data) do
    RoaringBitset.deserialize(data)
  end

  def load(data) when is_binary(data) do
   RoaringBitset.deserialize(data)  
  end

  def load(nil), do: {:ok, nil}

  def dump(nil), do: {:ok, nil}

  def dump(bitset) when is_reference(bitset) do
    RoaringBitset.serialize(bitset)
  end

  def dump(_), do: :error

  def equal?(nil, nil), do: true
  def equal?(nil, _), do: false
  def equal?(_, nil), do: false

  def equal?(bitset1, bitset2) when is_reference(bitset1) and is_reference(bitset2) do 
    RoaringBitset.equal?(bitset1, bitset2)
  end
end
