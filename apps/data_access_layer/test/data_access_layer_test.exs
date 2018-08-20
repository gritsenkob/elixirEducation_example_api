defmodule DataAccessLayerTest do
  use ExUnit.Case
  doctest DataAccessLayer

  test "greets the world" do
    assert DataAccessLayer.hello() == :world
  end
end
