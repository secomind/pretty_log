#
# This file is part of PrettyLog.
#
# Copyright 2019-2021 Ispirata Srl
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

defmodule PrettyLog.UserFriendlyFormatter do
  alias Logger.Formatter
  alias PrettyLog.TextSanitizer

  def format(level, message, timestamp, metadata) do
    {_date, {h, m, s, millis}} = timestamp

    pre_message_metadata = Application.get_env(:logfmt, :prepend_metadata, [])

    {pre_meta, metadata} = Keyword.split(metadata, pre_message_metadata)

    time_string = "#{to_string(h)}:#{to_string(m)}:#{to_string(s)}.#{to_string(millis)}"

    level_string =
      level
      |> TextSanitizer.sanitize()
      |> String.upcase()
      |> String.pad_trailing(5)

    sanitized_message =
      message
      |> TextSanitizer.sanitize()
      |> :erlang.iolist_to_binary()
      |> Formatter.prune()

    encoded_metadata =
      (pre_meta ++ metadata)
      |> TextSanitizer.sanitize_keyword()
      |> Logfmt.encode(output: :iolist)

    if encoded_metadata != [] do
      [time_string, "\t|", level_string, "| ", sanitized_message, "  ", encoded_metadata, ?\n]
    else
      [time_string, "\t|", level_string, "| ", sanitized_message, ?\n]
    end
  rescue
    _ -> "LOG_FORMATTER_ERROR: #{inspect({level, message, timestamp, metadata})}\n"
  end
end
