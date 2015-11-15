//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Rob Sutherland on 2015-11-13.
//  Copyright © 2015 Rob Sutherland. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    //declare needed class objects
    private var audioPlayer: AVAudioPlayer!
    private var audioPlayerEcho: AVAudioPlayer!
    private var audioPlayerNode: AVAudioPlayerNode!
    internal var receivedAudio: RecordedAudio!
    private var audioEngine: AVAudioEngine!
    private var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //instantiate the engine and player objects
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioPlayerEcho = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayerEcho.enableRate = true
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
    }
    
    @IBAction func stopPlayBack(sender: UIButton) {
        
         audioPlayer.stop()
         audioPlayerNode.stop()
        audioPlayerEcho.stop()
    }

    @IBAction func playFastRecording(sender: UIButton) {
        
       PlayRecordedAudio(2.0,avp: audioPlayer)
        
    }
    
    @IBAction func playSlowRecording(sender: UIButton) {
        
        PlayRecordedAudio(0.5,avp: audioPlayer)
        
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        
        ResetPlayerForStart()
        
        playAudioWithVariablePitch(1000)
    }
    @IBAction func playVader(sender: UIButton) {
        
        ResetPlayerForStart()
        
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playReverb(sender: UIButton) {
        
        playAudioWithVariableEcho(0.5)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        ResetPlayerForStart()
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func ResetPlayerForStart(){
        
        audioPlayerNode.stop()
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
    }

    func playAudioWithVariableEcho(delay: Double){
        
        PlayRecordedAudio(1.0,avp: audioPlayer)
        
        let delayEcho: NSTimeInterval = delay//0.1 = 100ms
        var playtime: NSTimeInterval
        
        //set the start time for playing
        playtime = audioPlayerEcho.deviceCurrentTime + delayEcho
        
        audioPlayerEcho.stop()
        audioPlayerEcho.currentTime = 0
        audioPlayerEcho.volume = 0.8;
        audioPlayerEcho.playAtTime(playtime)
    }
    
    func PlayRecordedAudio(num:Float,avp: AVAudioPlayer){
        
        ResetPlayerForStart()
        
        avp.currentTime = 0.0
        avp.rate = num
        avp.play();
    }
}
