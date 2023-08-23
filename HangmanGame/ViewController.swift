//
//  ViewController.swift
//  HangmanGame
//
//  Created by Harsh Bhatt on 2023-02-06.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var seventhLetter: UILabel!
    @IBOutlet weak var sixthLetter: UILabel!
    @IBOutlet weak var fifthLetter: UILabel!
    @IBOutlet weak var fourthLetter: UILabel!
    @IBOutlet weak var thirdLetter: UILabel!
    @IBOutlet weak var secondLetter: UILabel!
    @IBOutlet weak var firstLetter: UILabel!
    @IBOutlet weak var lblWinCount: UILabel!
    @IBOutlet weak var lblLosseCount: UILabel!
    
    private var generatedWord = ""
    private var hangman = 1
    private var imagename = "hangman"
    private var finalWordString = 0
    private var listOfPressedChar = [String]()
    private var winCount = 0
    private var lossCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hangmanImage.image = UIImage(named: "\(imagename)\(hangman)");
        generatedWord =  fetchData()
    }
    
    //disable auto-rotate
    override var shouldAutorotate: Bool {
        return false
    }

    //only allow portrait mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    //only allow portrait mode
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hangmanImage.image = UIImage(named: "\(imagename)\(hangman)");
        generatedWord =  fetchData()
    }

    private func fetchData() -> String {
        var wordStrings = [String]()
        var random = "";
        
        if let fileURL = Bundle.main.url(forResource: constVal.wordsURL.fileName, withExtension: constVal.wordsURL.fileExtension){
            if let wordContents = try? String(contentsOf: fileURL) {
                var lines = wordContents.components(separatedBy: "\n")
                
                lines.shuffle()
                wordStrings += lines
                let randomElement = wordStrings.randomElement()!
                random = randomElement.uppercased()
            }
        } else {
            fatalError("No words found!")
        }
        return String(random);
    }
    
    @IBAction func keyTapped(_ sender: UIButton) {
        
        let pressedChar = sender.titleLabel?.text ?? ""
        
        listOfPressedChar.append(pressedChar)
        
        //if one of the correct characters it tapped
        if generatedWord.contains(pressedChar){
            
            //disabled the user interaction once tapped
            sender.isUserInteractionEnabled = false
            //changed the button color to green
            sender.configuration?.baseBackgroundColor = UIColor.systemGreen
            
            //converting word into the character Array
            let characters = Array(generatedWord)
            print(characters)
            
            let oneChar: Character = Character (pressedChar)
            
            //finding the index of pressed character in the word
            let indexArray = characters.enumerated().compactMap {
            //increased the index by +1 (offset+1) because index starts from 0
               $0.element == oneChar ? $0.offset+1 : nil
            }
            
            //assigning the character in it's label based on Index
            for index in indexArray {
                print(index)
                switch index {
                case 1:
                    firstLetter.text = pressedChar
                    finalWordString+=1;
                case 2:
                    secondLetter.text = pressedChar
                    finalWordString+=1;
                case 3:
                    thirdLetter.text = pressedChar
                    finalWordString+=1;
                case 4:
                    fourthLetter.text = pressedChar
                    finalWordString+=1;
                case 5:
                    fifthLetter.text = pressedChar
                    finalWordString+=1;
                case 6:
                    sixthLetter.text = pressedChar
                    finalWordString+=1;
                default:
                    seventhLetter.text = pressedChar
                    finalWordString+=1;
                }
            }
            
            if finalWordString == 7 {
                winlossCount(countSub: "W")

                //called Alert Function
                createAlert(title: "Phew!", message: "You saved me!\nWould you like to play again?")
            }
        } else {
            //when in-correct character it tapped
            
            hangman+=1;
            //disabled the user interaction once tapped
            sender.isUserInteractionEnabled = false
            //changed the button color to red
            sender.configuration?.baseBackgroundColor = UIColor.systemRed
            
            hangmanImage.image = UIImage(named: "\(imagename)\(hangman)");
            
            if(hangman == 7){
                winlossCount(countSub: "L")
                
                //called Alert Function
                createAlert(title: "Game Over", message: "Correct word was "+generatedWord+"\nWould you like to play again?")
            }
        }
    }
    
    //reusable alert function
    private func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(yesAction())
        alert.addAction(noAction())
        self.present(alert, animated: true, completion: nil)
    }
    
    //yes action
    private func yesAction() -> UIAlertAction{
        return UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                self.clearBackground()
            })
    }
    
    //no action
    private func noAction() -> UIAlertAction{
        return UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
                self.view.isUserInteractionEnabled = false
            })
    }
    
    //win loss count function
    private func winlossCount(countSub:Character){
        if(countSub == "W") {
            if var intText = Int(lblWinCount.text!) {
                intText += 1
                winCount = intText
                lblWinCount.text = String(intText)
             }
        } else {
            if var intText = Int(lblLosseCount.text!) {
                intText += 1
                lossCount = intText
                lblLosseCount.text = String(intText)
             }
        }
    }
    
    //function to reset the view
    private func clearBackground(){
            loadView()
        
            hangman = 1;
            hangmanImage.image = UIImage(named: "\(imagename)\(hangman)");
            generatedWord =  fetchData()
            finalWordString = 0
            listOfPressedChar = [String]()
            lblWinCount.text = String(winCount)
            lblLosseCount.text = String(lossCount)
    }
}

