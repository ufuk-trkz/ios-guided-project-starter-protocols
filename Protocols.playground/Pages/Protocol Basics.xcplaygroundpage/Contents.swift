import Foundation

//: # Protocols
//: Protocols are, as per Apple's definition in the _Swift Programming Language_ book:
//:
//: "... a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality. The protocol can then be adopted by a class, structure, or enumeration to provide an actual implementation of those requirements. Any type that satisfies the requirements of a protocol is said to conform to that protocol."
//:
//: The below example shows a protocol that requires conforming types have a particular property defined.
// Our app needs the user's full name.
// We can write a protocol to make sure that anything that uses the protocol has a full name.

// Any ´thing insed of this protocol becomes the requirements for anyone to follow these "rules"

protocol FullyName {
    var fullName: String { get }
    
}

struct Person: FullyName, Equatable {
    var fullName: String
    
}


struct Starship: FullyName {
    
    var prefix: String? // { get set }
    var name: String // { get set }
    
    // Computed property - The value of the fullName will be "computed" or figured out everytime you access it.
    var fullName: String {
        // USS - Prefix
        // Enterprise - Name
        if let prefix = prefix {
            return prefix + " " + name
        }
    }
    
    // Compare the left hand side of the "==" with the right hand side
    static func ==(lhs: Starship, rhs: Starship) -> Bool {
        if lhs.fullName == rhs.fullName {
            return true
        } else {
            return false
        }
    }
    
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
}

var starship = Starship(name: "Enterprise", prefix: "USS")

starship.name = "Something else"
print(starship.fullName)
//: Protocols can also require that conforming types implement certain methods.
protocol GeneratesRandomNumbers {
    // we don't give the implemention of the function in the protocol
    func random() -> Int
}

class OneThroughTen: GeneratesRandomNumbers {
    func random() -> Int {
          return Int.random(in: 1...10)
      }
}

//let array = [1, 2, 3]
//let array = array(arrayLiteral: 1, 2, 3)

let numberGenerator = OneThroughTen()
let random = numberGenerator.random()
//: Using built-in Protocols
let enterprise = Starship(name: "Enterprise", prefix: "USS")
let firefly = Starship(name: "Serenity")

if enterprise == firefly {
    print("Same Starship")
}


//: ## Protocols as Types


