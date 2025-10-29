defmodule SparseBitset do
  alias SparseBitset.NifBridge

  def new() do
    NifBridge.new()
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

  def union([set1 | rest]) do
    # TODO: Ideally we'd push down all the sets at once into the NIF
    Enum.reduce(rest, set1, fn next_set, result ->
      NifBridge.union(result, next_set)
    end)
  end
end
