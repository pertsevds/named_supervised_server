# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2023 Dmitriy Pertsev

defmodule NamedSupervisedServer do
  @moduledoc """
  A behaviour module for starting supervised GenServer that is named as `__MODULE__` by default or you can supply different name.

  With the use of `NamedSupervisedServer`, you can avoid the need to add `c:start_link/1` function with `name: __MODULE__`
  to your module every time you write a new one.
  And if you need your own `c:start_link/1` function, you can override it.

  ## Usage

  * Add `use NamedSupervisedServer` to your module.
  * View [`Examples`](#module-examples).

  > #### `use NamedSupervisedServer` {: .info}
  >
  > When you `use NamedSupervisedServer`, the NamedSupervisedServer module will:
  > * set `@behaviour NamedSupervisedServer`,
  > * add `use GenServer`,
  > * pass options passed to `use NamedSupervisedServer` to `use GenServer`,
  > * define a `c:start_link/1` function with `name: __MODULE__`, so your module does not need to define it
  > if you don't want a custom one.

  ## Callbacks

  The following callbacks may be implemented by modules that use the `NamedSupervisedServer` behavior:

  - `c:start_link/1`: Starts a GenServer process linked to the current process.
    This function is often used to start the server as part of a supervision tree.

  `c:start_link/1` callback should return one of the following values:

  - `{:ok, pid}`: The server was successfully created and initialized.

  - `:ignore`: The server should be ignored, and no further action is taken.

  - `{:error, {:already_started, pid}}`: A process with the specified name already exists.

  - `{:error, reason}`: The initialization of the server failed for the given reason.

  - `{:stop, reason}`: The process is terminated due to the provided reason.

  ## Options

  `c:start_link/1` callback accept the following option:

  - `:name` (optional): Used for name registration as described in the "Name Registration" section
    in the documentation for `GenServer`.

  ## Examples

  ### Basic usage
  ```elixir
  iex> defmodule MyServer do
  ...>  use NamedSupervisedServer
  ...>
  ...>  @impl GenServer
  ...>  def init(arg) do
  ...>    {:ok, arg}
  ...>  end
  ...>end
  ...># Starting a supervised process
  ...>{:ok, sup} = Supervisor.start_link([MyServer], strategy: :one_for_one)
  ...>{_id, child, _type, _modules} = hd(Supervisor.which_children(sup))
  ...>assert Process.whereis(MyServer) == child
  ```

  ### Additional options
  ```elixir
  iex> defmodule TransientServer do
  ...>  use NamedSupervisedServer, restart: :transient, shutdown: 10_000
  ...>
  ...>  @impl GenServer
  ...>  def init(arg) do
  ...>    {:ok, arg}
  ...>  end
  ...>end
  ...># Starting a supervised process
  ...>{:ok, sup} = Supervisor.start_link([TransientServer], strategy: :one_for_one)
  ...>{:ok, chldspec} = :supervisor.get_childspec(sup, TransientServer)
  ...>assert chldspec.restart == :transient
  ...>assert chldspec.shutdown == 10_000
  ...>{_id, child, _type, _modules} = hd(Supervisor.which_children(sup))
  ...>assert Process.whereis(TransientServer) == child
  ```

  ### Naming the process with different name
  ```elixir
  iex>defmodule NamedServer do
  ...>  use NamedSupervisedServer
  ...>
  ...>  @impl GenServer
  ...>  def init(arg) do
  ...>    {:ok, arg}
  ...>  end
  ...>
  ...>  @impl GenServer
  ...>  def handle_call(:get_my_arg, _from, state) do
  ...>    {:reply, {:ok, state[:my_arg]}, state}
  ...>  end
  ...>
  ...>  def get_my_arg(pid) do
  ...>    GenServer.call(pid, :get_my_arg)
  ...>  end
  ...>end
  ...>
  ...>children = [
  ...>  {NamedServer, [my_arg: "Hello named server!", name: :my_named_server]}
  ...>]
  ...># Starting a named supervised process
  ...>{:ok, _} = Supervisor.start_link(children, strategy: :one_for_one)
  ...>
  ...># Access the named process using its registered name
  ...>{:ok, "Hello named server!"} = NamedServer.get_my_arg(:my_named_server)
  ```

  ### Custom start_link/1
  ```elixir
  iex>defmodule CustomServer do
  ...>  use NamedSupervisedServer
  ...>
  ...>  # Override start_link/1 to provide additional options
  ...>  @impl NamedSupervisedServer
  ...>  def start_link(args) when is_list(args) do
  ...>    GenServer.start_link(__MODULE__, args, name: :custom_server)
  ...>  end
  ...>
  ...>  @impl GenServer
  ...>  def init(arg) do
  ...>    {:ok, arg}
  ...>  end
  ...>end
  ...>
  ...># Starting a custom supervised GenServer process
  ...>{:ok, sup} = Supervisor.start_link([CustomServer], strategy: :one_for_one)
  ...>{_id, child, _type, _modules} = hd(Supervisor.which_children(sup))
  ...>assert Process.whereis(:custom_server) == child
  ```

  ## References

  * `GenServer`
  * `Supervisor`
  """

  @doc """
  Starts a `NamedSupervisedServer` process linked to the current process that is named as `__MODULE__` by default or you can supply different name.

  This is often used to start the `NamedSupervisedServer` as part of a supervision tree.

  Once the server is started, the `init/1` function of the given is called
  with `init_arg` as its argument to initialize the server. To ensure a
  synchronized start-up procedure, this function does not return until `init/1`
  has returned.

  Note that a `NamedSupervisedServer` started with `c:start_link/1` is linked to the
  parent process and will exit in case of crashes from the parent. The `NamedSupervisedServer`
  will also exit due to the `:normal` reasons in case it is configured to trap
  exits in the `init/1` callback.

  ## Options

  - `:name` (optional): Used for name registration as described in the "Name Registration" section
    in the documentation for `GenServer`.

  ## Return values

  If the server is successfully created and initialized, this function returns
  `{:ok, pid}`, where `pid` is the PID of the server. If a process with the
  specified server name already exists, this function returns
  `{:error, {:already_started, pid}}` with the PID of that process.

  If the `init/1` callback fails with `reason`, this function returns
  `{:error, reason}`. Otherwise, if it returns `{:stop, reason}`
  or `:ignore`, the process is terminated and this function returns
  `{:error, reason}` or `:ignore`, respectively.
  """
  @callback start_link(args) :: GenServer.on_start()
            when args: list

  @doc false
  @spec __using__(opts :: keyword) :: Macro.t()
  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @behaviour NamedSupervisedServer

      use GenServer, Macro.escape(opts)

      @doc false
      @impl NamedSupervisedServer
      def start_link(args) when is_list(args) do
        {name, init_args} = Keyword.pop(args, :name)

        case name do
          nil -> GenServer.start_link(__MODULE__, init_args, name: __MODULE__)
          _ -> GenServer.start_link(__MODULE__, init_args, name: name)
        end
      end

      defoverridable start_link: 1
    end
  end
end
