//
//  ViewController.swift
//  CowBull Game
//
//  Created by Shubham Lekhak on 10/02/2023.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var randomNumberPreviousTries: UITextView!
    @IBOutlet var bullCowText: UILabel!
    @IBOutlet weak var guessedNumber: UITextField!
    var randomNumber: String = ""
    var randomPreviousTries: [String] = []
    var startButtonCountTaps = 0
    var checkButtonCountTaps = 0
    var randomTries = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        bullCowText.text = "Press Start Game to get random number"

        guessedNumber.delegate = self
        randomNumberPreviousTries.delegate = self
        if ((guessedNumber.text?.isEmpty) != nil){
            checkButton.isEnabled = false
        }
        
        guessedNumber.attributedPlaceholder = NSAttributedString(
            string: "Enter Your Guess.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
    }
  
    @IBAction func startGamePressed(_ sender: UIButton) {
        
        checkButton.isEnabled = true
        resetButton.isEnabled = true
        guessedNumber.isEnabled = true

        startButtonCountTaps += 1
        if startButtonCountTaps == 1 {
            
            randomNumber  = randomOf4Items()
            bullCowText.text = "Enter your guessed number and check"

        }
    }
   
    
    @IBAction func checkNumber(_ sender: UIButton) {
        
        if guessedNumber.text!.count == 4 {
            checkButtonCountTaps += 1

            if checkButtonCountTaps == 20 {
                bullCowText.text = "Secret Number is \(randomNumber)"
                let ac = UIAlertController(title: "You Lose", message: "Secret Number is \(randomNumber)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .destructive))
                present(ac, animated: true)
                guessedNumber.isEnabled = false
                startGameButton.isEnabled = false
                checkButton.isEnabled = false
                
            }
            if checkButtonCountTaps <= 20 {
                cowBullCheck()
            }
        }
        guessedNumber.text = ""
    }
  
    func cowBullCheck() {
        var numberOfCows: Int = 0
        var numberOfBulls: Int = 0

        let guessedText = guessedNumber.text ?? ""
        
        for (index, literal) in guessedText.enumerated() {
            if randomNumber.contains(literal) {
                numberOfCows += 1
            }
            
            let intValueOfLiteral = literal.wholeNumberValue ?? 0
            let numberAtindexFromRandomNumber = (getArrayOfNumbers(fromNumber: randomNumber))[index]
            
            if intValueOfLiteral == numberAtindexFromRandomNumber {
                numberOfBulls += 1
            }
        }
        numberOfCows = numberOfCows - numberOfBulls
        
        if numberOfBulls == 4 {
            finalScore()
        }
        
        print("The original number is \(randomNumber) and the guessed number is \(guessedText)")
        
        randomPreviousTries.append(("\(randomTries + 1): ") + guessedText + ("       \(numberOfCows)🐄  \(numberOfBulls)🐂"))
        randomNumberPreviousTries.text = (randomPreviousTries.joined(separator: "\n"))
        
        let range = NSRange(location: randomNumberPreviousTries.text.count - 1, length: 0)
        randomNumberPreviousTries.scrollRangeToVisible(range)
        randomTries += 1

    }
    
    func randomOf4Items() -> String {
        let stringOfNumbers = "0123456789"
        let arrayOfNumbers = Array(stringOfNumbers).shuffled()[1...4]
        let returnString = arrayOfNumbers
        print(returnString)
        return String(returnString)
    }
    
    func getArrayOfNumbers(fromNumber: String) -> [Int] {
        
        var arrayToBeReturned: [Int] = []
        var reducedNumber: Int = Int(fromNumber) ?? 0
        
        for (_, _) in fromNumber.enumerated() {
            
            let remainder = reducedNumber % 10
            arrayToBeReturned.append(remainder)
            reducedNumber = (reducedNumber - remainder)/10
        }
        return arrayToBeReturned.reversed()
    }
    
    func finalScore() {
        
        let ac = UIAlertController(title: "You Win", message: "Secret Number is \(randomNumber)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        bullCowText.text = "Secret Number is \(randomNumber)"
        checkButton.isEnabled = false
        startGameButton.isEnabled = false
        guessedNumber.isEnabled = false
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "Reseting", message: "Secret Number was \(randomNumber)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .destructive))
        
        present(ac, animated: true)
        startButtonCountTaps = 0
        checkButtonCountTaps = 0
        randomPreviousTries = []
        randomNumber = ""
        randomNumberPreviousTries.text = "Random Guess History"
        guessedNumber.text = ""
        randomTries = 0
        bullCowText.text = "Press Start Game to get random number"
        startGameButton.isEnabled = true
        guessedNumber.isEnabled = false
        checkButton.isEnabled = false
        resetButton.isEnabled = false
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 4
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        return newString.count <= maxLength
        
    }
}

