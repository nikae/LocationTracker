import UIKit

class polyLineColor: ViewController {
    enum Collors {
        case red, red1, orange, orange1, yellow, yellow1, grin
        
    }
    
    func color(color: Collors) -> UIColor {
        switch color {
        case .red:
            return UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.9)
        case .red1 :
            return UIColor(red: 255/255.0, green: 50/255.0, blue: 0/255.0, alpha: 0.9)
        case .orange :
            return UIColor(red: 255/255.0, green: 69/255.0, blue: 0/255.0, alpha: 0.9)
        case .orange1 :
            return UIColor(red: 255/255.0, green: 140/255.0, blue: 0/255.0, alpha: 0.9)
        case .yellow :
            return UIColor(red: 255/255.0, green: 210/255.0, blue: 0/255.0, alpha: 0.9)
        case .yellow1 :
            return UIColor(red: 189/255.0, green: 222/255.0, blue: 0/255.0, alpha: 0.9)
        case .grin :
            return UIColor(red: 61/255.0, green: 229/255.0, blue: 0/255.0, alpha: 0.9)
        }
        
        
    }
    
    
    // Figouring Out speed and polyLine colors
    init(color1: Collors) {
        
    let red = color(color: .red)
    let red1 = color(color: .red1)
    let orange = color(color: .orange)
    let orange1 = color(color: .orange1)
    let yellow = color(color: .yellow)
    let yellow1 = color(color: .yellow1)
    let grin = color(color: .grin)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
