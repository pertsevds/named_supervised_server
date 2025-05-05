
# NamedSupervisedServer

[![CI](https://github.com/pertsevds/named_supervised_server/actions/workflows/ci.yml/badge.svg)](https://github.com/pertsevds/named_supervised_server/actions/workflows/ci.yml)
[![Hex.pm License](https://img.shields.io/hexpm/l/named_supervised_server)](https://hex.pm/packages/named_supervised_server)
[![Hex.pm Version](https://img.shields.io/hexpm/v/named_supervised_server)](https://hex.pm/packages/named_supervised_server)
[![Hex.pm Docs](https://img.shields.io/badge/hex-docs-lightgreen)](https://hexdocs.pm/named_supervised_server)
[![Hex.pm Downloads](https://img.shields.io/hexpm/dt/named_supervised_server)](https://hex.pm/packages/named_supervised_server)

The NamedSupervisedServer module simplifies the start-up of supervised GenServers with specific names and customizable initialization processes.

NamedSupervisedServer is a GenServer + start\_link/1 behavior. By default, it registers name \_\_MODULE\_\_, but you can also supply a different name.

Compatible with PartitionSupervisor.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `named_supervised_server` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:named_supervised_server, "~> 0.1"}
  ]
end
```

## Documentation

<https://hexdocs.pm/named_supervised_server>
