defmodule RoaringBitmap.NifBridge do
  use Rustler,
    otp_app: :roaring,
    crate: :roaring_nif

  # 64-bit (RoaringTreemap) stubs
  def new_64(), do: :erlang.nif_error(:nif_not_loaded)
  def to_list_64(_set), do: :erlang.nif_error(:nif_not_loaded)
  def insert_64(_set, _index), do: :erlang.nif_error(:nif_not_loaded)
  def remove_64(_set, _index), do: :erlang.nif_error(:nif_not_loaded)
  def contains_64(_set, _index), do: :erlang.nif_error(:nif_not_loaded)
  def intersection_64(_set1, _set2), do: :erlang.nif_error(:nif_not_loaded)
  def union_64(_set1, _set2), do: :erlang.nif_error(:nif_not_loaded)
  def xor_64(_set1, _set2), do: :erlang.nif_error(:nif_not_loaded)
  def difference_64(_set1, _set2), do: :erlang.nif_error(:nif_not_loaded)
  def serialize_64(_set), do: :erlang.nif_error(:nif_not_loaded)
  def deserialize_64(_binary), do: :erlang.nif_error(:nif_not_loaded)
  def equal_64(_set1, _set2), do: :erlang.nif_error(:nif_not_loaded)
  def size_64(_set), do: :erlang.nif_error(:nif_not_loaded)

  # 32-bit (RoaringBitmap) stubs
  def new_32(), do: :erlang.nif_error(:nif_not_loaded)
  def to_list_32(_set), do: :erlang.nif_error(:nif_not_loaded)
  def insert_32(_set, _index), do: :erlang.nif_error(:nif_not_loaded)
  def remove_32(_set, _index), do: :erlang.nif_error(:nif_not_loaded)
  def contains_32(_set, _index), do: :erlang.nif_error(:nif_not_loaded)
  def intersection_32(_set1, _set2), do: :erlang.nif_error(:nif_not_loaded)
  def union_32(_set1, _set2), do: :erlang.nif_error(:nif_not_loaded)
  def xor_32(_set1, _set2), do: :erlang.nif_error(:nif_not_loaded)
  def difference_32(_set1, _set2), do: :erlang.nif_error(:nif_not_loaded)
  def serialize_32(_set), do: :erlang.nif_error(:nif_not_loaded)
  def deserialize_32(_binary), do: :erlang.nif_error(:nif_not_loaded)
  def equal_32(_set1, _set2), do: :erlang.nif_error(:nif_not_loaded)
  def size_32(_set), do: :erlang.nif_error(:nif_not_loaded)
end
