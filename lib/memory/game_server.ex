## TODO references the lecture notes

defmodule Memory.GameServer do
  use GenServer
  alias Memory.Game

  ## Client Interface
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def view(game, user) do
     IO.puts("called the gameserver view")
    GenServer.call(__MODULE__, {:view, game, user})
  end

   def guess(game, user) do
    GenServer.call(__MODULE__, {:guess, game, user})
  end


  def clickCard(game, user, c1) do
   GenServer.call(__MODULE__, {:clickCard, game, user, c1})
 end

 #  def updateOneCard(game, user, c1) do
 #   GenServer.call(__MODULE__, {:updateOneCard, game, user, c1})
 # end
 #
 # def updateTwoCards(game, user, c1, c2) do
 #   #IO.puts("called the gameserver view")
 #  GenServer.call(__MODULE__, {:updateTwoCards, game, user, c1, c2})
 #  end


  #IMPLEMENTATION
  def init(args) do
    {:ok, args}
  end

  def handle_call({:view, game, user}, _from, state) do
    IO.puts("got to the game server")
    gg = Map.get(state, game, Game.new)
    gg = Game.addUser(gg, user)
    IO.puts("Successfully added user")
    {:reply, Game.client_view(gg, user), Map.put(state, game, gg)}
  end

   def handle_call({:clickCard, game, user, cardNum}, _from, state) do
     IO.puts("gen server updating one card")
    gg = Map.get(state, game, Game.new)
    |> Game.clickCard(user, cardNum)
    {:reply, Game.client_view(gg, user), Map.put(state, game, gg)}
  end

 #  def handle_call({:updateOneCard, game, user, cardNum}, _from, state) do
 #    IO.puts("gen server updating one card")
 #   gg = Map.get(state, game, Game.new)
 #   |> Game.updateOneCard(user, cardNum)
 #   {:reply, Game.client_view(gg, user), Map.put(state, game, gg)}
 # end
 #
 # def handle_call({:updateTwoCards, game, user, card1, card2}, _from, state) do
 #   IO.puts("gen server updating second card")
 #  gg = Map.get(state, game, Game.new)
 #  |> Game.updateTwoCards(user, card1, card2)
 #  {:reply, Game.client_view(gg, user), Map.put(state, game, gg)}
 #  end

   def handle_call({:guess, game, user}, _from, state) do
     IO.puts("gen server checking the guess")
    gg = Map.get(state, game, Game.new)
    |> Game.guess()
    {:reply, Game.client_view(gg, user), Map.put(state, game, gg)}
  end
end
