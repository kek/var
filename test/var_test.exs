defmodule VarTest do
  use ExUnit.Case
  doctest Var

  test "works" do
    assert Var.new()
           |> Var.set(:a, 1)
           |> Var.step(&inc_a/1) == %{a: 2}
  end

  defp inc_a(%{a: a}) do
    %{a: a + 1}
  end

  defp dec_a(%{a: a}) do
    %{a: a - 1}
  end

  describe "conditionals" do
    test "if not zero" do
      actual =
        Var.new()
        |> Var.ifzero(
          :a,
          fn _ -> %{true: true} end,
          fn _ -> %{false: false} end
        )

      assert actual == %{false: false}
    end

    test "if zero" do
      actual =
        Var.new()
        |> Var.set(:a, 0)
        |> Var.ifzero(
          :a,
          fn _ -> %{true: true} end,
          fn _ -> %{false: false} end
        )

      assert actual == %{true: true}
    end

    test "if equals" do
      actual =
        Var.new()
        |> Var.set(:a, "foo")
        |> Var.ifequals(
          :a,
          "foo",
          fn _ -> %{true: true} end,
          fn _ -> %{false: false} end
        )

      assert actual == %{true: true}
    end

    test "if not equals" do
      actual =
        Var.new()
        |> Var.set(:a, "bar")
        |> Var.ifequals(
          :a,
          "foo",
          fn _ -> %{true: true} end,
          fn _ -> %{false: false} end
        )

      assert actual == %{false: false}
    end
  end

  describe "looping" do
    test "while" do
      stop_if_a_zero = fn g -> Map.put(g, :stop, "STOP") end
      identity = fn g -> g end

      actual =
        Var.new()
        |> Var.set(:a, 100)
        |> Var.while_unset(:stop, fn g ->
          g
          |> Var.step(&dec_a/1)
          |> Var.ifzero(:a, stop_if_a_zero, identity)
        end)

      assert %{a: 0} = actual
    end
  end
end
