# PrettyLog

[![CI](https://github.com/ispirata/pretty_log/actions/workflows/ci.yml/badge.svg)](https://github.com/ispirata/pretty_log/actions/workflows/ci.yml)
[![Module Version](https://img.shields.io/hexpm/v/pretty_log.svg)](https://hex.pm/packages/pretty_log)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/pretty_log/)
[![Total Download](https://img.shields.io/hexpm/dt/pretty_log.svg)](https://hex.pm/packages/pretty_log)
[![License](https://img.shields.io/hexpm/l/pretty_log.svg)](https://github.com/ispirata/pretty_log/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/ispirata/pretty_log.svg)](https://github.com/ispirata/pretty_log/commits/master)

PrettyLog is an Elixir library which provides some ready-to-use log formatters, including a `Logfmt` formatter.

## Installation

Add `:pretty_log` dependency to your project's `mix.exs`:

```elixir
def deps do
  [
    {:pretty_log, "~> 0.1"}
  ]
end
```
Update depedencies:

```sh
$ mix deps.get
```

## Using PrettyLog

Just change the `:format` config entry in your config/{prod,dev,test}.exs files:

```elixir
-config :logger, :console, format: "[$level] $message\n"
+config :logger, :console,
+  format: {PrettyLog.LogfmtFormatter, :format},
+  metadata: [:module, :request_id, :tag]
```

metadata is arbitrary and optional.

You may change the default key names via the following config options, values must be atoms:

```elixir
config :pretty_log,
  :timestamp_key_name, :when, # defaults to :ts
  :level_key_name, :severity, # defaults to :level
  :message_key_name, :humans, # defaults to :msg
```

## Available Formatters

Following formatters are included:
- `PrettyLog.LogfmtFormatter`
- `PrettyLog.UserFriendlyFormatter`

## Formatter Vs Backend

Formatter and logger backend are two distinct components.
- The formatter transforms a log message and its metadata into a binary
- The logger backend outputs log binaries

This library is focused on logs formatting, leaving to you the choice about your favourite backend.

## Copyright and License

Copyright (c) 2019 Astarte

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## About This Project

This project has been created in order to provide better logs in [Astarte](https://github.com/astarte-platform/astarte).
We are open to any contribution and we encourage adoption of this library, also outside Astarte, in order to provide better logs to everyone.

