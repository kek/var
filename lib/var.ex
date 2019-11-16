defmodule Var do
  @moduledoc """
  Documentation for Var.
  """

  def step(g, fun) do
    fun.(g)
  end

  def set(g, k, v) do
    Map.put(g, k, v)
  end

  def new() do
    %{}
  end

  def ifzero(g, key, if_true, if_false) do
    if Map.get(g, key) == 0 do
      if_true.(g)
    else
      if_false.(g)
    end
  end

  def ifequals(g, key, test_value, if_true, if_false) do
    if Map.get(g, key) == test_value do
      if_true.(g)
    else
      if_false.(g)
    end
  end

  def while_unset(g, key, fun) do
    if Map.get(g, key) do
      g
    else
      while_unset(fun.(g), key, fun)
    end
  end
end
