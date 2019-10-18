defmodule PrettyLog.UserFriendlyFormatterTest do
  use ExUnit.Case
  alias PrettyLog.UserFriendlyFormatter
  doctest PrettyLog.UserFriendlyFormatter

  test "formats a warning log entry" do
    assert :erlang.iolist_to_binary(
             UserFriendlyFormatter.format(
               :warn,
               "This is a test message",
               {{2019, 10, 8}, {11, 58, 39, 5}},
               []
             )
           ) == "11:58:39.5\t|WARN | This is a test message\n"
  end
end
