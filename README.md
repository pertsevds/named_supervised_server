
# NamedSupervisedServer

[![CI](https://github.com/pertsevds/named_supervised_server/actions/workflows/ci.yml/badge.svg)](https://github.com/pertsevds/named_supervised_server/actions/workflows/ci.yml)
[![Hex.pm License](https://img.shields.io/hexpm/l/named_supervised_server)](https://hex.pm/packages/named_supervised_server)
[![Hex.pm Version](https://img.shields.io/hexpm/v/named_supervised_server)](https://hex.pm/packages/named_supervised_server)
[![Hex.pm Docs](https://img.shields.io/badge/hex-docs-lightgreen)](https://hexdocs.pm/named_supervised_server)
[![Hex.pm Downloads](https://img.shields.io/hexpm/dt/named_supervised_server)](https://hex.pm/packages/named_supervised_server)

A lightweight behavior module that simplifies creating and supervising GenServers in Elixir applications.

## What it does

NamedSupervisedServer eliminates boilerplate when creating GenServers by:

- Automatically registering processes with their module name (`__MODULE__`)
- Supporting custom name registration via an optional `:name` parameter
- Providing a standard `start_link/1` implementation that works with supervision trees
- Maintaining full flexibility to override the default behavior when needed

## Features

- **Automatic Name Registration**: No need to manually specify process names for most use cases
- **Supervisor Friendly**: Designed to work seamlessly with Elixir's supervision trees
- **PartitionSupervisor Compatible**: Automatically appends partition numbers to process names and passes partition information to the initialization process
- **Customizable**: Override `start_link/1` for custom initialization behaviors

## Installation

Add to your `mix.exs` dependencies:

```elixir
def deps do
  [
    {:named_supervised_server, "~> 0.1"}
  ]
end
```

## Usage Examples and Documentation

For detailed usage examples and complete documentation, see:

<https://hexdocs.pm/named_supervised_server>
