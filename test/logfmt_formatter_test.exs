defmodule PrettyLog.LogfmtFormatterTest do
  use ExUnit.Case
  alias PrettyLog.LogfmtFormatter
  doctest PrettyLog.LogfmtFormatter

  epoch = {{1970, 1, 1}, {0, 0, 0}}
  @epoch :calendar.datetime_to_gregorian_seconds(epoch)

  @time {{2019, 10, 8}, {11, 58, 39, 5}}

  def local_tz_offset(time) do
    {date, {h, m, s, millis}} = time

    timestamp =
      {date, {h, m, s}}
      |> :erlang.localtime_to_universaltime()
      |> :calendar.datetime_to_gregorian_seconds()
      |> Kernel.-(@epoch)

    {_, offset} =
      (timestamp * 1000 + millis)
      |> :calendar.system_time_to_rfc3339(unit: :millisecond)
      |> to_string()
      |> String.split_at(-5)

    offset
  end

  test "formats a warning log entry" do
    assert :erlang.iolist_to_binary(
             LogfmtFormatter.format(
               :warn,
               "This is a test message",
               @time,
               []
             )
           ) ==
             "level=warn ts=2019-10-08T11:58:39.005+#{local_tz_offset(@time)} msg=\"This is a test message\"\n"
  end

  test "formats an error log entry with an integer metadata" do
    assert :erlang.iolist_to_binary(
             LogfmtFormatter.format(
               :error,
               "This is a test message",
               @time,
               line: 100
             )
           ) ==
             "level=error ts=2019-10-08T11:58:39.005+#{local_tz_offset(@time)} msg=\"This is a test message\" line=100\n"
  end

  test "formats an info log entry with a tuple metadata" do
    assert :erlang.iolist_to_binary(
             LogfmtFormatter.format(
               :info,
               "This is a test message",
               @time,
               tuple: {:foo, 42, :bar}
             )
           ) ==
             "level=info ts=2019-10-08T11:58:39.005+#{local_tz_offset(@time)} msg=\"This is a test message\" " <>
               "tuple=\"base64-encoded-ext-term:g2gDZAADZm9vYSpkAANiYXI=\"\n"
  end

  test "formats a debug log entry with a keyword list metadata" do
    assert :erlang.iolist_to_binary(
             LogfmtFormatter.format(
               :debug,
               "This is a test message",
               @time,
               kwlist: [a: 1, b: 2]
             )
           ) ==
             "level=debug ts=2019-10-08T11:58:39.005+#{local_tz_offset(@time)} msg=\"This is a test message\" " <>
               "kwlist=\"base64-encoded-ext-term:g2wAAAACaAJkAAFhYQFoAmQAAWJhAmo=\"\n"
  end

  test "formats a debug log entry with metadata having different types" do
    assert :erlang.iolist_to_binary(
             LogfmtFormatter.format(:debug, "test.", @time, a: Test, a2: :test, i: 42, f: 1.5)
           ) ==
             "level=debug ts=2019-10-08T11:58:39.005+#{local_tz_offset(@time)} msg=test. a=Test a2=test i=42 f=1.5\n"
  end

  test "formats a debug log entry with pid metadata" do
    assert :erlang.iolist_to_binary(LogfmtFormatter.format(:debug, "test.", @time, p: self())) =~
             "level=debug ts=2019-10-08T11:58:39.005+#{local_tz_offset(@time)} msg=test. p=#PID<"
  end

  test "format does not crash" do
    assert :erlang.iolist_to_binary(LogfmtFormatter.format(:fail, "hello", :err, [])) ==
             "LOG_FORMATTER_ERROR: {:fail, \"hello\", :err, []}\n"
  end

  describe "level key name configuration" do
    setup do
      Application.put_env(:pretty_log, :level_key_name, :severity)

      on_exit(fn ->
        Application.delete_env(:pretty_log, :level_key_name)
      end)
    end

    test "sets level key" do
      assert :erlang.iolist_to_binary(
               LogfmtFormatter.format(
                 :warn,
                 "This is a test message",
                 @time,
                 []
               )
             ) ==
               "severity=warn ts=2019-10-08T11:58:39.005+#{local_tz_offset(@time)} msg=\"This is a test message\"\n"
    end
  end

  describe "timestamp name configuration" do
    setup do
      Application.put_env(:pretty_log, :timestamp_key_name, :event_at)

      on_exit(fn ->
        Application.delete_env(:pretty_log, :timestamp_key_name)
      end)
    end

    test "sets timestamp key" do
      assert :erlang.iolist_to_binary(
               LogfmtFormatter.format(
                 :warn,
                 "This is a test message",
                 @time,
                 []
               )
             ) ==
               "level=warn event_at=2019-10-08T11:58:39.005+#{local_tz_offset(@time)} msg=\"This is a test message\"\n"
    end
  end

  describe "message name configuration" do
    setup do
      Application.put_env(:pretty_log, :message_key_name, :note_to_human)

      on_exit(fn ->
        Application.delete_env(:pretty_log, :message_key_name)
      end)
    end

    test "sets message key" do
      assert :erlang.iolist_to_binary(
               LogfmtFormatter.format(
                 :warn,
                 "This is a test message",
                 @time,
                 []
               )
             ) ==
               "level=warn ts=2019-10-08T11:58:39.005+#{local_tz_offset(@time)} note_to_human=\"This is a test message\"\n"
    end
  end
end
