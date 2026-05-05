# Roaring

RoaringBitmaps in Elixir, compressed bitmaps powered by roaring-rs. Enabling
fast compressed set operations in Elixir code.

Quick Rustler wrapper around [roaring-rs](https://github.com/RoaringBitmap/roaring-rs/) a Rust roaring bitmap implementation.

## Installation

[Available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `roaring` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:roaring, "~> 0.13.0"}
  ]
end
```

## Usage
```elixir
{:ok, bitset} = RoaringBitmap64.new()

RoaringBitmap64.insert(bitset1, 1)
:ok
RoaringBitmap64.insert(bitset1, 2)
:ok

{:ok, bitset2} = RoaringBitmap64.new()

RoaringBitmap64.insert(bitset2, 2)
:ok
RoaringBitmap64.insert(bitset2, 3)
:ok

RoaringBitmap64.equal(bitset1, bitset2)
{:ok, false}

{:ok, bitset3} = RoaringBitmap64.intersection(bitset1, bitset2)
RoaringBitmap64.to_list(bitset3)
[2]

{:ok, bitset4} = RoaringBitmap64.union(bitset1, bitset2)
RoaringBitmap64.to_list(bitset4)
[1, 2, 3]
```
