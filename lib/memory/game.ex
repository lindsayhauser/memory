# Referenced http://www.ccs.neu.edu/home/ntuck/courses/2018/09/cs4550/notes/06-channels/notes.html
defmodule Memory.Game do
  def new do
    %{
      # numClicks: 0, I don't think we'll need this anymore, TODO remove
      cards: initialize_cards(),    # The board answers
      guessed: initialize_empty(),  # board containing correct guesses
      guessed1: nil,  # first card guessed in the round
      guessed2: nil,   # second card guessed in the round
      player_turn: "",
      player_one: "",
      player_two: "",
      #players: %{},   # The players
    }
  end

# References the lecture notes TODO add
  def new(players) do
    players = Enum.map players, fn {name, info} ->
      {name, %{ score: info.score || 0 }}
    end
    Map.put(new(), :players, Enum.into(players, %{}))
  end

# A player has a score (increases by 1 when they get a correct match)
  # def default_player() do
  #   %{
  #     score: 0,
  #     guessed1: nil,  # first card guessed in the round
  #     guessed2: nil,   # second card guessed in the round
  #     #guesses: MapSet.new(),
  #     #turn: nil,  # is it this person's turn?
  #   }
  # end

  def clickCard(game, user, cardNum) do
    if(game.guessed1 == nil) do
      updateOneCard(game, user, cardNum)
    else
      updateTwoCards(game, user, nil, cardNum)
    end
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

  def addUser(game, user) do
    IO.puts("Adding User")
    if game.player_one == "" do
      IO.puts("Adding player 1")
      game = Map.put(game, :player_one, user)
      game = Map.put(game, :player_turn, user)
      game
    else
      if game.player_two == "" do
        IO.puts("Adding player 2")
        game = Map.put(game, :player_two, user)
        game
      else
        game
      end
      end
    end

    # # Otherwise, add to map of players

  def client_view(game, user) do

  # IO.puts("Player 2 name ")
  # IO.puts(game.player_two)
    %{
      guessed: game.guessed,
      #numClicks: game.numClicks
      player_one: game.player_one, #name of p1
      player_two: game.player_two # name of p2
    }
  end

  # Updated when one card is clicked
  def updateOneCard(game, user, card1) do
    if user == game.player_turn do  # Do a user check to make sure that the correct user is clicking
      #tc = game.numClicks + 1
      c = game.cards  # answers
      c1 = elem(Enum.fetch(c, card1), 1)  # Letter value of the card clicked
      guesses = game.guessed  # this is guess array to be sent to front end
      #g1 = card1

      guesses = List.replace_at(guesses, card1, c1)
      #game = Map.put(game, :numClicks, tc)
      game = Map.put(game, :guessed1, card1)  #first card guessed
      game = Map.put(game, :guessed, guesses) #guessed values to be sent back to front e
      game
    else
      game
    end
  end

  # This updates the guesses such that two cards have now been clicked in the
  # round
  def updateTwoCards(game, user, card1, card2) do
    if user == game.player_turn do  # prevents wrong user from clicking
    # if game.guessed2 != nil do  # Prevents user from clicking more than 2 cards in a round
    #   game
    # end

    c = game.cards
    c2 = elem(Enum.fetch(c, card2), 1)  # get letter of card
    guesses = game.guessed
    guesses = List.replace_at(guesses, card2, c2)
    game = Map.put(game, :guessed2, card2)  # update 2nd card clicked
    game = Map.put(game, :guessed, guesses) # updates the guesses list for front end

    nextPlay = nextPlayer(game, user)
    game = Map.put(game, :player_turn, nextPlay)   # switch player turn
    game
    #guess(game) # make the guess
  else
    game
  end
end

  def nextPlayer(game, currUser) do
    if currUser == game.player_one do
    game.player_two
  else
    game.player_one
  end
end

  # Checks to see if the two cards that have been clicked are the same. If they are,
  # update the correctly guess state. Otherwise, remove them from the guesses
  def guess(game) do
    if game.guessed1 == nil || game.guessed2 == nil do
      game
    else

    Process.sleep(800)
    g1 = game.guessed1  # card 1 flipped over
    g2 = game.guessed2  # card 2 flipped over
    cg = game.guessed   # list of all the correct guesses (to show on front end)
    c = game.cards      # is the list of all answers

    c1 = elem(Enum.fetch(c, g1), 1)  # get the card value of card 1
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
end
