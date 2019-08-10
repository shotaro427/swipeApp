//
//  ViewController.swift
//  CardSwipApp
//
//  Created by 田内　翔太郎 on 2019/08/10.
//  Copyright © 2019 田内　翔太郎. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // storyboardの部品
    // いいねとよくないねの画像
    @IBOutlet weak var likeImage: UIImageView!
    // ベースカード
    @IBOutlet weak var baseCard: UIView!
    // viewの紐付け
    @IBOutlet weak var person1: UIView!
    
    @IBOutlet weak var person2: UIView!
    
    @IBOutlet weak var person3: UIView!
    
    @IBOutlet weak var person4: UIView!
    
    @IBOutlet weak var person5: UIView!
    
    // 自作変数
    // ベースカードの中心座標
    var centerOfCard: CGPoint!
    // person1~person5を入れる
    // ユーザーカードの配列
    var personList: [UIView] = []
    // 選択されたカードの数を数える変数
    var selectedCardCount: Int = 0 // スワイプされたカードの枚数、画面遷移時に用いる
    // ユーザーの名前の配列
    let nameList: [String] = ["津田梅子","ジョージワシントン","ガリレオガリレイ","板垣退助","ジョン万次郎"]
    // 「いいね」された名前の配列
    var likeName: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // personListにperson1から5を追加
        personList.append(person1)
        personList.append(person2)
        personList.append(person3)
        personList.append(person4)
        personList.append(person5)
        
    }
    
    // ユーザーカード(5枚全てのview)の位置と角度を戻す処理
    func resetPersonList() {
        // 5人の飛んで行ったviewを元の位置に戻す
        for person in personList {
            // 元に戻す
            // 位置を元に戻す
            person.center = centerOfCard
            // 角度を元に戻す
            person.transform = .identity
        }
    }
    
    // 遷移させる前に情報の受け渡しをするための処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 対象のsegueを指定
        if segue.identifier == "ToLikedList" {
            // 遷移先のviewControllerを取得
            let vc = segue.destination as! LikedListTableViewController
            // LikedListTableViewControllerのlikedName(左)にViewCountrollewのLikedName(右)を代入
            vc.likedName = likeName
        }
    }
    
    // ベースカードを元に戻す処理
    func resetCard() {
        baseCard.center = centerOfCard
        baseCard.transform = .identity
    }
    
    // 右に大きくスワイプした時の処理
    func swipeRight() {
        // 右に大きくスワイプした時の処理
        UIView.animate(withDuration: 0.5, animations: {
            // x座標を右に500飛ばす(+500)
            self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x + 500, y :self.personList[self.selectedCardCount].center.y)
            // ベースカードの位置と角度を元に戻す
            self.resetCard()
        })
        // likeImageを隠す
        likeImage.isHidden = true
        // 「いいね」されたリストへの追加
        likeName.append(nameList[selectedCardCount])
        // 次のカードへ
        selectedCardCount += 1
        // 画面遷移
        if selectedCardCount >= personList.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
    }
    
    // 左に大きすスワイプした時の処理
    func swipeLeft() {
        // 左に大きくスワイプした時の処理
        UIView.animate(withDuration: 0.5, animations: {
            // x座標を左に500飛ばす(-500)
            self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x - 500, y :self.personList[self.selectedCardCount].center.y)
            // ベースカードの位置と角度を元に戻す
            self.resetCard()
        })
        // likeImageを隠す
        likeImage.isHidden = true
        // 次のカードへ
        selectedCardCount += 1
        // 画面遷移
        if selectedCardCount >= personList.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
    }
    
    // スワイプ動作時の処理
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        // IBActionのsenderにはアクションが起きたUI要素のオブジェクトが入る
        // スワイプで動くviewを格納()PanGestureRecognizerで動くview(ベースカード)を取得する）
        let card = sender.view!
        // スワイプでどれくらい動いたか(大元のviewからPanGestureRecognizerがどれだけ動いたかをCGPoint型で返す)
        let point = sender.translation(in: view) // ここのviewは大元のview
        // スワイプで動いた距離をベースカードの中心座標に足す→point分動く
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        // ユーザーカードも同様に中心座標をpoint分動かす(ベースカードと同じ動きをさせる)
        personList[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        // 移動後のカードのx座標と真ん中からの距離
        let xfromCenter = card.center.x - view.center.x
        // カードに角度をつけるための処理
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        personList[selectedCardCount].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        
        // likeImageの表示制御
        if xfromCenter > 0 {
            // goodを表示
            likeImage.image = #imageLiteral(resourceName: "いいね")
            // likeImageを表示させる
            likeImage.isHidden = false
        } else if xfromCenter < 0 {
            // badを表示
            likeImage.image = #imageLiteral(resourceName: "よくないね")
            // likeImageを表示させる
            likeImage.isHidden = false
        }
        
        // カードを元に戻す処理
        // 「指を離した」動作の確認はUIGestureRecognizer.State.endedで取得できる
        if sender.state == UIGestureRecognizer.State.ended {
            // カードを画面外に飛ばす処理
            // 画面端50より小さい場合はカードを画面外に飛ばし、大きい場合は元の位置に戻す
            // 離した時点のカードの中心の位置が左から50以内のとき
            if card.center.x < 50 {
                // 左に大きくスワイプした時の処理
                swipeLeft()
            } else if card.center.x > self.view.frame.width - 50 { // self.view.frame.widthでビューの横幅を取得できる
                // 右に大きくスワイプした時の処理
                swipeRight()
            } else {
                // スワイプが小さかった場合の処理
                // クロージャーによるアニメーションの追加
                // クロージャー内ではViewControllerのぽプロパティにアクセスするにはselfを頭につける必要がある
                UIView.animate(withDuration: 0.5, animations: {
                    // ユーザーカードを元に戻す
                    self.personList[self.selectedCardCount].center = self.centerOfCard
                    // ユーザーカードの角度を元に戻す
                    self.personList[self.selectedCardCount].transform = .identity
                    // ベースカードの位置と角度を元に戻す
                    self.resetCard()
                })
                // likeImageを隠す
                likeImage.isHidden = true
            }
        }
    }
    
    // ハートボタン
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        // 右にスワイプさせた時と同等の処理の実行
        swipeRight()
        return
    }
    
    // バツボタン
    @IBAction func dislikeButtonTapped(_ sender: Any) {
        // 左にスワイプさせた時と同等の処理の実行
        swipeLeft()
        return
    }
    
    // viewのレイアウト処理が完了した時に呼ばれる
    override func viewDidLayoutSubviews() {
        // ベースカードの中心を代入
        centerOfCard = baseCard.center
    }
    
    // 完全に遷移が完了し、スクリーン上からViewControllerが表示されなくなった時に呼ばれる
    override func viewDidDisappear(_ animated: Bool) {
        // ユーザーカードを元に戻す
        resetPersonList()
        // カウントの初期化
        selectedCardCount = 0
        // リストの初期化
        likeName = []
    }
}

