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
               :error,
               "This is a test message",
               {{2019, 10, 8}, {11, 58, 39, 5}},
               line: 100
             )
           ) ==
             "level=error ts=2019-10-08T11:58:39.005+02:00 msg=\"This is a test message\" line=100\n"
  end

  test "formats an info log entry with a tuple metadata" do
    assert :erlang.iolist_to_binary(
             LogfmtFormatter.format(
               :info,
               "This is a test message",
               {{2019, 10, 8}, {11, 58, 39, 5}},
               tuple: {:foo, 42, :bar}
             )
           ) ==
             "level=info ts=2019-10-08T11:58:39.005+02:00 msg=\"This is a test message\" " <>
               "tuple=\"base64-encoded-ext-term:g2gDZAADZm9vYSpkAANiYXI=\"\n"
  end

  test "formats a debug log entry with a keyword list metadata" do
    assert :erlang.iolist_to_binary(
             LogfmtFormatter.format(
               :debug,
               "This is a test message",
               {{2019, 10, 8}, {11, 58, 39, 5}},
               kwlist: [a: 1, b: 2]
             )
           ) ==
             "level=debug ts=2019-10-08T11:58:39.005+02:00 msg=\"This is a test message\" " <>
               "kwlist=\"base64-encoded-ext-term:g2wAAAACaAJkAAFhYQFoAmQAAWJhAmo=\"\n"
  end
end
