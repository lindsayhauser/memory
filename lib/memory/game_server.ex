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
   def guess(game, user, cardNum) do
    GenServer.call(__MODULE__, {:guess, game, user, cardNum})
  end


   ## Implementations
   def init(state) do
     {:ok, state}
   end

  def handle_call({:view, game, user}, _from, state) do
    gg = Map.get(state, game, Game.new)
    Game.addUser(gg, user)
    {:reply, Game.client_view(gg, user), Map.put(game, gg)}
  end

   def handle_call({:guess, game, user, cardNum}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.guess(user, letter)
    {:reply, Game.client_view(gg, user), Map.put(game, gg)}
  end
end
