//
//  QueuingViewModel.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 15/08/2023.
//

import Foundation

class QueuingViewModel: ObservableObject {
    
    @Published var serverType = 0                   { didSet { if isCalculated { calculateResults() } } }
    @Published var numberOfServers = 0              { didSet { if isCalculated { calculateResults() } } }
    
    // M/M/C
    @Published var arrivalRate = ""                 { didSet { if isCalculated { calculateResults() } } }
    @Published var serviceRate = ""                 { didSet { if isCalculated { calculateResults() } } }
    
    // M/G/C
    @Published var arrivalMeanOfExpDist = ""        { didSet { if isCalculated { calculateResults() } } }
    @Published var minimumUniformDist = ""          { didSet { if isCalculated { calculateResults() } } }
    @Published var maximumUniformDist = ""          { didSet { if isCalculated { calculateResults() } } }
    
    // G/G/C
    @Published var arrivalVariacneOfExpDist = ""    { didSet { if isCalculated { calculateResults() } } }
    @Published var serviceMeanUniformDist = ""      { didSet { if isCalculated { calculateResults() } } }
    @Published var serviceVarianceUniformDist = ""  { didSet { if isCalculated { calculateResults() } } }
    
    // Good Fit Test
    @Published var bins: [Double] = []
    @Published var observedFrequencies: [Double] = []
    @Published var MLE: [Double] = []
    @Published var PMF: [Double] = []
    @Published var expectedFrequencies: [Double] = []
    @Published var chiSquareResults: [Double] = []
    
    @Published var tfBins = ""
    @Published var tfFrequencies = ""
    @Published var distributionIndex = 0
    
    @Published var errorMessage: String? = nil
    @Published var result: QueuingResults? = nil
    @Published var fitTestResult: FitTest? = nil
    
    @Published var isCalculated = false
    
    func calculateResults() {
        
        if !isValidate() {
            return
        }
        // m/m/c
        if serverType == 0 {
            self.result = self.calculateMMCResults()
        }
        // m/m/g
        else if serverType == 1 {
            self.result = self.calculateMGCResults()
        }
        // g/g/c
        else if serverType == 2{
            self.result = self.calculateGGCResults()
        }
        else if serverType == 3 {
            self.fitTestResult = self.calculateGoodFitTest()
        }
        self.errorMessage = nil
        self.isCalculated = true
    }
    
    private func calculateMMCResults() -> QueuingResults? {
        
        guard var arrivalRate = Double(self.arrivalRate) else {
            self.errorMessage = "Arrival Rate is not in Correct Format"
            self.result = nil
            return nil
        }
        
        guard var serviceRate = Double(self.serviceRate) else {
            self.errorMessage = "Service Rate is not in Correct Format"
            self.result = nil
            return nil
        }
        
        arrivalRate = 1 / arrivalRate
        serviceRate = 1 / serviceRate
        
        // P
        let utilization = arrivalRate / (Double(numberOfServers) * serviceRate)
        // L
        let avgNumCustomersSystem = utilization / (1 - utilization)
        // Lq
        var avgNumCustomersQueue: Double {
            if numberOfServers == 1 {
                return utilization * utilization / (1 - utilization)
            }
            else {
                let cFactorial = (1...numberOfServers).reduce(1, *)
                let result = (pow(utilization, Double(numberOfServers)) * utilization) / (Double(cFactorial) * pow(1 - utilization, Double(numberOfServers) + 1))
                return result
            }
        }
        // Lq
        let avgTimeInSystem = 1 / (serviceRate - arrivalRate)
        // Wq
        let avgTimeInQueue = avgNumCustomersQueue / arrivalRate
        
        return QueuingResults(utilization: utilization,
                                     avgNumCustomersSystem: avgNumCustomersSystem,
                                     avgNumCustomersQueue: avgNumCustomersQueue,
                                     avgTimeInSystem: avgTimeInSystem,
                                     avgTimeInQueue: avgTimeInQueue)
    }
    
    private func calculateMGCResults() -> QueuingResults? {
        
        /// Lambda ƛ
        guard var arrivalMeanOfExpDist = Double(self.arrivalMeanOfExpDist) else {
            self.errorMessage = "Arrival Mean of Exponential Distribution is not in Correct Format"
            return nil
        }
        
        guard let minimumUniformDist = Double(self.minimumUniformDist) else {
            self.errorMessage = "Minimum Uniform Distribution is not in Correct Format"
            return nil
        }
        
        guard let maximumUniformDist = Double(self.maximumUniformDist) else {
            self.errorMessage = "Maximum Uniform Distribution is not in Correct Format"
            return nil
        }
        
        arrivalMeanOfExpDist = 1 / arrivalMeanOfExpDist
        
        let newMiu = 1 / ((maximumUniformDist + minimumUniformDist) / 2)
        let varianceOfServiceTime = pow(maximumUniformDist - minimumUniformDist, 2) / 12
        
        // P
        let utilization = arrivalMeanOfExpDist / (Double(numberOfServers) * newMiu)
        
        // Q
        let avgNumCustomersQueue = (pow(arrivalMeanOfExpDist, 2) * pow(varianceOfServiceTime, 2) + pow(utilization, 2)) / (2 * (1 - utilization))
        // L
        let avgNumCustomersSystem = (avgNumCustomersQueue / arrivalMeanOfExpDist + 1 / newMiu) * arrivalMeanOfExpDist
        // W
        let avgTimeInSystem = avgNumCustomersQueue / arrivalMeanOfExpDist + 1 / newMiu
        // Wq
        let avgTimeInQueue = avgNumCustomersQueue / arrivalMeanOfExpDist
        
        return QueuingResults(utilization: utilization,
                              avgNumCustomersSystem: avgNumCustomersSystem,
                              avgNumCustomersQueue: avgNumCustomersQueue,
                              avgTimeInSystem: avgTimeInSystem,
                              avgTimeInQueue: avgTimeInQueue)
    }
    
    private func calculateGGCResults() -> QueuingResults? {
        
        guard var arrivalMeanOfExpDist = Double(self.arrivalMeanOfExpDist) else {
            self.errorMessage = "Arrival Mean of Exponential Distribution is not in Correct Format"
            return nil
        }
        
        guard let arrivalVariacneOfExpDist = Double(self.arrivalVariacneOfExpDist) else {
            self.errorMessage = "Arrival Variance of Exponential Distribution is not in Correct Format"
            return nil
        }
        
        guard var serviceMean = Double(serviceMeanUniformDist) else {
            self.errorMessage = "Service Mean of Uniform Distribution is not in Correct Format"
            return nil
        }
        
        guard let serviceVariance = Double(self.serviceVarianceUniformDist) else {
            self.errorMessage = "Service Variance of Uniform Distribution is not in Correct Format"
            return nil
        }
        
        arrivalMeanOfExpDist = 1 / arrivalMeanOfExpDist
        
        serviceMean = 1 / serviceMean
        
        let ca = arrivalVariacneOfExpDist / pow(1 / arrivalMeanOfExpDist, 2)
        let cs = serviceVariance / pow(1 / serviceMean, 2)
        
        let ro = arrivalMeanOfExpDist / (Double(numberOfServers) * serviceMean)
        
        let lqueue = (pow(ro, 2) * (1 + cs) * (ca + pow(ro, 2) * cs)) / (2 * (1 - ro) * (1 + pow(ro, 2) * cs))
        
        let utilization = ro
        let avgNumCustomersQueue = lqueue
        let avgTimeInQueue = lqueue / arrivalMeanOfExpDist
        let avgTimeInSystem = lqueue / arrivalMeanOfExpDist + 1 / serviceMean
        let avgNumCustomersSystem = (lqueue / arrivalMeanOfExpDist + 1 / serviceMean) * arrivalMeanOfExpDist
        
        return QueuingResults(utilization: utilization,
                              avgNumCustomersSystem: avgNumCustomersSystem,
                              avgNumCustomersQueue: avgNumCustomersQueue,
                              avgTimeInSystem: avgTimeInSystem,
                              avgTimeInQueue: avgTimeInQueue)
    }
    
    func calculateGoodFitTest() -> FitTest? {
        
        if tfBins.isEmpty || tfFrequencies.isEmpty {
            return nil
        }
        
        self.bins = tfBins.split(separator: ",").map { Double(Int($0.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0) }
        self.observedFrequencies = tfFrequencies.split(separator: ",").map { Double($0.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 }

        guard bins.count == observedFrequencies.count else {
            return nil
        }
        
        let totalObserved = observedFrequencies.reduce(0, +)
        self.MLE = zip(bins, observedFrequencies).map({ $0 * $1 })
        let TotalMLE = self.MLE.reduce(0, +)
        //self.MLE = zip(bins, observedFrequencies).map { $0 * $1 }.reduce(0, +)
        
        self.expectedFrequencies = []
        
        // Poission Distribution
        if distributionIndex == 0 {
            let lambda = Double(TotalMLE) / Double(totalObserved)
            
            for i in 0..<bins.count {
                let probability = (exp(-lambda) * pow(lambda, Double(i))) / factorialize(i)
                let expected = probability * Double(totalObserved)
                expectedFrequencies.append(expected)
            }
        }
        // Uniform Distribution
        else {
            let expectedFrequency = Double(totalObserved) / Double(bins.count)
            expectedFrequencies = Array(repeating: expectedFrequency, count: bins.count)
        }
        
        self.chiSquareResults = []
        for i in 0..<bins.count {
            let observed = Double(observedFrequencies[i])
            let expected = expectedFrequencies[i]
            chiSquareResults.append(pow(observed - expected, 2) / expected)
        }
//        print(chiSquareResult)
        
        let degreesOfFreedom = bins.count - 1 - 1
        let chiSquareCriticalValues: [Double: [Int: Double]] = [
            0.05: [
                1: 3.841,
                2: 5.991,
                3: 7.815,
                4: 9.488,
                5: 11.07
            ]
        ]
        
        let significanceLevel: Double = 0.05
        
        let totalChiSquare = chiSquareResults.reduce(0, +)
        
        if let newCriticalValue = chiSquareCriticalValues[significanceLevel]?[degreesOfFreedom] {
            self.result = nil
            return FitTest(chiSquare: totalChiSquare, significanceLevel: significanceLevel, criticalValue: newCriticalValue)
        }
        return nil
    }
    
    // Handler Methods
    func factorialize(_ n: Int) -> Double {
        if n == 0 {
            return 1
        }
        return Double(n) * factorialize(n - 1)
    }
    
    func isValidate() -> Bool {
        // M/M/C
        if numberOfServers == 0 && serverType != 3 {
            self.errorMessage = "Please Increase Number of Servers"
            return false
        }
        if serverType == 0 {
            if arrivalRate == "" {
                self.errorMessage = "Please Enter Arrival Rate"
                return false
            }
            else if serviceRate == "" {
                self.errorMessage = "Please Enter Service Rate"
                return false
            }
        }
        // M/G/C
        else if serverType == 1 {
            if arrivalMeanOfExpDist == "" {
                self.errorMessage = "Please Enter Arrival Mean Of Exponential Distribution"
                return false
            }
            else if maximumUniformDist == "" {
                self.errorMessage = "Please Enter Maximum Uniform Distribution"
                return false
            }
            else if minimumUniformDist == "" {
                self.errorMessage = "Please Enter Minimum Uniform Distribution"
                return false
            }
        }
        // G/G/C
        else if serverType == 2 {
            if arrivalMeanOfExpDist == "" {
                self.errorMessage = "Please Enter Arrival Mean Of Exponential Distribution"
                return false
            }
            else if serviceMeanUniformDist == "" {
                self.errorMessage = "Please Enter Service Mean Of Uniform Distribution"
                return false
            }
            else if serviceVarianceUniformDist == "" {
                self.errorMessage = "Please Enter Service Variance Of Uniform Distribution"
                return false
            }
        }
        else {
            
        }
        return true
    }
}
