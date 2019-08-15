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
    
}

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
            
            ])
    }
}
