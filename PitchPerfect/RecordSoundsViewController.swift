//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Soheib on 2/11/2023.
//

import UIKit

import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder : AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(recordingState: .notRecording)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        
        
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        
            audioRecorder = try! AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            print("audioRecorder assigned successfully")
    }
    

    @IBAction func stopRecording(_ sender: Any) {
        configureUI(recordingState: .recording)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        print("audioSession stopped successfully")
    }
    
    
    // MARK: - Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("recording not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordAudioURL
        }
    }
    
}

extension RecordSoundsViewController{
    
    enum RecordingState {
        case recording, notRecording
    }
    
    // MARK: UI Functions
    
    func configureUI(recordingState: RecordingState){
        
        switch recordingState {
        
            case .recording:
                stopRecordingButton.isEnabled = false
                recordLabel.text = "Tap to record"
                recordButton.isEnabled = true
        
        case .notRecording:
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
            recordLabel.text = "Recording in progress"
        }
    }
    
    
}

