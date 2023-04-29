//
//  AppDelegate.swift
//  MovieFavorites
//
//  Created by 정재 on 2023/03/19.
//

import UIKit
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(1)
        
        // Firebase 초기화 세팅.
        FirebaseApp.configure()
        
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        // FCM 다시 사용 설정
        Messaging.messaging().isAutoInitEnabled = true
        
        // 푸시 알림 권한 설정 및 푸시 알림에 앱 등록
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        application.registerForRemoteNotifications()
        
        // device token 요청.
        UIApplication.shared.registerForRemoteNotifications()
        
        return true
    }
    
    //APN 토큰과 등록 토큰 매핑
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token: String = ""
        
//        let token111 = Messaging.messaging().fcmToken
//                print("token111:", token111!)
        
        for i in 0 ..< deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        
        print("APNS Token: \(token)")
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    //뱃지 초기화 시키는 방법 IOS 13 이하
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0;
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    //앱 종료 될 때 실행되는 메소드
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.set(true, forKey: "Conditions")
        UserDefaults.standard.set(true, forKey: "Order")
    }


}


extension AppDelegate: MessagingDelegate {
    
    
    //현재 등록 토큰 가져오기.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

        // TODO: - 디바이스 토큰을 보내는 서버통신 구현

//        sendDeviceTokenWithAPI(fcmToken: fcmToken ?? "")
    }
    
    
}
