import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root) {
  ReactDOM.render(<Memory />, root);
}

class Memory extends React.Component {
  constructor(props) {
    super(props);
    this.handleClickChange = this.handleClickChange.bind(this);
    this.state =  this.initializeGame() // initialize the game
  }

  initializeGame() {
    return {
    totalClicks: 0,                   // total clicks
    board: this.initializeCards(),    // letters of the board
    currClicks: Array(2).fill(null),  // last 2 tiles clicked
    guessed: Array(16).fill(null),    // the guessed tiles.
  }
}

  initializeCards() {
    let array = Array(16).fill(null)
    array[0] = 'A'
    array[1] = 'A'
    array[2] = 'B'
    array[3] = 'B'
    array[4] = 'C'
    array[5] = 'C'
    array[6] = 'D'
    array[7] = 'D'
    array[8] = 'E'
    array[9] = 'E'
    array[10] = 'F'
    array[11] = 'F'
    array[12] = 'G'
    array[13] = 'G'
    array[14] = 'H'
    array[15] = 'H'

    return this.shuffleCards(array)
  }

  newGame() {
    this.setState(this.initializeGame());
  }

  // Referenced: https://stackoverflow.com/questions/6274339/how-can-i-shuffle-an-array
  shuffleCards(array) {
    let x = array.length;
    
    while(x > 0) {
      x--;
      let i = Math.floor(Math.random() * x);

      let tempArray = array[x];
      array[x] = array[i];
      array[i] = tempArray;
    }
    return array;
  }

  handleClickChange(cardNum) {
    var totalCLicks = this.state.totalClicks;
    var currClicks = this.state.currClicks;
    var guessedArray = this.state.guessed;

    // prevents user from clicking more than 2 cards at one time
    if (currClicks[0] != null && currClicks[1] != null) {
      return;
    }
    // First card clicked
    if (currClicks[0] == null) {
      currClicks[0] = cardNum;
      guessedArray[cardNum] = true;
    }
    // A second card is chosen
    else {
      guessedArray[cardNum] = true;
      currClicks[1] = cardNum;

      var valueAtIndex = this.state.board[currClicks[0]];
      var valueAtIndex2 = this.state.board[cardNum];

      if (valueAtIndex == valueAtIndex2) {
        currClicks = Array(2).fill(null);
      }
      else {
      // Reference for timeout: https://stackoverflow.com/questions/41254029/sleep-function-for-react-native
      setTimeout(() => {
      guessedArray[currClicks[0]] = null;
      guessedArray[cardNum] = null;
      currClicks = Array(2).fill(null);
      this.setState({totalClicks: totalCLicks + 1, guessed: guessedArray, currClicks: currClicks});
    }, 1000)
    }
  }
  this.setState({totalClicks: totalCLicks + 1, guessed: guessedArray, currClicks: currClicks});
}

  render() {
    return (
  <div>
    <h3>Memory Game!</h3>
    <div className="row">
      <Card root={this} num={0} />
      <Card root={this} num={1} />
      <Card root={this} num={2} />
      <Card root={this} num={3} />
    </div>
    <div className="row">
      <Card root={this} num={4}/>
      <Card root={this} num={5}/>
      <Card root={this} num={6}/>
      <Card root={this} num={7}/>
    </div>
    <div className="row">
      <Card root={this} num={8}/>
      <Card root={this} num={9}/>
      <Card root={this} num={10}/>
      <Card root={this} num={11}/>
    </div>
    <div className="row">
      <Card root={this} num={12}/>
      <Card root={this} num={13}/>
      <Card root={this} num={14}/>
      <Card root={this} num={15}/>
    </div>
    { <p>Total number of Clicks: {this.state.totalClicks}</p> }
    <div>
      <p>
        <button onClick={this.newGame.bind(this)}>New Game</button>
      </p>
    </div>
  </div>
    );
  }
}

function Card(params) {
  let root = params.root;
  let number = params.num;

  var valueAtIndex = root.state.board[number];
  var guessed = root.state.guessed[number]
  
  if (guessed) {
    return(
    <div className='border' >
      <div className = 'greenSquare'>
          <p>{valueAtIndex}</p>
      </div>
    </div>)
  }
  
  return (
  <div className='border' onClick={() => root.handleClickChange(number)}>
    <div className='square'>
      <p>?</p>
    </div>
  </div>);
}