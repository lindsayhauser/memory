# Referenced http://www.ccs.neu.edu/home/ntuck/courses/2018/09/cs4550/notes/06-channels/notes.html
defmodule Memory.Game do
  def new do
    %{
      numClicks: 0,
      cards: initialize_cards(),    # The board answers
      guessed: initialize_empty(),  # board containing correct guesses
      guessed1: nil,  # first card guessed in the round
      guessed2: nil   # second card guessed in the round
    }
  end

  # Used Reference: https://groups.google.com/forum/#!topic/elixir-lang-talk/8l6ai0DNdEI
  def initialize_empty do
    Enum.map 1..16, fn _ -> false end
  end

  def initialize_cards do
    cards = ['A', 'A', 'B', 'B', 'C', 'C', 'D', 'D', 'E', 'E', 'F', 'F',
    'G', 'G', 'H', 'H']
    cards = Enum.shuffle(cards)
    cards
  end

  def client_view(game) do
    %{
      guessed: game.guessed,
      numClicks: game.numClicks
    }
  end

  # Updated when one card is clicked
  def updateOneCard(game, card1) do
    tc = game.numClicks + 1
    c = game.cards
    c1 = elem(Enum.fetch(c, card1), 1)
    guesses = game.guessed
    g1 = card1

    guesses = List.replace_at(guesses, card1, c1)
    game = Map.put(game, :numClicks, tc)
    game = Map.put(game, :guessed1, g1)
    game = Map.put(game, :guessed, guesses)
    game
  end

  # This updates the guesses such that two cards have now been clicked in the
  # round
  def updateTwoCards(game, card1, card2) do
    # Prevents user from clicking more than 2 cards in a round
    if game.guessed2 != nil do
      game
    end
    tc = game.numClicks + 1
    c = game.cards
    c2 = elem(Enum.fetch(c, card2), 1)
    guesses = game.guessed
    g2 = card2
    guesses = List.replace_at(guesses, card2, c2)

    game = Map.put(game, :numClicks, tc)
    game = Map.put(game, :guessed2, g2)
    game = Map.put(game, :guessed, guesses)
    game
  end

  # Checks to see if the two cards that have been clicked are the same. If they are,
  # update the correctly guess state. Otherwise, remove them from the guesses
  def guess(game) do
    Process.sleep(800)
    g1 = game.guessed1
    g2 = game.guessed2
    cg = game.guessed
    c = game.cards

    c1 = elem(Enum.fetch(c, g1), 1)
    c2 = elem(Enum.fetch(c, g2), 1)

  cond do
    c1 == c2 ->
      cg = List.replace_at(cg, g1, c1)
      cg = List.replace_at(cg, g2, c2)
      game = Map.put(game, :guessed, cg)
      game = Map.put(game, :guessed1, nil)
      game = Map.put(game, :guessed2, nil)
      game
    g1 == g2 ->
      game
    true ->
      cg = List.replace_at(cg, g1, false)
      cg = List.replace_at(cg, g2, false)
      game = Map.put(game, :guessed, cg)
      game = Map.put(game, :guessed1, nil)
      game = Map.put(game, :guessed2, nil)
      game
    end
end
end
