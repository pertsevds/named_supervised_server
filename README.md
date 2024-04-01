# NamedSupervisedServer

The NamedSupervisedServer module simplifies the start-up of supervised GenServers with specific names and customizable initialization processes.

NamedSupervisedServer is a GenServer behavior that can be started using start_link/1. By default, it is named as \_\_MODULE\_\_, but you can also supply a different name.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `named_supervised_server` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:named_supervised_server, "~> 0.1.0"}
  ]
end
```

## Documentation

<https://hexdocs.pm/named_supervised_server>
