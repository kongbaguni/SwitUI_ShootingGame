//
//  GameCanvasView.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
import SwiftUI
import GameKit


struct GameCanvasView : View {
    let isTestMode:Bool
    let level:Int
    let fps:Int
        
    let gameCenterControllerDelegate = GameCenterControllerDelegate()
    
    @State var gameOver = false
    @State var count = 0
    @State var gameManager:GameManager? = nil
    
    @State var rotationAngle:CGFloat = 0
    @State var isPause = false {
        didSet {
            if oldValue == true && isPause == false {
                count += 1
            }
        }
    }
    @State var isLoading = false
    @State var isPresentLeaderBoard = false
    @State var isAlert = false
    @State var alertMessage:Text? = nil
    
    
    var navigationTitle:Text {
        if isTestMode {
           return Text("Test Mode")
        }
        switch level {
        case 1:
            return Text("Easy")
        case 2:
            return Text("Normal")
        case 3:
            return Text("Hard")
        case 4:
            return Text("Hell")
        default:
            return Text("")
        }
    }
    
    var gameCenterLeaderboardID:String {
        switch level {
        case 1:
            return "easy"
        case 2:
            return "normal"
        case 3:
            return "hard"
        case 4:
            return "hell"
        default:
            return ""
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                if AdLoader.shared.nativeAdsCount > 0 {
                    NaticeAdClidkView(size: .init(width: UIScreen.main.bounds.width, height: 180)).frame(height: 180)
                }
                ZStack {
                    Canvas { ctx, size in
                        gameManager?.isTestMode = isTestMode
                        
                        ctx.draw(Text("\(count)"), in: .init(origin: .init(x: -100, y: -100), size: .zero))
                        gameManager?.draw(context: ctx, screenSize: size)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000 / fps)) {
                            if isPause == false {
                                count += 1
                            }
                        }
                    }
                    if isPause {
                        VStack {
                            Spacer()
                            Button {
                                isPause = false
                            } label : {
                                Text("PAUSE")
                            }
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width)
                        .background(Color.backGround3.opacity(0.8))
                    }
                }
                .background(Color.backGround2)
                .border(Color.primary, width: 2)
                .gesture(
                    DragGesture(minimumDistance: 0.0, coordinateSpace: .local)
                        .onChanged({ value in
                            NotificationCenter.default.post(name: .dragPointerChanged, object: value)
                            
                        })
                        .onEnded({ value in
                            NotificationCenter.default.post(name: .dragEnded, object: value)
                        })
                )
                
                if isTestMode {
                    HStack {
                        Button {
                            gameManager?.addUnit()
                        } label: {
                            Image(systemName: "plus.app")
                                .resizable()
                                .imageScale(.large)
                                .scaledToFit()
                                .frame(width: 50)
                        }
                        Button {
                            gameManager?.dropItem()
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                                .resizable()
                                .imageScale(.large)
                                .scaledToFit()
                                .frame(width: 50)
                        }
                        Button {
                            NotificationCenter.default.post(name: .playerPowerUp, object: nil)
                        } label: {
                            Image(systemName: "plus.diamond")
                                .resizable()
                                .imageScale(.large)
                                .scaledToFit()
                                .frame(width: 50)
                        }
                        Button {
                            NotificationCenter.default.post(name: .playerPowerDown, object: nil)
                        } label: {
                            Image(systemName: "minus.diamond")
                                .resizable()
                                .imageScale(.large)
                                .scaledToFit()
                                .frame(width: 50)
                        }
                        Button {
                            NotificationCenter.default.post(name: .playerPowerReset, object: nil)
                        } label: {
                            Image(systemName: "diamond")
                                .resizable()
                                .imageScale(.large)
                                .scaledToFit()
                                .frame(width: 50)
                        }
                    }
                }
                if gameOver && gameManager?.score.score ?? 0 > 0 {
                    Button {
                        if let score = gameManager?.score.score {
                            reportScore(score: Int(score))
                        }
                    } label: {
                        Text("Post LeaderBoard")
                    }
                }
            }
            DimActivityIndicatorView(
                isLoading: $isLoading,
                backgroundColor: .black.opacity(0.8),
                forgroundColor: .white
            )
        }
        .onAppear {
            gameManager = .init()
            gameManager?.level = level
            NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil) { [self] noti in
                DispatchQueue.main.async{
                    isPause = true
                }
            }

            NotificationCenter.default.addObserver(forName: .gameClear, object: nil, queue: nil) { [self] noti in
                DispatchQueue.main.async {
                    gameOver = true
                }
                
            }
            NotificationCenter.default.addObserver(forName: .gameOver, object: nil, queue: nil) { [self] noti in
                DispatchQueue.main.async {
                    gameOver = true
                }
                
              
            }

        }
        .onDisappear {
            gameManager?.clear()
        }
        .navigationTitle(navigationTitle)        
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                isPause.toggle()
            } label: {
                Image(systemName: isPause ? "play.fill" : "pause.fill")
            }

        }
        .alert(isPresented: $isAlert) {
            Alert(title: Text("alert"), message: alertMessage)
        }
        .sheet(isPresented: $isPresentLeaderBoard) {
            GameCenterViewController(state: .leaderboards,leaderBoardId: gameCenterLeaderboardID)
        }

    }
    
    func reportScore(score:Int) {
        isLoading = true
        GKLeaderboard.submitScore(
            score,
            context: 0,
            player: GKLocalPlayer.local,
            leaderboardIDs: [gameCenterLeaderboardID]) { error in
                
                if error == nil {
                    gameManager?.score.score = 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                        presentLeaderBoard()
                        isLoading = false
                    }
                } else {
                    isLoading = false
                }
                
            }
    }
    
    func presentLeaderBoard() {
        isPresentLeaderBoard = true
    }
}

struct GameCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        GameCanvasView(isTestMode: true,level: 1, fps: 60)
    }
}
