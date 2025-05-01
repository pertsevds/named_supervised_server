# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2023 Dmitriy Pertsev

defmodule TestGenServer do
  @moduledoc false
  use NamedSupervisedServer, restart: :transient, shutdown: 10_000

  @impl GenServer
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl GenServer
  def handle_call(:get_state, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end
end

defmodule TestGenServerOverrided do
  @moduledoc false
  use NamedSupervisedServer, restart: :transient, shutdown: 10_000

  @impl NamedSupervisedServer
  def start_link(args) do
    GenServer.start_link(__MODULE__, args ++ [custom: "value"], name: __MODULE__)
  end

  @impl GenServer
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl GenServer
  def handle_call(:get_state, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end
end

defmodule NamedSupervisedServerTest do
  use ExUnit.Case

  doctest NamedSupervisedServer

  # Helper function for asserting child specifications
  defp assert_child_spec(pid, module, expected_restart, expected_shutdown, expected_state, expected_name) do
    {:ok, sup} = ExUnit.fetch_test_supervisor()
    {:ok, chldspec} = :supervisor.get_childspec(sup, module)
    assert chldspec.restart == expected_restart
    assert chldspec.shutdown == expected_shutdown
    assert module.get_state(pid) == expected_state
    assert Process.whereis(expected_name) == pid
  end

  describe "TestGenServerOverrided with overridden start_link" do
    test "without name and without parameters" do
      {:ok, pid} = start_supervised(TestGenServerOverrided)

      assert_child_spec(
        pid,
        TestGenServerOverrided,
        :transient,
        10_000,
        {:ok, [{:custom, "value"}]},
        TestGenServerOverrided
      )
    end

    test "without name and with parameters" do
      {:ok, pid} = start_supervised({TestGenServerOverrided, [fk: 0]})

      assert_child_spec(
        pid,
        TestGenServerOverrided,
        :transient,
        10_000,
        {:ok, [{:fk, 0}, {:custom, "value"}]},
        TestGenServerOverrided
      )
    end

    test "with name and without parameters" do
      name = MyOverridedServer
      {:ok, pid} = start_supervised({TestGenServerOverrided, [name: name]})

      assert_child_spec(
        pid,
        TestGenServerOverrided,
        :transient,
        10_000,
        {:ok, [{:name, name}, {:custom, "value"}]},
        TestGenServerOverrided
      )
    end

    test "with name and with parameters" do
      name = MyOverridedServer
      {:ok, pid} = start_supervised({TestGenServerOverrided, [name: name, fk: 0]})

      assert_child_spec(
        pid,
        TestGenServerOverrided,
        :transient,
        10_000,
        {:ok, [{:name, name}, {:fk, 0}, {:custom, "value"}]},
        TestGenServerOverrided
      )
    end
  end

  describe "TestGenServer without overrides" do
    test "without name and without parameters" do
      {:ok, pid} = start_supervised(TestGenServer)
      assert_child_spec(pid, TestGenServer, :transient, 10_000, {:ok, []}, TestGenServer)
    end

    test "without name and with parameters" do
      {:ok, pid} = start_supervised({TestGenServer, [fk: 0]})
      assert_child_spec(pid, TestGenServer, :transient, 10_000, {:ok, [fk: 0]}, TestGenServer)
    end

    test "with name and without parameters" do
      name = MyServer
      {:ok, pid} = start_supervised({TestGenServer, [name: name]})
      assert_child_spec(pid, TestGenServer, :transient, 10_000, {:ok, []}, name)
    end

    test "with name and with parameters" do
      name = MyServer
      {:ok, pid} = start_supervised({TestGenServer, [name: name, fk: 0]})
      assert_child_spec(pid, TestGenServer, :transient, 10_000, {:ok, [fk: 0]}, name)
    end
  end

  describe "Multiple :name's" do
    test "TestGenServer without overrides and without parameters" do
      name = MyServer
      {:ok, pid} = start_supervised({TestGenServer, [name: name, name: MyServer2]})
      assert_child_spec(pid, TestGenServer, :transient, 10_000, {:ok, []}, name)
    end
  end
end
