defmodule PrettyLog.LogfmtFormatterTest do
  use ExUnit.Case
  alias PrettyLog.LogfmtFormatter
  doctest PrettyLog.LogfmtFormatter

  test "formats a warning log entry" do
    assert :erlang.iolist_to_binary(
             LogfmtFormatter.format(
               :warn,
               "This is a test message",
               {{2019, 10, 8}, {11, 58, 39, 5}},
               []
             )
           ) ==
             "level=warn ts=2019-10-08T11:58:39.005+02:00 msg=\"This is a test message\"\n"
  end

  test "formats an error log entry with an integer metadata" do
    assert :erlang.iolist_to_binary(
             LogfmtFormatter.format(
               :warn,
               "This is a test message",
               {{2019, 10, 8}, {11, 58, 39, 5}},
               line: 100
             )
           ) ==
             "level=warn ts=2019-10-08T11:58:39.005+02:00 msg=\"This is a test message\" line=100\n"
  end
end
