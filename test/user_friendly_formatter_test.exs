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

  test "formats an error log entry with an integer metadata" do
    assert :erlang.iolist_to_binary(
             UserFriendlyFormatter.format(
               :error,
               "This is a test message",
               {{2019, 10, 8}, {11, 58, 39, 5}},
               line: 100
             )
           ) ==
             "11:58:39.5\t|ERROR| This is a test message  line=100\n"
  end

  test "format does not crash" do
    assert :erlang.iolist_to_binary(UserFriendlyFormatter.format(:fail, "hello", :err, [])) ==
             "LOG_FORMATTER_ERROR: {:fail, \"hello\", :err, []}\n"
  end
end
