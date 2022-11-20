//
//  ViewController.swift
//  Strategy
//
//  Created by 王亚威 on 2022/11/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 简单工厂模式
        let f = CashFactory.createCashAccept(type: "正常收费")
        let acceptCash = f?.acceptCash(money: 100)
        print("acceptCash-----", acceptCash!)
   
        // 策略模式
        let type = "B"
        var str = Strategy()
        switch type {
        case "A":
            str = ConcreteStrategyA()
        case "B":
            str = ConcreteStrategyB()
        case "C":
            str = ConcreteStrategyC()
        default:
            print("99")
        }
        
        let context = Context(strategy: str)
        context.contextInterface()
        
        // 简单工厂+策略
        let type1 = "满300减10"
        let context1 = StrategyContext1(type: type1)
        let result = context1.getResult(money: 600)
        print("resutt----", result)
    }

}

protocol Cashable {
    func acceptCash(money: Double) -> Double
}

class CashSuper: Cashable {
    func acceptCash(money: Double) -> Double {
        return money
    }
}

class CashNormal: CashSuper {
    override func acceptCash(money: Double) -> Double {
        return money
    }
}

class CashRebate: CashSuper {
    private var moneyRebate: Double = 1
    init(moneyRebate: Double) {
        self.moneyRebate = moneyRebate
    }
    override func acceptCash(money: Double) -> Double {
        return money * moneyRebate
    }
}

class CashResult: CashSuper {
    private var moneyCondition: Double = 0.0
    private var moneyResult: Double = 0.0
    
    init(moneyCondition: Double, moneyResult: Double) {
        self.moneyCondition = moneyCondition
        self.moneyResult = moneyResult
    }
    
    override func acceptCash(money: Double) -> Double {
        var result = money
        if money > moneyCondition {
            result = money - (money/moneyCondition) * moneyResult
        }
        return result
    }
}

// 简单工厂模式
class CashFactory {
    static func createCashAccept(type: String) -> CashSuper? {
        var cs: CashSuper?
        switch type {
        case "正常收费":
            cs = CashNormal.init()
        case "满300减10":
            cs = CashResult.init(moneyCondition: 300, moneyResult: 10)
        case "打8折":
            cs = CashRebate.init(moneyRebate: 0.8)
        default:
            print("undefined cash accept type")
        }
        return cs
    }
}

// 策略+简单工厂
class StrategyContext1 {
    private var cash: CashSuper?
    init(type: String) {
        switch type {
        case "正常收费":
            cash = CashNormal()
        case "满300减10":
            cash = CashResult.init(moneyCondition: 300, moneyResult: 10)
        case "打8折":
            cash = CashRebate.init(moneyRebate: 0.8)
        default:
            print("")
        }
    }
    
    func getResult(money: Double) -> Double {
        return cash?.acceptCash(money: money) ?? 0
    }
}

protocol Strategyable {
    func algorithmInterface()
}

/// 策略模式
class Strategy: Strategyable  {
    func algorithmInterface() {
    }
}

class ConcreteStrategyA: Strategy {
    override func algorithmInterface() {
        print("算法A的实现")
    }
}

class ConcreteStrategyB: Strategy {
    override func algorithmInterface() {
        print("算法B的实现")
    }
}

class ConcreteStrategyC: Strategy {
    override func algorithmInterface() {
        print("算法C的实现")
    }
}

class Context {
    var strategy: Strategy?
    init(strategy: Strategy) {
        self.strategy = strategy
    }
    func contextInterface() {
        self.strategy?.algorithmInterface()
    }
}
