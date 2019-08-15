//
//  Message.swift
//  NexSeedChat
//
//  Created by 香川紗穂 on 2019/08/15.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

//import Foundation
import  MessageKit

struct Message: MessageType {
   
    
    //送信者
    let user: ChatUser
    
    //本文
    let text: String
    
    //メッセージごとに振られたID
    let messageId: String
    
    //送信日時
    let sentDate: Date
    //ここまで書いたら　　MessageType継承追加　　そしたらfixで必要なのが出てくる
    //コピーして、かぶるものは決して残りは下にあ貼り付けた
    //MessageKid特有の書き方　　そんなに説明なかった
    
    var sender: SenderType {
        return Sender(id: user.uid, displayName: user.name)
    }
    
    var kind: MessageKind {
        return .text(text)
        //MessageKind の中の色々ある種類の一つtext の中の変数で決めた本文text
        //MessageKind.text(text)の省略　　MessageKindっていうのは分かり切ってる
        
        //returnでMessageKindを返すのは分かり切ってる
    }
}
