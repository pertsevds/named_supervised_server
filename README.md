# NamedSupervisedServer

The NamedSupervisedServer module simplifies the start-up of supervised GenServers with specific names and customizable initialization processes.

NamedSupervisedServer is a GenServer + start\_link/1 behavior. By default, it registers name \_\_MODULE\_\_, but you can also supply a different name.

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
