//
//  ViewController.swift
//  PubNubExample-iOS
//
//  Created by wasiq on 07/09/2023.
//

import UIKit
import PubNub

class ViewController: UIViewController {
    
//    var pubnub: PubNub!
//    let channels = ["xyz"]
//    let listener = SubscriptionListener(queue: .main)
    
    @IBOutlet weak var subscribeNameTF: UITextField!
    @IBOutlet weak var publisherNameTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        pubnubListener()
//        pubnubStatusListner()
//        pubnub.add(listener)
//        pubnub.subscribe(to: channels, withPresence: true)
    }
//
//    
//    func pubnubStatusListner() {
//        listener.didReceiveStatus = { status in
//            switch status {
//            case .success(let connection):
//                if connection == .connected {
//                    // pubnubPublishMessage()
//                }
//            case .failure(let error):
//                print("Status Error: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    func pubnubListener(){
//        listener.didReceiveMessage = { message in
//     //       print("[Message]: \(message)")
//            if message.payload.stringOptional == "red" {
//                self.view.backgroundColor = .red
//                return
//            }
//        //    print(message.payload.stringOptional ?? "")
//        //    self.messageTextView.text = message.payload.stringOptional ?? ""
//            self.view.backgroundColor = .white
//        }
//    }
//    
//    func pubnubPublishMessage() {
//        self.pubnub.publish(channel: self.channels[0], message: "Hello testing pubnub message") { result in
//            print(result.map { "Publish Response at \($0.timetokenDate)" })
//        }
//    }
//    
    //ChatViewController
    
    @IBAction func startChatBtn(_ sender: Any) {
        //           let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace with your storyboard name
        //           if let destinationVC = storyboard.instantiateViewController(withIdentifier: "ViewControllerBIdentifier") as? ViewControllerB {
        //               destinationVC.dataToPass = "Hello from ViewControllerA"
        //               navigationController?.pushViewController(destinationVC, animated: true)
        //           }
        if publisherNameTF.text?.count == 0 || subscribeNameTF.text?.count == 0 {
            return
        }
        performSegue(withIdentifier: "ChatViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatViewController" {
            if let chatVC = segue.destination as? ChatViewController {
                chatVC.publisherName = publisherNameTF.text!
                chatVC.subscribeName = subscribeNameTF.text!
                
            }
        }
    }
       
}

