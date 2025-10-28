defmodule SparseBitset do
  alias SparseBitset.NifBridge


  @default_depth 3
  @default_block_size 128

  def add(arg1, arg2 \\ 1) do
   NifBridge.add(arg1, arg2)
  end

  def new(_depth \\ @default_depth, _block_size \\ @default_block_size) do
    :ok  
  end
end
