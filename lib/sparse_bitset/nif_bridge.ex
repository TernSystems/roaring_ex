defmodule SparseBitset.NifBridge do
  use Rustler,
    otp_app: :sparse_bitset,
    crate: :sparsebitset

  def new(_depth, _block_size), do: :erlang.nif_error(:nif_not_loaded)
  def to_list(_set), do: :erlang.nif_error(:nif_not_loaded)
  def insert(_set, _index), do: :erlang.nif_error(:nif_not_loaded)
  def contains(_set, _index), do: :erlang.nif_error(:nif_not_loaded)
  def intersection(_set1, _set2), do: :erlang.nif_error(:nif_not_loaded)
end
