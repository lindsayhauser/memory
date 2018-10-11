import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root, channel) {
  ReactDOM.render(<Memory channel={channel}/>, root);
}

// References: http://www.ccs.neu.edu/home/ntuck/courses/2018/09/cs4550/notes/06-channels/notes.html
class Memory extends React.Component {
  constructor(props) {
    super(props);
    //this.sendGuess = this.sendGuess.bind(this);
    this.channel = props.channel;
    this.state = {
      guessed: [],
      player_one: "",
      player_two: "",
      player_one_score: 0,
      player_two_score: 0
    }

    this.firstCard  = null;  // The index of first card in a round clicked

    this.channel.join()
            .receive("ok", this.gotView.bind(this))
            .receive("error", resp => { console.log("Unable to join", resp)});

    this.channel.on("clickCard", ({view}) => {
      // console.log("We got an update")
      console.log(view)
      this.setState(view);
    });

    this.channel.on("cardGuessed", ({view}) => {
      // console.log("We got an update")
      console.log(view)
      this.setState(view);
    });

    
  }

  gotView(view) {
    this.setState(view.game);
    console.log(view.game)
  }

  newGame() {
    this.channel.push("restart")
        .receive("ok", this.gotView.bind(this))
  }

  // Check if the 2 cards clicked is a correct guess
  sendGuess(view) {
    this.setState(view.game);
    this.channel.push("guess")
        .receive("ok", this.gotView.bind(this))
  }


  handleClickChange(cardNum) {
    this.channel.push("clickCard", {card1: cardNum})
    .receive("ok", this.sendGuess.bind(this));

    // this.channel.push("clickCard", {cardNum})
    // .receive("ok", this.sendGuess.bind(this));

    // this.gotView.bind(this)

    // this.firstCard = null;

    // // Then this is the first card we clicked
    // if(this.firstCard == null) {
    //   this.firstCard = cardNum

    //   this.channel.push("updateOneCard", {card1: cardNum})
    //             .receive("ok", this.gotView.bind(this));
    // }
    // else {
      // Second card clicked

    // }
  }

  render() {
    return (
  <div>
    <h3>Memory Game!</h3>
    <div className="row">
      <Card root={this} num={0} handleClickChange={this.handleClickChange.bind(this)} />
      <Card root={this} num={1} handleClickChange={this.handleClickChange.bind(this)}/>
      <Card root={this} num={2} handleClickChange={this.handleClickChange.bind(this)}/>
      <Card root={this} num={3} handleClickChange={this.handleClickChange.bind(this)}/>
    </div>
    <div className="row">
      <Card root={this} num={4} handleClickChange={this.handleClickChange.bind(this)}/>
      <Card root={this} num={5} handleClickChange={this.handleClickChange.bind(this)}/>
      <Card root={this} num={6} handleClickChange={this.handleClickChange.bind(this)}/>
      <Card root={this} num={7} handleClickChange={this.handleClickChange.bind(this)}/>
    </div>
    <div className="row">
      <Card root={this} num={8} handleClickChange={this.handleClickChange.bind(this)}/>
      <Card root={this} num={9} handleClickChange={this.handleClickChange.bind(this)}/>
      <Card root={this} num={10} handleClickChange={this.handleClickChange.bind(this)}/>
      <Card root={this} num={11} handleClickChange={this.handleClickChange.bind(this)}/>
    </div>
    <div className="row">
      <Card root={this} num={12} handleClickChange={this.handleClickChange.bind(this)}/>
      <Card root={this} num={13} handleClickChange={this.handleClickChange.bind(this)}/>
      <Card root={this} num={14} handleClickChange={this.handleClickChange.bind(this)}/>
      <Card root={this} num={15} handleClickChange={this.handleClickChange.bind(this)}/>
    </div>
    { <p>Player {this.state.player_one} score: {this.state.player_one_score}</p> }
    { <p>Player {this.state.player_two} score: {this.state.player_two_score}</p> }
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
  let root = params.root
  let number = params.num
  var guessed = root.state.guessed[number]

  if (guessed != false && guessed != undefined) {
    guessed = String.fromCharCode(guessed)
    return(
    <div className='border' >
      <div className = 'greenSquare'>
          <p>{guessed}</p>
      </div>
    </div>)
  }

  return (
  <div className='border' onClick={() => params.handleClickChange(number)}>
    <div className='square'>
      <p>?</p>
    </div>
  </div>);
}
