//
//  ChatViewController.swift
//  NexSeedChat
//
//  Created by 香川紗穂 on 2019/08/15.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    //全メッセージを保持する変数
    var messages: [Message] = [] {
        //変数の中身が書き換わった時
        didSet {
            //画面を更新
           messagesCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //おまじない
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        messageInputBar.delegate = self
        
        
        //検知するやつ
        //Firestoreへ接続
        let db = Firestore.firestore()
        //messagesコレクションを監視する
        db.collection("messages").order(by: "sentDate", descending: true).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                return
            }
            
            var messages: [Message] = []

            for document in documents {
                
                let uid = document.get("uid") as! String
                let name = document.get("name") as! String
                let photoUrl = document.get("photoUrl") as! String
                let text = document.get("text") as! String
                let sentDate = document.get("sentDate") as! Timestamp

                //インスタンス化　　　送信者作成
                let chatUser = ChatUser(uid: uid, name: name, photoUrl: photoUrl)
                //インスタンス化
              let message = Message(user: chatUser, text: text, messageId: document.documentID, sentDate: sentDate.dateValue())
                
                
                messages.append(message)
             
            }

            self.messages = messages

    
        }
    }
}

extension ChatViewController: MessagesDataSource {
    //送信者、ログインユーザー
    func currentSender() -> SenderType {
        let user = Auth.auth().currentUser!
        //ログイン中のユーザーのユーザーID,ディスプレイネームを使ってMessagekitように送信者の情報を作成
        return Sender(id: user.uid, displayName: user.displayName!)
    }
    //画面に表示するメッセージのこと
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
        //テーブルの時はrow、メッセージキットの時はsection
    }
    //画面に表示するメッセージの件数
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}


//今はやらんけど、拡張したらライン見たいなのできる
extension ChatViewController: MessagesLayoutDelegate {
    
}


extension ChatViewController: MessagesDisplayDelegate {
    //尻尾
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner!
        
        if isFromCurrentSender(message: message){
            //メッセージの送信者が自分の場合
            corner = .bottomRight
        }else{
            //メッセージの送信者が自分以外の場合
            corner = .bottomLeft
        }
        return .bubbleTail(corner, .curved)
    }
   
    //背景
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        if isFromCurrentSender(message: message) {
            return UIColor(red: 230/255, green: 14/255, blue: 111/255, alpha: 0.8)
        }else{
            return .yellow
        }
    }
    
  //アバター
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        //全メッセージのうち対象の一つを取得
        let message = messages[indexPath.section]
        //取得したメッセージの送信者を取得
        let user = message.user
        
        let url = URL(string: user.photoUrl)
        
        do {
            //URL渡すから画像撮ってきてー！
            let data = try Data(contentsOf: url!)
            //取得したデータをもとにImageView作成
            let image = UIImage(data: data)
            //ImageViewと名前をもとにアバターアイコン作成
            let avatar = Avatar(image: image, initials: user.name)
            
            //アバターアイコンをb画面に設置
            avatarView.set(avatar: avatar)
            return
        }catch let err{
            print(err.localizedDescription)
        }
    }
    
}


//メッセージの感覚を開けることができたりする
extension ChatViewController: MessageCellDelegate {
    
}

//ここは今から実装
//送信バーに関うする設定

extension ChatViewController: InputBarAccessoryViewDelegate {
    //didPressSendで予測変換
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        //ログインユーザーの取得
        let user = Auth.auth().currentUser!
        //Firebaseに接続
        let db = Firestore.firestore()
        //Firestoreにメッセージや送信者の情報を登録
        db.collection("messages").addDocument(data: [
            "uid": user.uid,
            "name": user.displayName as Any,
            "photoUrl": user.photoURL?.absoluteString as Any,
            "text": text,
            "sentDate":Date()
            ])
    //メッセージの入力欄をからにする
        inputBar.inputTextView.text = ""
    }
 }

