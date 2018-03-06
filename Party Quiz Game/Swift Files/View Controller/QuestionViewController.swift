//
//  MainViewController.swift
//  Party Quiz Game
//
//  Created by Giovanni Frate on 12/02/18.
//  Copyright © 2018 Abusive Designers. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
  
  var i = 0
  var points = 0
  
  // - MARK: 1: Variables and Outlets declaration
  static let shared = QuestionViewController()
  @IBOutlet var buzzerView: UIView!
  @IBOutlet var progressControllerView: UIView!
  @IBOutlet var questionOutlet: UILabel!
  @IBOutlet var answerOneButton: UIButton!
  @IBOutlet var answerTwoButton: UIButton!
  @IBOutlet var answerThreeButton: UIButton!
  @IBOutlet var answerFourButton: UIButton!
  @IBOutlet var onHoldView: UIView!
  @IBOutlet var onHoldLabel: UILabel!
  @IBOutlet var onHoldWaiting: UILabel!
  @IBOutlet var displayTimeLabel: UILabel!
  
  let hapticFeedbackBuzz = UIImpactFeedbackGenerator(style: .heavy)
  let hapticFeedbackWarning = UINotificationFeedbackGenerator()
  
  
  var players = [String:Int]()        //[idSession:Score] l'host carica tutti i peers in questo dizionario con punteggio 100
  var playersTimers = [String:Int]()  //[idSession:Timer]
  
  var audioAnswerRight = Audio(fileName: "answerRight", typeName: "m4a")
  var audioAnswerWrong = Audio(fileName: "answerWrong", typeName: "m4a")
  var audioTimeUp = Audio(fileName: "timeUp", typeName: "m4a")
  var audioSignalReactive = Audio(fileName: "signalReactive", typeName: "m4a")
  
  
  var timerReceiveWinnerTimer: Timer! //SIMULATION MULTIPEER: host said to me I was the fastest to buzz
  var timerReceiveLoserTimer: Timer! //SIMULATION MULTIPEER: host said to me I was one of the slowest to buzz
  var timerReceivePlayerAnswered: Timer!  //SIMULATION MULTIPEER: other player answered
  
  let backgoundBlueOcean = UIColor(red: 67/255, green: 59/255, blue: 240/255, alpha: 1)
  let backgoundBase = UIColor(red: 67/255, green: 59/255, blue: 240/255, alpha: 1)
  let backgoundLilla = UIColor(red: 189/255, green: 16/255, blue: 224/255, alpha: 1)
  let backgroundRed = UIColor(red: 243/255, green: 75/255, blue: 75/255, alpha: 1)
  
  var indexBuzzer = 0
  var point = CGPoint()
  var pointTimer = CGPoint()
  
  var questionLocal = [String:String]()
  
  // - MARK: 2: ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    AudioSingleton.shared.fadeOutMusic()
    view.backgroundColor = backgoundBase
    setAnswersQuestion()
    //NotificationCenter.default.addObserver(self, selector: #selector(self.loadProgressView30), name: NSNotification.Name(rawValue: "loadProgressView30"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.loadProgressView10), name: NSNotification.Name(rawValue: "loadProgressView10"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.timeOut), name: NSNotification.Name(rawValue: "timeOut"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.buzzerPressed), name: NSNotification.Name(rawValue: "buzzer"), object: nil)
    
    for i in 0...CoreDataManager.shared.questionDictionary.count-1 {
      let q = CoreDataManager.shared.questionDictionary[i]
      print("Testo Domanda \(i): \(String(describing: q["text"]))")
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    syncQuestionBuzzer()  //qui è chiamata solo la prima volta
    AudioSingleton.shared.setAudioShared()
  }
  
  func initPlayer(player: String) {
    players[player] = 100
  }
  
  func syncQuestionBuzzer() {
    print("DOMANDA ATTUALE: \(QuestionViewController.shared.i)")
    
    if (QuestionViewController.shared.i < (CoreDataManager.shared.questionDictionary.count)) {
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideBuzzer"), object: nil)
      onHoldLabel.backgroundColor = UIColor.colorGreen()
      if indexBuzzer == 1 { //nel caso non è stato premuto il doppio buzzer, ripristino la posizione originale
        self.questionOutlet.center.x = self.point.x
        self.displayTimeLabel.center.x = self.pointTimer.x
      }
      
      //if "sono host"
      //preparo e invio la domanda, e il buzzer scelto casualmente
      indexBuzzer = Int(arc4random_uniform(4))  //buzzer random
      //else "sono guest"
      //attendo di ricevere la domanda e il buzzer
      
      displayTimeLabel.isHidden = false
      answersDisappear()
      
      setQuestion()
      setBuzzer()
      QuestionViewController.shared.i = QuestionViewController.shared.i + 1
    } else {
      print("domande finite")
      self.performSegue(withIdentifier: "matchEnded", sender: nil)
    }
  }
  
  //TODO: sistemazione casuale delle risposte
  func setQuestion()  {
    
    questionLocal = CoreDataManager.shared.questionDictionary[QuestionViewController.shared.i]
    
    questionOutlet.text = questionLocal["text"]
    
    answerOneButton.setTitle(questionLocal["wrongAnswer2"], for: .normal)
    answerOneButton.backgroundColor = UIColor.colorLightBlue()
    
    answerTwoButton.setTitle(questionLocal["wrongAnswer3"], for: .normal)
    answerTwoButton.backgroundColor = UIColor.colorLightBlue()
    
    answerThreeButton.setTitle(questionLocal["correctlyAnswer"], for: .normal)
    answerThreeButton.backgroundColor = UIColor.colorLightBlue()
    
    answerFourButton.setTitle(questionLocal["wrongAnswer1"], for: .normal)
    answerFourButton.backgroundColor = UIColor.colorLightBlue()
  }
  
  
  // - MARK: 3: Method that loads the progress view
  /*
   @objc func loadProgressView30() {
   buzzerTimerReset()
   buzzerTimerStart()
   if let progressView30 = Bundle.main.loadNibNamed("ProgressView", owner: self, options: nil)?.first as? ProgressView {
   progressControllerView.addSubview(progressView30)
   progressView30.manageProgress(seconds: 30)
   progressView30.frame = progressControllerView.bounds
   }
   }
   */
  @objc func loadProgressView10() {
    buzzerTimerReset()
    buzzerTimerStart()
    if let progressView10 = Bundle.main.loadNibNamed("ProgressView", owner: self, options: nil)?.first as? ProgressView {
      progressControllerView.addSubview(progressView10)
      progressView10.manageProgress(seconds: 10)
      progressView10.frame = progressControllerView.bounds
    }
  }
  
  // - MARK: 4: Method that sets buzzer
  func setBuzzer() {
    if indexBuzzer == 0 {
      if let oneBuzzer = Bundle.main.loadNibNamed("OneBuzzer", owner: self, options: nil)?.first as? OneBuzzer {
        buzzerView.addSubview(oneBuzzer)
        oneBuzzer.loadPopUp(view: view)
        oneBuzzer.setBuzzer()
        oneBuzzer.frame = buzzerView.bounds
        changeBackgroundColor(finalColor: UIColor.orange)
      }
    } else if indexBuzzer == 1 {
      NotificationCenter.default.addObserver(self, selector: #selector(self.moveQuestionBoxToOrigin), name: NSNotification.Name(rawValue: "twoBuzzersException"), object: nil)
      point.x = questionOutlet.center.x
      pointTimer.x = displayTimeLabel.center.x
      questionOutlet.center.x = view.bounds.width * 0.465
      displayTimeLabel.center.x = view.bounds.width * 0.465
      
      if let twoBuzzers = Bundle.main.loadNibNamed("TwoBuzzers", owner: self, options: nil)?.first as? TwoBuzzers {
        buzzerView.addSubview(twoBuzzers)
        twoBuzzers.loadPopUp(view: view)
        twoBuzzers.setBuzzers()
        twoBuzzers.frame = buzzerView.bounds
        changeBackgroundColor(finalColor: backgroundRed)
      }
    } else if indexBuzzer == 2 {
      if let shakeBuzzer = Bundle.main.loadNibNamed("ShakeBuzzer", owner: self, options: nil)?.first as? ShakeBuzzer {
        buzzerView.addSubview(shakeBuzzer)
        shakeBuzzer.loadPopUp()
        shakeBuzzer.setRoundedView()
        shakeBuzzer.setRoundedLabel()
        shakeBuzzer.setIndicatorView()
        shakeBuzzer.frame = buzzerView.bounds
        changeBackgroundColor(finalColor: UIColor.black)
      }
    } else {
      if let blowBuzzer = Bundle.main.loadNibNamed("BlowBuzzer", owner: self, options: nil)?.first as? BlowBuzzer {
        buzzerView.addSubview(blowBuzzer)
        blowBuzzer.loadPopUp()
        blowBuzzer.setRoundedView()
        blowBuzzer.setIndicatorView()
        blowBuzzer.frame = buzzerView.bounds
        changeBackgroundColor(finalColor: backgoundLilla)
      }
    }
  }
  
  func setAnswersQuestion() {
    questionOutlet.layer.cornerRadius = 25.0
    questionOutlet.clipsToBounds = true
    questionOutlet.layer.borderWidth = 6.0
    questionOutlet.layer.borderColor = UIColor.colorGray().cgColor
    
    answerOneButton.layer.cornerRadius = 25
    answerOneButton.layer.borderColor = UIColor.colorGray().cgColor
    answerOneButton.layer.borderWidth = 6.0
    answerOneButton.alpha = 0
    
    answerTwoButton.layer.cornerRadius = 25
    answerTwoButton.layer.borderColor = UIColor.colorGray().cgColor
    answerTwoButton.layer.borderWidth = 6.0
    answerTwoButton.alpha = 0
    
    answerThreeButton.layer.cornerRadius = 25
    answerThreeButton.layer.borderColor = UIColor.colorGray().cgColor
    answerThreeButton.layer.borderWidth = 6.0
    answerThreeButton.alpha = 0
    
    answerFourButton.layer.cornerRadius = 25
    answerFourButton.layer.borderColor = UIColor.colorGray().cgColor
    answerFourButton.layer.borderWidth = 6.0
    answerFourButton.alpha = 0
    
    onHoldLabel.layer.cornerRadius = 15.0
    onHoldLabel.clipsToBounds = true
    
    onHoldWaiting.layer.cornerRadius = 15.0
    onHoldWaiting.clipsToBounds = true
  }
  
  func rightAnswer(button: UIButton)  {
    disableAnswersInteractions()
    audioAnswerRight.player.play()
    button.backgroundColor = .green
    signalPeerSendPlayerAnswered()
    QuestionViewController.shared.points = QuestionViewController.shared.points + 10
  }
  
  func wrongAnswer(button: UIButton)  {
    disableAnswersInteractions()
    audioAnswerWrong.player.play()
    button.backgroundColor = .red
    signalPeerSendPlayerAnswered()
    QuestionViewController.shared.points = QuestionViewController.shared.points - 10
  }
  
  @IBAction func answerOneButtonAction(_ sender: UIButton) {
    buzzerTimerStop()
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopTimer"), object: nil)
    if answerOneButton.titleLabel?.text == questionLocal["correctlyAnswer"] {
      rightAnswer(button: answerOneButton)
    } else  {
      wrongAnswer(button: answerOneButton)
    }
  }
  
  @IBAction func answerTwoButtonAction(_ sender: UIButton) {
    buzzerTimerStop()
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopTimer"), object: nil)
    if answerTwoButton.titleLabel?.text == questionLocal["correctlyAnswer"] {
      rightAnswer(button: answerTwoButton)
    } else  {
      wrongAnswer(button: answerTwoButton)
    }
  }
  
  @IBAction func answerThreeButtonAction(_ sender: UIButton) {
    buzzerTimerStop()
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopTimer"), object: nil)
    if answerThreeButton.titleLabel?.text == questionLocal["correctlyAnswer"] {
      rightAnswer(button: answerThreeButton)
    } else  {
      wrongAnswer(button: answerThreeButton)
    }
  }
  
  @IBAction func answerFourButtonAction(_ sender: UIButton) {
    buzzerTimerStop()
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopTimer"), object: nil)
    if answerFourButton.titleLabel?.text == questionLocal["correctlyAnswer"] {
      rightAnswer(button: answerFourButton)
    } else  {
      wrongAnswer(button: answerFourButton)
    }
  }
  
  
  func changeBackgroundColor(finalColor: UIColor) {
    view.changeBackgroundColor(initColor: view.backgroundColor!, finalColor: finalColor)
    Singleton.shared.delayWithSeconds(1.8, completion: {
      self.view.backgroundColor = finalColor
    })
  }
  
  func peerSendQuestionBuzzer() {
    //TODO: invio domanda e buzzer da parte dell'host
    
  }
  
  func peerReceiveQuestionBuzzer() {
    //TODO: ricezione domanda e buzzer da parte del guest
    
  }
  
  /////*** MANAGING PLAYERS' TIMER BUZZER ***/////
  // - MARK: 5: Method that send timer score to host for comparison
  @objc func signalPeerSendBuzz() {
    //TODO: invio all'host del tempo di risposta
    let timerStamp = (seconds * 100) + fraction
    print("TIMER: \(timerStamp)")
    
    //SIMULATION MULTIPEER WINNER: dopo 3 secondi l'host mi dice che sono stato il più VELOCE
    //[SINGLE PLAYER] timerReceiveWinnerTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(signalPeerReceiveWinnerTimer), userInfo: nil, repeats: true)
    
    //SIMULATION MULTIPEER LOSER: dopo 3 secondi l'host mi dice che sono stato il più LENTO
    //timerReceiveLoserTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(signalPeerReceiveLoserTimer), userInfo: nil, repeats: true)
    
    /*[SINGLE PLAYER]*/signalPeerReceiveWinnerTimer()
  }
  
  // - MARK: 6: Host's method that receive timer score from players to compare
  @objc func signalPeerReceiveBuzz()  {
    //TODO: ricezione nell'host dei timer dei giocatori
    
    //ricevuti tutti i timer dei giocatori, avviso il giocatore con il timer più basso con "signalPeerSendWinnerTimer()"
    
    /*
     playersTimers[idSession] = timer
     if playersTimers.count == players.count {
     //cerca il giocatore col timer più basso
     signalPeerSendResults()
     }
     
     */
  }
  
  /////*** WARNING PLAYERS ***///
  // - MARK: 7: The host warns fastest player, and the slowers
  @objc func signalPeerSendResults()  {
    //TODO: invio segnale al giocatore più veloce per la comparsa delle risposte, mentre agli altri dico che sono stati troppo lenti...
    
  }
  
  // - MARK: 8: Method that works when I receive signal from host. He said to me that I was the fastest to buzz
  @objc func signalPeerReceiveWinnerTimer() {
    //TODO: ricezione multipeer vincitore miglior timer da host
    //hapticFeedbackWarning.notificationOccurred(.error)
    //timerReceiveWinnerTimer.invalidate()  //SIMULAZIONE MULTIPEER: disattivazione timer Winner
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "winnerTimer"), object: nil)
    
    answersAppear()
    
    onHoldView.isHidden = true
    onHoldLabel.isHidden = true
//    onHoldWaiting.isHidden = true
  }
  
  // - MARK: 9: Method that works when I receive signal from host. He said to me that I was one of the slowest players
  @objc func signalPeerReceiveLoserTimer() {
    //TODO: ricezione multipeer vincitore miglior timer da host
    timerReceiveLoserTimer.invalidate()  //SIMULAZIONE MULTIPEER
    
    onHoldLabel.text = "Too slow..."
    onHoldLabel.backgroundColor = .red
    
    timerReceivePlayerAnswered = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(signalPeerReceivePlayerAnswered), userInfo: nil, repeats: true) //SIMULATION MULTIPEER: dopo 3 secondi l'altro giocatore ha risposto alla domanda
  }
  
  
  //////*** PLAYER ANSWERED ***//////
  // - MARK: 10: Method that warns others that I answered, and let's go on
  @objc func signalPeerSendPlayerAnswered() {
    //TODO: dico a tutti che ho risposto
    Singleton.shared.delayWithSeconds(3) {
      self.enableAnswersInteraction()
      self.syncQuestionBuzzer()
    }
  }
  
  // - MARK: 11: Method that warns me that other player has answered
  @objc func signalPeerReceivePlayerAnswered() {
    timerReceivePlayerAnswered.invalidate() //SIMULATION MULTIPEER
    self.syncQuestionBuzzer()
    self.onHoldView.isHidden = true
    self.onHoldLabel.isHidden = true
    self.onHoldWaiting.isHidden = true
  }
  
  @objc func moveQuestionBoxToOrigin() {
    questionOutlet.questionBoxMoveLeft(view: view, initPosition: point)
    displayTimeLabel.questionBoxMoveLeft(view: view, initPosition: pointTimer)
    Singleton.shared.delayWithSeconds(0.4) {
      self.questionOutlet.center.x = self.point.x
      self.displayTimeLabel.center.x = self.pointTimer.x
    }
  }
  
  @objc func buzzerPressed()  {
    hapticFeedbackBuzz.impactOccurred()
    buzzerTimerStop()
    //[SINGLE PLAYER]    onHoldView.isHidden = false
    //[SINGLE PLAYER]    onHoldLabel.isHidden = false
    //[SINGLE PLAYER]    onHoldWaiting.isHidden = false
    //[SINGLE PLAYER]    displayTimeLabel.isHidden = true
    signalPeerSendBuzz()  //invio al peer
  }
  
  @objc func answersAppear() {
    self.answerOneButton.fadeIn()
    Singleton.shared.delayWithSeconds(0.2) {
      self.answerOneButton.alpha = 1
    }
    self.answerTwoButton.fadeIn()
    Singleton.shared.delayWithSeconds(0.2) {
      self.answerTwoButton.alpha = 1
    }
    self.answerThreeButton.fadeIn()
    Singleton.shared.delayWithSeconds(0.2) {
      self.answerThreeButton.alpha = 1
    }
    self.answerFourButton.fadeIn()
    Singleton.shared.delayWithSeconds(0.2) {
      self.answerFourButton.alpha = 1
    }
  }
  
  
  @objc func answersDisappear() {
    self.answerOneButton.fadeOut()
    Singleton.shared.delayWithSeconds(0.2) {
      self.answerOneButton.alpha = 0
    }
    self.answerTwoButton.fadeOut()
    Singleton.shared.delayWithSeconds(0.2) {
      self.answerTwoButton.alpha = 0
    }
    self.answerThreeButton.fadeOut()
    Singleton.shared.delayWithSeconds(0.2) {
      self.answerThreeButton.alpha = 0
    }
    self.answerFourButton.fadeOut()
    Singleton.shared.delayWithSeconds(0.2) {
      self.answerFourButton.alpha = 0
    }
  }
  
  @objc func timeOut() {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopBlowing"), object: nil)
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopShaking"), object: nil)
    
    buzzerTimerStop()
    //[SINGLE PLAYER]signalPeerSendBuzz()
    
    //SIMULATION MULTIPEER
    //[SINGLE PLAYER]timerReceiveWinnerTimer.invalidate()  //SIMULATION MULTIPEER
    //timerReceiveLoserTimer.invalidate()   //SIMULATION MULTIPEER
    
    audioTimeUp.player.play()
    onHoldLabel.text = "Time is Up!"
    onHoldLabel.backgroundColor = .red
    onHoldView.isHidden = false
    onHoldLabel.isHidden = false
//    onHoldWaiting.isHidden = false
    Singleton.shared.delayWithSeconds(3) {
      self.syncQuestionBuzzer()
      //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startTimer"), object: nil)
      self.onHoldView.isHidden = true
      self.onHoldLabel.isHidden = true
      self.onHoldWaiting.isHidden = true
      //self.onHoldLabel.text = "On Hold..."
    }
    Singleton.shared.delayWithSeconds(5) {  //TODO: forse non c'è più bisogno
      self.answerOneButton.alpha = 0
      self.answerTwoButton.alpha = 0
      self.answerThreeButton.alpha = 0
      self.answerFourButton.alpha = 0
    }
  }
  
  func disableAnswersInteractions() {
    answerOneButton.isUserInteractionEnabled = false
    answerTwoButton.isUserInteractionEnabled = false
    answerThreeButton.isUserInteractionEnabled = false
    answerFourButton.isUserInteractionEnabled = false
  }
  
  func enableAnswersInteraction() {
    answerOneButton.isUserInteractionEnabled = true
    answerTwoButton.isUserInteractionEnabled = true
    answerThreeButton.isUserInteractionEnabled = true
    answerFourButton.isUserInteractionEnabled = true
  }
  
  //TIMER ZONE
  var startTime = TimeInterval()
  
  var timer:Timer = Timer()
  var seconds: Int!
  var fraction: Int!
  
  func buzzerTimerStart() {
    if (!timer.isValid) {
      let aSelector : Selector = #selector(QuestionViewController.buzzerTimerUpdate)
      timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
      startTime = NSDate.timeIntervalSinceReferenceDate
    }
  }
  
  func buzzerTimerStop() {
    timer.invalidate()
    displayTimeLabel.isHidden = true
    onHoldLabel.text = displayTimeLabel.text
  }
  
  @objc func buzzerTimerUpdate() {
    let currentTime = NSDate.timeIntervalSinceReferenceDate
    
    //find the difference between current time and start time
    var elapsedTime: TimeInterval = currentTime - startTime
    
    //calculate the seconds in elapsed time
    seconds = Int(elapsedTime)
    elapsedTime -= TimeInterval(seconds)
    
    //find out the fraction of milliseconds to be displayed
    fraction = Int(elapsedTime * 100)
    
    //add the leading zero for minutes, seconds and millseconds and store them as string constants
    let strSeconds = String(format: "%02d", seconds)
    let strFraction = String(format: "%02d", fraction)
    
    //concatenate minuets, seconds and milliseconds as assign it to the UILabel
    displayTimeLabel.text = "\(strSeconds):\(strFraction)"
  }
  
  func buzzerTimerReset() {
    seconds = 0
    fraction = 0
  }
  
  //END OF TIMER ZONE
}
