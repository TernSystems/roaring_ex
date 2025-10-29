defmodule SparseBitset do
  alias SparseBitset.NifBridge


  @default_depth 3
  @default_block_size 128

  def new(depth \\ @default_depth, block_size \\ @default_block_size) do
    NifBridge.new(depth, block_size)
  end

  def to_list(set) do
    NifBridge.to_list(set)
  end

  def insert(set, index) do
    NifBridge.insert(set, index)

    :ok
  end

  def contains?(set, index) do
    NifBridge.contains(set, index)
  end

  def intersection([set1 | rest]) do
    # TODO: Ideally we'd push down all the sets at once into the NIF
    Enum.reduce(rest, set1, fn next_set, result -> 
      NifBridge.intersection(result, next_set)
    end)
  end
end
