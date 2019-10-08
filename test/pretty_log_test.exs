defmodule PrettyLogTest do
  use ExUnit.Case
  doctest PrettyLog

  test "greets the world" do
    assert PrettyLog.hello() == :world
  end
end
