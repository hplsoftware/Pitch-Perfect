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

    //instance of audio kit
    var audioPlayer: AVAudioPlayer!
    var audioPlayerEcho: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioPlayerEcho = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayerEcho.enableRate = true
        
    }
    @IBAction func stopPlayBack(sender: UIButton) {
        
         audioPlayer.stop()
        
    }

    @IBAction func playFastRecording(sender: UIButton) {
        
       PlayRecordedAudio(2.0)
        
    }
    
    @IBAction func playSlowRecording(sender: UIButton) {
        
       PlayRecordedAudio(0.5)
        
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
    func playAudioWithVariablePitch(pitch: Float){
        
        ResetPlayerForStart()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
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
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
    }

    func playAudioWithVariableEcho(delay: Double){
        
        PlayRecordedAudio(1.0)
        
        let delayEcho: NSTimeInterval = delay//0.1 = 100ms
        var playtime: NSTimeInterval
        playtime = audioPlayerEcho.deviceCurrentTime + delayEcho
        audioPlayerEcho.stop()
        audioPlayerEcho.currentTime = 0
        audioPlayerEcho.volume = 0.8;
        audioPlayerEcho.playAtTime(playtime)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func PlayRecordedAudio(num:Float){
        
        ResetPlayerForStart()
        
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = num
        audioPlayer.play();
    }
}
