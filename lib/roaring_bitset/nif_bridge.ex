defmodule RoaringBitset.NifBridge do
  use Rustler,
    otp_app: :roaring,
    crate: :roaring_nif

  def new(), do: :erlang.nif_error(:nif_not_loaded)
  def to_list(_set), do: :erlang.nif_error(:nif_not_loaded)
  def insert(_set, _index), do: :erlang.nif_error(:nif_not_loaded)
  def contains(_set, _index), do: :erlang.nif_error(:nif_not_loaded)
  def intersection(_set1, _set2), do: :erlang.nif_error(:nif_not_loaded)
  def union(_set1, _set2), do: :erlang.nif_error(:nif_not_loaded)
  def serialize(_set), do: :erlang.nif_error(:nif_not_loaded)
  def deserialize(_binary), do: :erlang.nif_error(:nif_not_loaded)
  def equal(_set1, _set2), do: :erlang.nif_error(:nif_not_loaded)
  def size(_set), do: :erlang.nif_error(:nif_not_loaded)
end
