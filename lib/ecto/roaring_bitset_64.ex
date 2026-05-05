defmodule EctoRoaring.RoaringBitmap64 do
  @moduledoc """
  Ecto support for loading RoaringBitmap64 from the DB.

  Usage:

      create table(:sets) do
        add :membership_64, :bytea
      end

      schema "sets" do
        field :membership_64, EctoRoaring.RoaringBitmap64
      end
  """
  use Ecto.Type

  def type(), do: :binary

  def cast(nil), do: {:ok, nil}

  def cast(list) when is_list(list) do
    RoaringBitmap64.from_list(list)
  end

  def cast(bitset) when is_reference(bitset) do
    {:ok, bitset}
  end

  def cast(data) when is_binary(data) do
    RoaringBitmap64.deserialize(data)
  end

  def load(data) when is_binary(data) do
    RoaringBitmap64.deserialize(data)
  end

  def load(nil), do: {:ok, nil}

  def dump(nil), do: {:ok, nil}

  def dump(bitset) when is_reference(bitset) do
    RoaringBitmap64.serialize(bitset)
  end

  def dump(data) when is_binary(data) do
    {:ok, data}
  end

  def dump(_), do: :error

  def equal?(nil, nil), do: true
  def equal?(nil, _), do: false
  def equal?(_, nil), do: false

  def equal?(bitset_ref_1, bitset_ref_2)
      when is_reference(bitset_ref_1) and is_reference(bitset_ref_2) do
    # Ecto uses equal? to determine if a field has changed in a changeset. However,
    # our bitset membership may have changed even if the reference did not change.
    # If that is the case, bitset_ref_1 will be the same as bitset_ref_2 and will always
    # look to be equal when serialized even if the membership used to be different.

    # Always return false so we always capture changes.

    false
  end
end
