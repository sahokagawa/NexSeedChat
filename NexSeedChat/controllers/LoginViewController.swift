//
//  LoginViewController.swift
//  NexSeedChat
//
//  Created by 香川紗穂 on 2019/08/15.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //おまじない
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self

    }
    


}

extension LoginViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //signメソッドには　、たくさん引数あるけど、その中のエラーっていう引数がある、ここがnilかどうか確認
        if let error = error {
            print("Google Sign Inでエラーが発生しました")
            print(error.localizedDescription)
            return
        }
        //ユーザーの認証情報取得
        let authentication = user.authentication
        let credential = GoogleAuthProvider.credential(withIDToken: authentication!.idToken, accessToken: authentication!.accessToken)
        
        //googleアカウントを使ってfirebaseにログイン情報を登録する
        //エンターキーで展開できる
        Auth.auth().signIn(with: credential) { (authDataResult, error) in
            if let err = error {
                print("ログイン失敗")
                print(err.localizedDescription)
            }else{
                print("ログインに成功")
                
                self.performSegue(withIdentifier: "toChat", sender: nil)
            }
        }
    }
    
    
}


//self  自分のことこの場合
//LoginViewControllerのこと
//LoginViewControllerが持ってるperformSegueを使ってね
//selfないと、あたかも自分がAuthって思っちゃうと、エラーでる
//in とかコールバック関数って呼ばれるもの　　fix出してくれる
