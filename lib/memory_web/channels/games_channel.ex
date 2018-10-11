# Referenced http://www.ccs.neu.edu/home/ntuck/courses/2018/09/cs4550/notes/06-channels/notes.html
defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game
  alias Memory.GameServer

  def join("games:" <> game, payload, socket) do
    if authorized?(payload) do
      socket = assign(socket, :game, game)
      view = GameServer.view(game, socket.assigns[:user])
      {:ok, %{"join" => game, "game" => view}, socket}
    else
      {:error, %{reason: "unauthorized"}}
      end
    end

  def handle_in("guess", _payload, socket) do
    view = GameServer.guess(socket.assigns[:game], socket.assigns[:user])
    broadcast! socket, "cardGuessed", %{view: view}
    {:reply, {:ok, %{ "game" => view}}, socket}
  end

  def handle_in("clickCard", %{"card1" => c1}, socket) do
    IO.puts("We clicked a card")
    view = GameServer.clickCard(socket.assigns[:game], socket.assigns[:user], c1)
    broadcast! socket, "clickCard", %{view: view}
    {:reply, {:ok, %{ "game" => view}}, socket}
  end

  def handle_in("restart", payload, socket) do
    IO.puts("User decided to restart the game")
    # gg = Game.new()
    view = GameServer.resetGame(socket.assigns[:game], socket.assigns[:user])
    {:reply, {:ok, %{"game" => view}}, socket}
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
