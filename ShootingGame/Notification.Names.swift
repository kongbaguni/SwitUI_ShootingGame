//
//  Notification.Names.swift
//  ShootingGame
//
//  Created by Changyeol Seo on 2023/07/20.
//

import Foundation
extension Notification.Name {
    /** 터치 드래그 하여 포인터 이동함 */
    static let dragPointerChanged = Notification.Name("dragPointerChanged_observer")
    /** 터치 끝남 */
    static let dragEnded = Notification.Name("dragEnded_observer")
    /** 적기 생성*/
    static let makeEnemy = Notification.Name("makeEnemy_observer")
    /** 플레이어 샷 생성*/
    static let makePlayerShot = Notification.Name("makePlayerShot_observer")
    /** 적기의 샷 생성 */
    static let makeEnemyShot = Notification.Name("makeEnemyShot_observer")
    
    /** 유닛 파괴 */
    static let unitDidDestoryed = Notification.Name("enemyDidDestoryed")
    
    /** 플레이어 위치 갱신됨*/
    static let playerLocationWatch = Notification.Name("playerLocationWatch_observer")
    
    /** 스테이지의 적이 모두 등장했다*/
    static let stageTimeUp = Notification.Name("stage_time_up_observer")
    /** 게임 오버 */
    static let gameOver = Notification.Name("gameOver_observer")
    /** 게임 클리어*/
    static let gameClear = Notification.Name("gameClear_observer")
    
    /** 플레이어 샷 타입 토글*/
    static let togglePlayerShotType = Notification.Name("togglePlayerShotType_observer")
    
    /** 플레이어 파워 업 */
    static let playerPowerUp = Notification.Name("playerPowerUp_observer")
    
    /** 플레이어 파워 초기화 */
    static let playerPowerReset = Notification.Name("playerPowerReset_observer")
    
    /** 플레이어 파워 다운*/
    static let playerPowerDown = Notification.Name("playerPowerReset_down_observer")
    
    /** 포인트업 아이템 겟 */
    static let itemGet = Notification.Name("itemGet_observer")
    
    /** 네이티브 광고 설정됨 */
    static let setNativeAd = Notification.Name("setNativeAd_observer")
    
}
