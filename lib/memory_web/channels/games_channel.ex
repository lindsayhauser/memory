# Referenced http://www.ccs.neu.edu/home/ntuck/courses/2018/09/cs4550/notes/06-channels/notes.html
defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game
  alias Memory.BackupAgent

  def join("games:" <> game, payload, socket) do
    if authorized?(payload) do
      #game = BackupAgent.get(name) || Game.new()
      socket = assign(socket, :game, game)
      view = GameServer.view(game, socket.assigns[:user])
      {:ok, %{"join" => game, "game" => view}, socket}

      #socket = socket
      # |> assign(:game, game)
      # |> assign(:name, name)
      # BackupAgent.put(name, game)
      #{:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
      end
    end


  def handle_in("guess", _payload, socket) do
    #view = GameServer.guess(socket.assigns[:game], socket.assigns[:user], ll)
    #{:reply, {:ok, %{ "game" => view}}, socket}
    # name = socket.assigns[:name]
    # game = Game.guess(socket.assigns[:game])
    # socket = assign(socket, :game, game)
    # BackupAgent.put(name, game)
    # {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end

  def handle_in("updateOneCard", %{"card1" => c1}, socket) do
    view = GameServer.guess(socket.assigns[:game], socket.assigns[:user], c1)
    game = Game.updateOneCard(socket.assigns[:game], c1)
    socket = assign(socket, :game, game)
    name = socket.assigns[:name]
    BackupAgent.put(name, game)
    {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end

  def handle_in("updateTwoCards", %{"card1" => c1, "card2" => c2}, socket) do
    game = Game.updateTwoCards(socket.assigns[:game], c1, c2)
    socket = assign(socket, :game, game)
    name = socket.assigns[:name]
    BackupAgent.put(name, game)
    {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end

  def handle_in("restart", payload, socket) do
    game = Game.new()
    name = socket.assigns[:name]
    socket = socket
    |> assign(:game, game)
    |> assign(:name, name)
    BackupAgent.put(name, game)
    {:ok, %{"game" => Game.client_view(game)}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (games:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
