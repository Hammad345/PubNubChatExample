//
//  ChatViewController.swift
//  PubNubExample-iOS
//
//  Created by wasiq on 07/09/2023.
//

import UIKit
import PubNub


class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!

    var messages: [String] = []

    var pubnub: PubNub!
//    let channels = ["xyz"]
    var channels = [String]()

    let listener = SubscriptionListener(queue: .main)
    
    
    var subscribeName = String()
    var publisherName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        // Set up the text field
        messageTextField.delegate = self

        channels.append(subscribeName)
        
        keyboardObserverFunc()
        pubnubConfiguration()
        pubnubListener()
        pubnubStatusListner()
        pubnub.add(listener)

        pubnub.subscribe(to: channels, withPresence: true)
        // Do any additional setup after loading the view.
    }
    
    // Remove observers when the view is no longer needed (e.g., in deinit or when view disappears)
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func pubnubConfiguration() {
        PubNub.log.levels = [.all]
             PubNub.log.writers = [ConsoleLogWriter(), FileLogWriter()]

        let config = PubNubConfiguration(publishKey: pubNubPublishKey, subscribeKey: pubNubSubscribeKey,   userId: "1")
             pubnub = PubNub(configuration: config)
    }
    
    func pubnubStatusListner() {
        listener.didReceiveStatus = { status in
            switch status {
            case .success(let connection):
                if connection == .connected {
                    // pubnubPublishMessage()
                }
            case .failure(let error):
                print("Status Error: \(error.localizedDescription)")
            }
        }
    }
    
    func pubnubListener(){
        listener.didReceiveMessage = { message in
     //       print("[Message]: \(message)")
            if message.payload.stringOptional == "red" {
                self.view.backgroundColor = .red
                return
            }
        //    print(message.payload.stringOptional ?? "")
        //    self.messageTextView.text = message.payload.stringOptional ?? ""
            self.messages.append(message.payload.stringOptional ?? "")
            self.tableView.reloadData()
            self.view.backgroundColor = .white
        }
    }
    
    func pubnubPublishMessage(message: String) {
        self.pubnub.publish(channel: publisherName, message: message) { result in
            print(result.map { "Publish Response at \($0.timetokenDate)" })
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        if let messageText = messageTextField.text, !messageText.isEmpty {
//            let newMessage = ["text": messageText, "sender": "You"]
            messages.append(messageText)
            pubnubPublishMessage(message: messageText)
            messageTextField.text = ""
            tableView.reloadData()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
    
    // MARK: - UITextFieldDelegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let message = textField.text, !message.isEmpty {
            // Add the new message to the messages array
            messages.append(message)
            // Reload the table view to display the new message
            tableView.reloadData()
            
            // Clear the text field
            textField.text = ""
            
            // Scroll to the last message
            let lastIndexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        }
        // Dismiss the keyboard
        textField.resignFirstResponder()
        return true
    }
}

extension ChatViewController {
    func keyboardObserverFunc() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            self.view.frame.origin.y = -keyboardHeight
        }
    }
       
    @objc func keyboardWillHide(_ notification: Notification) {
        // Reset the view to its original position
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }

}
