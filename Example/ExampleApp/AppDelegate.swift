import UIKit
import UserNotifications
import WalletConnectNetworking

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerForPushNotifications()
        
        let notificationOption = launchOptions?[.remoteNotification]

        // 1
        if
          let notification = notificationOption as? [String: AnyObject],
          let aps = notification["aps"] as? [String: AnyObject] {
          
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
          guard settings.authorizationStatus == .authorized else { return }
          DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
          }
      }
    }

    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
          .requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
            let clientId  = try! Networking.instance.getClientId()
                self?.registerClient(clientId: clientId, deviceToken: "9D11CA68-4D73-4AD7-AE9F-9A7BE7F3D4B3") { result in
                print(result)
            }
          }
    }
    
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      print("Device Token: \(token)")
        
        let clientId  = try! Networking.instance.getClientId()

        registerClient(clientId: clientId, deviceToken: token) { result in
            print(result)
        }
    }

    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      print("Failed to register: \(error)")
    }
    
    func registerClient(
        clientId: String,
        deviceToken: String,
        then handler: @escaping (Result<Data, Error>) -> Void
    ) {
        var urlSession = URLSession.shared
        // To ensure that our request is always sent, we tell
        // the system to ignore all local cache data:
        var request = URLRequest(
            url: URL(string: "https://dev.push.walletconnect.com/clients")!,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        
        let json: [String: Any] = ["client_id": clientId, "type": "APNS", "token": deviceToken]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpMethod = "POST"
request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = urlSession.dataTask(
            with: request,
            completionHandler: { data, response, error in
                // Validate response and call handler
                print("Yeay \(data), \(response), \(error)")
            }
        )

        task.resume()
    }
}
