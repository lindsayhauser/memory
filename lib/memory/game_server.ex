## TODO references the lecture notes

defmodule Memory.GameServer do
  use GenServer
   alias Memory.Game
   ## Client Interface
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end
   def view(game, user) do
    GenServer.call(__MODULE__, {:view, game, user})
  end
   def guess(game, user, letter) do
    GenServer.call(__MODULE__, {:guess, game, user, letter})
  end
   ## Implementations
  def handle_call({:view, game, user}, _from, state) do
    gg = Map.get(state, game, Game.new)
    {:reply, Game.client_view(gg, user), Map.put(game, gg)}
  end
   def handle_call({:guess, game, user, letter}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.guess(user, letter)
    {:reply, Game.client_view(gg, user), Map.put(game, gg)}
  end
end
