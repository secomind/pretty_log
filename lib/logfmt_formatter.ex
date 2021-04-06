#
# This file is part of PrettyLog.
#
# Copyright 2019 Ispirata Srl
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

defmodule PrettyLog.LogfmtFormatter do
  alias PrettyLog.TextSanitizer

  epoch = {{1970, 1, 1}, {0, 0, 0}}
  @epoch :calendar.datetime_to_gregorian_seconds(epoch)

  def format(level, message, timestamp, metadata) do
    {date, {h, m, s, millis}} = timestamp

    pre_message_metadata = Application.get_env(:logfmt, :prepend_metadata, [])

    timestamp_key_name = Application.get_env(:pretty_log, :timestamp_key_name, :ts)
    message_key_name = Application.get_env(:pretty_log, :message_key_name, :msg)
    level_key_name = Application.get_env(:pretty_log, :level_key_name, :level)

    {pre_meta, metadata} = Keyword.split(metadata, pre_message_metadata)

    timestamp =
      :erlang.localtime_to_universaltime({date, {h, m, s}})
      |> :calendar.datetime_to_gregorian_seconds()
      |> Kernel.-(@epoch)

    timestamp_string =
      (timestamp * 1000 + millis)
      |> :calendar.system_time_to_rfc3339(unit: :millisecond)
      |> to_string()

    kv =
      TextSanitizer.sanitize_keyword(
        [
          {level_key_name, level},
          {timestamp_key_name, timestamp_string} | pre_meta
        ] ++
          [
            {message_key_name, message} | metadata
          ]
      )

    [Logfmt.encode(kv), "\n"]
  rescue
    _ -> "LOG_FORMATTER_ERROR: #{inspect({level, message, timestamp, metadata})}\n"
  end
end
