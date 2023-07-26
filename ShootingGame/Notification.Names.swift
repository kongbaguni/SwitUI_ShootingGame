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
    /** 게임 클리어*/
    static let gameClear = Notification.Name("gameClear_observer")
}
