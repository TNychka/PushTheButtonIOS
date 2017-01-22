import SpriteKit

protocol GameSceneDelegate {
    func didTap() -> Int
    func getHappy() -> Int
    func getButton() -> PushButtonSprite
    func getScore() -> Int
}

class GameScene: SKScene {
    var gameSceneDelegate: GameSceneDelegate?
    let happyLabel = SKLabelNode()
    let scoreLabel = SKLabelNode()

    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
    }
    
    deinit {
        print("scene gone")
    }
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        
        happyLabel.position = CGPoint(x: 100,y: view.bounds.height - 30)
        happyLabel.fontName = "AvenirNext-Heavy"
        happyLabel.fontColor = UIColor.white
        happyLabel.horizontalAlignmentMode = .left
        weak var weakSelf = self
        if let weakSelf = weakSelf {
            happyLabel.text = "Happy: \(weakSelf.gameSceneDelegate!.getHappy())"
            addChild(weakSelf.gameSceneDelegate!.getButton())
        }
        addChild(happyLabel)
        
        scoreLabel.position = CGPoint(x: 100,y: view.bounds.height - 70)
        scoreLabel.fontName = "AvenirNext-Heavy"
        scoreLabel.fontColor = UIColor.white
        scoreLabel.horizontalAlignmentMode = .left

        if let weakSelf = weakSelf {
            scoreLabel.text = "Score: \(weakSelf.gameSceneDelegate!.getScore())"
        }
        addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        weak var weakSelf = self
        if let weakSelf = weakSelf {
            if let touch = touches.first {
                let location = touch.location(in: weakSelf)
                if (weakSelf.gameSceneDelegate!.getButton().frame.contains(location)) {
                    let clickValue = weakSelf.gameSceneDelegate!.didTap()
                    
                    let points = SKLabelNode()
                    points.fontName = "AvenirNext-Heavy"
                    points.fontColor = UIColor.white
                    points.fontSize = 72
                    points.text = "+\(clickValue)"
                    points.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
                    if let bod = points.physicsBody {
                        let x = CGFloat(Int(arc4random_uniform(1000)) - 500)
                        let y = CGFloat(Int(arc4random_uniform(500)))
                        bod.isDynamic = true
                        bod.velocity = CGVector(dx: x, dy: y)
                    }
                    let pointsAction = SKAction.sequence([
                        SKAction.wait(forDuration: 2),
                        SKAction.fadeOut(withDuration: 1),
                        SKAction.removeFromParent()
                        ])
                    points.run(SKAction.group([pointsAction]))
                    points.position = location
                    addChild(points)
                    
                    let buttonAction = SKAction.sequence([
                        SKAction.scale(to: 0.95, duration: 0.05),
                        SKAction.scale(to: 1.05, duration: 0.05),
                        SKAction.scale(to: 1.0, duration: 0.05)
                        ])
                    weakSelf.gameSceneDelegate!.getButton().run(buttonAction)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        weak var weakSelf = self
        if let weakSelf = weakSelf {
            let happy = weakSelf.gameSceneDelegate!.getHappy()
            let score = weakSelf.gameSceneDelegate!.getScore()

            happyLabel.text = "Happy: \(happy)"
            scoreLabel.text = "Score: \(score)"

        }
    }
}
