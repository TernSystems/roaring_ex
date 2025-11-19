defmodule Ecto.RoaringBitset do
  use Ecto.Type

  def type(), do: :binary

  def cast(nil), do: {:ok, nil}

  def cast(bitset) when is_reference(bitset) do
    RoaringBitset.serialize(bitset)
  end

  def cast(data) when is_binary(data) do
    {:ok, data}
  end

  def load(data) when is_binary(data) do
    RoaringBitset.deserialize(data)
  end

  def load(nil), do: {:ok, nil}

  def dump(nil), do: {:ok, nil}

  def dump(bitset) when is_reference(bitset) do
    RoaringBitset.serialize(bitset)
  end

  def dump(data) when is_binary(data) do
    {:ok, data}
  end

  def dump(_), do: :error

  def equal?(nil, nil), do: true
  def equal?(nil, _), do: false
  def equal?(_, nil), do: false

  def equal?(bitset1, bitset2) do
    # Ecto uses equal? to determine if a field has changed in a changeset. However,
    # when we load a bitset we load the deserialized version and when we cast it we
    # use the serialized version. Make sure both are serialized so we can compare.

    with {:ok, b1} <- normalize(bitset1),
         {:ok, b2} <- normalize(bitset2),
         {:ok, equal?} <- RoaringBitset.equal?(b1, b2) do
      equal?
    else
      _ -> false
    end
  end

  defp normalize(bitset) when is_reference(bitset), do: {:ok, bitset}

  defp normalize(data) when is_binary(data) do
    RoaringBitset.deserialize(data)
  end
end
