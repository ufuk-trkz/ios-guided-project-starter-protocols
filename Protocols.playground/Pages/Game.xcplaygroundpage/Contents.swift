import Foundation
//: We're building a dice game called _Knock Out!_. It is played using the following rules:
//: 1. Each player chooses a “knock out number” – either 6, 7, 8, or 9. More than one player can choose the same number.
//: 2. Players take turns throwing both dice, once each turn. Add the number of both dice to the player's running score.
//: 3. If a player rolls their own knock out number, they are knocked out of the game.
//: 4. Play ends when either all players have been knocked out, or if a single player scores 100 points or higher.
//:
//: Let's reuse some of the work we defined from the previous page.

protocol GeneratesRandomNumbers {
    func random() -> Int
}

class OneThroughTen: GeneratesRandomNumbers {
    func random() -> Int {
        return Int.random(in: 1...10)
    }
}

class Dice {
    let sides: Int
    let generator: GeneratesRandomNumbers
    
    init(sides: Int, generator: GeneratesRandomNumbers) {
        self.sides = sides
        self.generator = generator
    }
    
    func roll() -> Int {
        return Int(generator.random() % sides) + 1
    }
}
//: Now, let's define a couple protocols for managing a dice-based game.
protocol DiceGame {
    var dice: Dice { get }
    var players: [Player] { get set }
    
    func play()
}


//: Lastly, we'll create a custom class for tracking a player in our dice game.
class Player {
    let id: Int
    let knockOutNumber: Int = Int.random(in: 6...9)
    var score: Int = 0
    var knockedOut: Bool = false
    
    init(id: Int) {
        self.id = id
    }
    
    
}


//: With all that configured, let's build our dice game class called _Knock Out!_
class KnockOut: DiceGame {
    var dice: Dice = Dice(sides: 6, generator: OneThroughTen())
    
    var players: [Player] = []
    
    // This is the "tracker"
    var delegate: DiceGameDelegate?
    
    init(numberOfPlayers: Int) {
        for i in 1...numberOfPlayers {
            let aPlayer = Player(id: i)
            players.append(aPlayer)
        }
    }
    
    func play() {
        
        delegate?.diceGameDidStart(game: self)
        
        var isGameEnded = false
        
        while !isGameEnded {
            // Go trough each player
            for player in players where player.knockedOut == false {
            // Roll the dice
                let diceRollSum = dice.roll() + dice.roll()
                
                delegate?.game(game: self, didStartNewTurnWithDiceRoll: diceRollSum)
                
            // Check if we are knocked out
                if player.knockOutNumber == diceRollSum {
                   
                    player.knockedOut = true
                    
                    // Check if all of th eplayers knockedout, or if still osme players are playing
                    
                    var activePlayers: [Player] = []
                    
                    for player in activePlayers {
                        if player.knockedOut == false {
                            activePlayers.append(player)
                        }
                    }
                    
                    if activePlayers.count == 0 {
                        isGameEnded = true
                        print("All players have been knocked out!")
                        delegate?.gameDidEnd(game: self)
                        return
                    }
                // If not, add to the total score
                } else {
                    player.score += diceRollSum
                    
                    if player.score >= 100 {
                        isGameEnded = true
                        print ("Player \(player.id) has won with a final score of \(player.score)!")
                        delegate?.gameDidEnd(game: self)
                        return
                    }
                }
            }
        }
    }
    
    
}

protocol DiceGameDelegate {
   
    func diceGameDidStart(game: DiceGame)
    
    func game(game: DiceGame, didStartNewTurnWithDiceRoll roll: Int)
    
    func gameDidEnd(game: DiceGame)
    
}


class DiceGameTracker: DiceGameDelegate {
    
    var numberOfTurns = 0
    
    func diceGameDidStart(game: DiceGame) {
        numberOfTurns = 0
        
        print("Started a new game!")
    }
    
    func game(game: DiceGame, didStartNewTurnWithDiceRoll roll: Int) {
        numberOfTurns += 1
        
        print("Rolled a \(roll).")
    }
    
    func gameDidEnd(game: DiceGame) {
        print("The game lasted \(numberOfTurns) turns.")
    }

}

let myKnocOut = KnockOut(numberOfPlayers: 15)
let tracker = DiceGameTracker()

myKnocOut.delegate = tracker
myKnocOut.play()
//: The following class is used to track the status of the above game, and will conform to the `DiceGameDelegate` protocol.
// Make the protocol (DiceGameDelegate)
// Make the `var delegate` in the thing you want to delegate work from. (delegator) Example: KnockOut class
// Call the delegate.someFunction at the appropriate place
// Set the `var delegate` property to an intance of something that conforms to the delegate protocol


//: Finally, we need to test out our game. Let's create a game instance, add a tracker, and instruct the game to play.


