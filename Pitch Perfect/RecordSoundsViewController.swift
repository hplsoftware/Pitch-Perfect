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

    //declare the needed classes
    private var audioRecorder: AVAudioRecorder!
    private var recordedAudio: RecordedAudio!
    
    //give an outlet for labels and buttons for code access
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
        
        //stop the recording
        audioRecorder.stop()
        
        //set the recording session to inactive
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

        //ui updates
        setRecordUIState(true)
    }
    override func viewWillAppear(animated: Bool) {
        stopRecordingButton.hidden = true;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //prepare needed data transfer before we move to the next screen
        if(segue.identifier == "stopRecording"){
            
            //change the progress lable for our return
            setRecordingLabelText("Tap To Record")
            
            //set the destination controller
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            //grab the data to send
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        
        //ui changes
        setRecordUIState(false)
        
        //set the directory to store recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    
        //set the name of the recording so it overwrites every time
        let recordingName = "my_audio.wav"
        
        //set complete path to NSURL
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //setup recording session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        //setup audio recorder instance
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        
        //start recording
        audioRecorder.record()
        
        //UI updates
        setRecordingLabelText("Recording In Progress")
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        //check the flag to see if recording is finished
        if(flag){
            
            //create the recorder class using constructor
            recordedAudio = RecordedAudio(url: recorder.url,titleFile: recorder.url.lastPathComponent)
            
            //perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            
            setRecordUIState(true)
        }
    }
    
    func setRecordUIState(state: Bool){
        
        stopRecordingButton.hidden = state;
        recordButton.enabled = state;
    }
    
    func setRecordingLabelText(textToShow: String){
        
         recordingInprogress.text = textToShow
    }
}

