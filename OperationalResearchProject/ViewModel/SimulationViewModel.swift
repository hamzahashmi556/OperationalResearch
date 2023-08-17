//
//  SimulationViewModel.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 17/08/2023.
//

import Foundation

class SimulationViewModel: ObservableObject {
    
    
    func exponentialDistribution(serviceRate: Double) -> Double {
        return -(serviceRate) * log(1 - Double.random(in: 0..<1))
    }
    
    func poissonDistribution(arrivalRate: Double) -> Int {
        let L = exp(-arrivalRate)
        var k = 0
        var p = 1.0
        
        repeat {
            k += 1
            p *= Double.random(in: 0..<1)
        } while p > L
        
        return k - 1
    }
    
    func exponentialDistribution(lambda: Double) -> Double {
        return -(log(1 - Double.random(in: 0..<1)) / (1 / lambda))
    }
    
    func uniformDistribution(min: Double, max: Double) -> Double {
        return Double.random(in: min..<max)
    }
    
    
    func normalDistribution(mean: Double, stddev: Double) -> Double {
        var u = 0.0
        var v = 0.0
        
        repeat {
            while u == 0.0 {
                u = Double.random(in: 0..<1)
            }
            
            while v == 0.0 {
                v = Double.random(in: 0..<1)
            }
            
            let standardNormal = sqrt(-2.0 * log(u)) * cos(2.0 * Double.pi * v)
            
            return mean + stddev * standardNormal
        } while true
    }
}
