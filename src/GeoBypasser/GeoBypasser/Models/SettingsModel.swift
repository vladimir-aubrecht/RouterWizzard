import Foundation
import Combine

class SettingsModel: ObservableObject {
    @Published var hostname: String? {
        didSet {
            UserDefaults.standard.set(hostname, forKey: "hostname_preference")
        }
    }
    
    @Published var username: String? {
        didSet {
            UserDefaults.standard.set(username, forKey: "username_preference")
        }
    }
    
    @Published var password: String? {
        didSet {
            UserDefaults.standard.set(username, forKey: "password_preference")
        }
    }
    
    public var isSet: Bool {
        get {
            return hostname != nil && username != nil && password != nil
        }
    }
    
    init() {
        self.hostname = UserDefaults.standard.object(forKey: "hostname_preference") as? String
        self.username = UserDefaults.standard.object(forKey: "username_preference") as? String
        self.password = UserDefaults.standard.object(forKey: "password_preference") as? String
    }
}
