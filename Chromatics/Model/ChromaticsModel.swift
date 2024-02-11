
import Foundation

struct ColorModel {
    let hex: String
    let rgb: String
    let hsl: String
    let name: String
    
    init?(data: [String: String]) {
        guard let hex = data["hex"],
              let rgb = data["rgb"],
              let hsl = data["hsl"] else {
            return nil
        }
        self.hex = hex
        self.rgb = rgb
        self.hsl = hsl
        self.name = hex
    }
}


