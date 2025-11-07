# Roaring Elixir

Rustler wrapper around [roaring-rs](https://github.com/RoaringBitmap/roaring-rs/) a Rust roaring bitmap implementation

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `roaring` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:roaring, "~> 0.11.2"}
  ]
end
```

## Usage
```elixir
{:ok, bitset} = RoaringBitset.new()

RoaringBitset.insert(bitset1, 1)
:ok
RoaringBitset.insert(bitset1, 2)
:ok

{:ok, bitset2} = RoaringBitset.new()

RoaringBitset.insert(bitset2, 2)
:ok
RoaringBitset.insert(bitset2, 3)
:ok

RoaringBitset.equal(bitset1, bitset2)
{:ok, false}

{:ok, bitset3} = RoaringBitset.intersection(bitset1, bitset2)
RoaringBitset.to_list(bitset3)
[2]

{:ok, bitset4} = RoaringBitset.union(bitset1, bitset2)
RoaringBitset.to_list(bitset4)
[1, 2, 3]
```
