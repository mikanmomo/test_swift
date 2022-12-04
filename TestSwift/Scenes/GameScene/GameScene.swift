//
//  GameScene.swift
//  TestSwift
//
//  Created by aship on 2020/10/21.
//

import SpriteKit

class GameScene: SKScene {
    let sscale: Float = 0.5

    
    // 卵の位置（[x,y]のセットで5個所）を作る
    let eggPoint = [[200, 300],[600, 400],[300, 600],[650, 700],[250, 900]]
    
    let egg_image = ["attachment-5.jpg","attachment-6.jpg","attachment-8.jpg"]
    let chick_image = ["attachment-4.jpg","attachment-7.jpg","attachment-9.jpg"]
    
    // 卵とひよこを入れる配列を用意する（タッチしたかを調べるため）
    var egg_nodes:[SKSpriteNode] = []
    var chick_nodes:[SKSpriteNode] = []
    
    var egg_actions : [SKAction] = []
    var chick_actions : [SKAction] = []
    
    var action_flag : [Bool] = []
    
    // スコアと、スコア表示用ラベルを用意する
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed: "Verdana-bold")
    
    // 残り時間と、残り時間表示用ラベルと、タイマーを用意する
    var timeCount = 30
    
    let timeLabel  = SKLabelNode(fontNamed: "Verdana-bold")
    var myTimer = Timer()
    
    override func sceneDidLoad() {
        self.scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
        // 背景色をつける
        self.backgroundColor = SKColor(red: 0.9,
                                       green: 0.84,
                                       blue: 0.71,
                                       alpha: 1)
        // スコアを表示する
        scoreLabel.text = "SCORE:\(score)"
        scoreLabel.fontSize = 24
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: 10,
                                      y: 600)
        self.addChild(scoreLabel)
        
        for i in 0...4 {
            let randomInt = Int.random(in: 0..<3)
            
            //卵の画像
            let egg = SKSpriteNode(imageNamed: egg_image[randomInt])
            
            egg.setScale(0.5)
            egg.position = CGPoint(x: Int(Float(eggPoint[i][0]) * sscale),
                                   y: Int(Float(eggPoint[i][1]) * sscale))
            self.addChild(egg)
            
            //卵が割れてひよこが出てくる画像
            let chick = SKSpriteNode(imageNamed: chick_image[randomInt])
            
            chick.setScale(0.5)
            chick.position = CGPoint(x: Int(Float(eggPoint[i][0]) * sscale),
                                   y: Int(Float(eggPoint[i][1]) * sscale))
            self.addChild(chick)
        
            egg_nodes.append(egg)
            chick_nodes.append(chick)
        
            action_flag.append(false)
            
            // 卵を地下（-1000）に移動するアクション
            let egg_action1 = SKAction.moveTo(y: -1000,
                                          duration: 0.0)
            
            // 0〜4秒（2秒を中心として前後4秒範囲）でランダムに時間待ち
            let egg_action2 = SKAction.wait(forDuration: 2.0,
                                        withRange: 4.0)
            // 卵を穴の位置に移動するアクション
            let egg_action3 = SKAction.moveTo(y: CGFloat(Int(Float(eggPoint[i][1]))),
                                          duration: 0.0)
            // 0〜2秒（1秒を中心として前後2秒範囲）でランダムに時間待ち
            let egg_action4 = SKAction.wait(forDuration: 1.0,
                                        withRange: 2.0)
            
            let egg_action5 = SKAction.moveTo(y: -1000,
                                          duration: 0.0)
            
            // action1〜action4を順番に行う
            egg_actions.append(SKAction.sequence([egg_action1,
                                             egg_action2,
                                             egg_action3,
                                             egg_action4,
                                             egg_action5]))
            
            // ひよこを地下（-1000）に移動するアクション
            let chick_action1 = SKAction.moveTo(y: -1000,
                                          duration: 0.0)
            
            // ひよこを穴の位置に移動するアクション
            let chick_action2 = SKAction.moveTo(y: CGFloat(Int(Float(eggPoint[i][1]))),
                                          duration: 0.0)
            
            // 0〜4秒（2秒を中心として前後4秒範囲）でランダムに時間待ち
            let chick_action3 = SKAction.wait(forDuration: 2.0,
                                        withRange: 4.0)
            
            let chick_action4 = SKAction.moveTo(y: -1000,
                                          duration: 0.0)
            chick_actions.append(SKAction.sequence([chick_action1,
                                                    chick_action2,
                                                    chick_action3,
                                                    chick_action4]))
            
            egg.run(egg_action1)
            chick.run(chick_action4)
        }
        // 残り時間を表示する
        timeLabel.text = "Time:\(timeCount)"
        timeLabel.horizontalAlignmentMode = .left
        timeLabel.fontSize = 24
        timeLabel.fontColor = SKColor.black
        timeLabel.position = CGPoint(x: 240,
                                     y: 600)
        self.addChild(timeLabel)
        
        // タイマーをスタートする（1.0秒ごとにtimerUpdateを繰り返し実行）
        myTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                       target: self,
                                       selector: #selector(self.timerUpdate),
                                       userInfo: nil,
                                       repeats: true)
    }
    
    // タイマーで実行される処理（1.0秒ごとに繰り返し実行）
    @objc func timerUpdate() {
        timeCount = timeCount - 1                             // 残り秒数を 1 減らす
        timeLabel.text = "Time:\(timeCount)"    // 残り秒数を表示
        
        if timeCount < 1 {  // もし 0 になったらゲームオーバー
            // タイマーを停止させる
            myTimer.invalidate()
            
            // GameOverSceneを作り
            let scene = GameOverScene()
            scene.score = self.score
            
            // クロスフェードトランジションを適用しながらシーンを移動する
            let transition = SKTransition.crossFade(withDuration: 1.0)
            self.view?.presentScene(scene,
                                    transition: transition)
        }else{
            let randomInt = Int.random(in: 0..<5)
            if action_flag[randomInt] == false{
                // 卵を表示→ひよこ表示
                action_flag[randomInt] = true
                egg_nodes[randomInt].run(egg_actions[randomInt], 
                                         completion: {self.chick_nodes[randomInt].run(self.chick_actions[randomInt],
                                                                                      completion:{self.action_flag[randomInt] = false})})
            }
            
        }
    }
}
