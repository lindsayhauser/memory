# References Nat Tuck's lecture Notes
# http://www.ccs.neu.edu/home/ntuck/courses/2018/09/cs4550/notes/09-two-players/notes.html

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

  def resetGame(game, user) do
   GenServer.call(__MODULE__, {:resetGame, game, user})
  end

  #IMPLEMENTATION
  def init(args) do
    {:ok, args}
  end

  def handle_call({:view, game, user}, _from, state) do
    IO.puts("got to the game server")
    gg = Map.get(state, game, Game.new)
    gg = Game.addUser(gg, user)
    # IO.puts("Successfully added user")
    {:reply, Game.client_view(gg), Map.put(state, game, gg)}
  end

   def handle_call({:clickCard, game, user, cardNum}, _from, state) do
     # IO.puts("gen server updating one card")
    gg = Map.get(state, game, Game.new)
    |> Game.clickCard(user, cardNum)
    {:reply, Game.client_view(gg), Map.put(state, game, gg)}
  end

  def handle_call({:guess, game, user}, _from, state) do
     IO.puts("gen server checking the guess")
    gg = Map.get(state, game, Game.new)
    |> Game.guess()
    {:reply, Game.client_view(gg), Map.put(state, game, gg)}
  end

  def handle_call({:resetGame, game}, _from, state) do
    IO.puts("Making new game in genserver")
    gg = Game.new()
    {:reply, Game.client_view(gg), Map.put(state, game, gg)}
 end


end
