defmodule SparseBitset.NifBridge do
  use Rustler,
    otp_app: :sparse_bitset,
    crate: :sparsebitset

  def add(_arg1, _arg2), do: :erlang.nif_error(:nif_not_loaded)
  def new(_depth, _block_size), do: :erlang.nif_error(:nif_not_loaded)
end
