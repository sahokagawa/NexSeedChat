//
//  ChatUser.swift
//  NexSeedChat
//
//  Created by 香川紗穂 on 2019/08/15.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

//import Foundation

struct ChatUser {
    //ユーザーに振られた固有ID
    //データベースでいうドキュメントIDみたいな
    let uid: String
    //名前　googleアカウント名
    let name: String
    //プロフィールURL  googleアカウントの写真
    let photoUrl: String
}
