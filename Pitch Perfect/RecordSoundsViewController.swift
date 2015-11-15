//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Rob Sutherland on 2015-11-13.
//  Copyright © 2015 Rob Sutherland. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
     var recordedAudio: RecordedAudio!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingInprogress: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func stopRecording(sender: UIButton) {
        
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

        stopRecordingButton.hidden = true;
        recordButton.enabled = true;
       
    }
    override func viewWillAppear(animated: Bool) {
        stopRecordingButton.hidden = true;
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if(flag){
            
            //create the recorder class using constructor
            recordedAudio = RecordedAudio(url: recorder.url,titleFile: recorder.url.lastPathComponent)
            
            //perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        }else{
            
            recordButton.enabled = true
            stopRecordingButton.enabled = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "stopRecording"){
            
            recordingInprogress.text = "Tap To Record"
            
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    
    @IBAction func recordAudio(sender: UIButton) {
        
        stopRecordingButton.hidden = false
        recordButton.enabled = false;
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    
        //set the name of the recording
        let recordingName = "my_audio.wav"
        
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        recordingInprogress.text = "Recording In Progress"
        
    }
}

