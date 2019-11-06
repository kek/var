defmodule VarTest do
  use ExUnit.Case
  doctest Var

  test "greets the world" do
    assert Var.hello() == :world
  end
end
