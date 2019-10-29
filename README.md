# PrettyLog

PrettyLog is an Elixir library which provides some ready-to-use log formatters, including a Logfmt formatter.

## Installation
- Add `:pretty_log` dependency to your project's `mix.exs`:

```elixir
def deps do
  [
    {:pretty_log, "~> 0.1"}
  ]
end
```
- Run `mix deps.get`

## Using PrettyLog

Just change the `:format` config entry in your config/{prod,dev,test}.exs files:

```elixir
-config :logger, :console, format: "[$level] $message\n"
+config :logger, :console,
+  format: {PrettyLog.LogfmtFormatter, :format},
+  metadata: [:module, :request_id, :tag]
```

metadata is arbitrary and optional.

## Available Formatters

Following formatters are included:
- PrettyLog.LogfmtFormatter
- PrettyLog.UserFriendlyFormatter

## Formatter Vs Backend

Formatter and logger backend are two distinct components.
- The formatter transforms a log message and its metadata into a binary
- The logger backend outputs log binaries

This library is focused on logs formatting, leaving to you the choice about your favourite backend.

## About This Project

This project has been created in order to provide better logs in [Astarte](https://github.com/astarte-platform/astarte).
We are open to any contribution and we encourage adoption of this library, also outside Astarte, in order to provide better logs to everyone.
