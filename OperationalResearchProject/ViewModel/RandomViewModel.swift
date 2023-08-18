//
//  SimulationViewModel.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 17/08/2023.
//

import Foundation

class RandomViewModel: ObservableObject {
    
    /// user input
    @Published var lambda: Double = 2.15
    @Published var meo: Double = 1.58
    
    @Published var cumulativeList: [Double] = []
    @Published var lookUpList: [Double] = []
    @Published var avgTimeBtwArrivals: [Double] = []
    @Published var interArrivals: [Double] = []
    @Published var arrivalTimes: [Double] = []
    @Published var serviceTimes: [Double] = []
    
    @Published var startTimes: [Double] = []
    @Published var endTimes: [Double] = []
    
    @Published var turnArounds: [Double] = []
    @Published var waitTimes: [Double] = []
    @Published var responseTimes: [Double] = []
    
    @Published var showResult = false
    
    func calculateValues(lambda: String, meo: String) {
        guard let lambda = Double(lambda) else {
            return
        }
        
        guard let meo = Double(meo) else {
            return
        }
        
        self.lambda = lambda
        self.meo = meo
        self.showResult = true
        
        self.getCumulativeData()
        self.getLookupData()
        self.getAverageTimeBetweenArrivals()
        self.getInterArrivalData()
        self.getArrivalTimeData()
        self.getServiceTimeData()
        self.getStartTime()
        self.getEndTime()
        self.getTurnAround()
        self.getWaitTime()
        self.getResponseTime()
    }
    
    func getCumulativeData() {
        
        self.cumulativeList = []
        var totalFrequency = 0.0
        for i in 0...9 {
            totalFrequency += self.cumulativeFrequency(lambda: lambda, x: i)
            cumulativeList.append(totalFrequency)
        }
        print("Cumulative Probabilty: ")
        print(cumulativeList)
        print("\n")
    }
    
    func getLookupData() {
        
        lookUpList = []
        for i in 0 ..< cumulativeList.count {
            let index = i - 1
            if index < 0 {
                lookUpList.append(0)
            }
            else {
                lookUpList.append(cumulativeList[index])
            }
        }
        print("Lookup List")
        print(lookUpList)
        print("\n")
        
    }
    
    func getAverageTimeBetweenArrivals() {
        avgTimeBtwArrivals = []
        for i in 0 ..< lookUpList.count {
            self.avgTimeBtwArrivals.append(Double(i))
        }
        print("Average Time B/W Arrivals")
        print(self.avgTimeBtwArrivals)
        print("\n")
    }
    
    func getInterArrivalData() {
        //        let cpList = [0.116, 0.366, 0.636, 0.829, 0.932, 0.977, 0.993]
        //        let lookupList = [0, 0.116, 0.366, 0.636, 0.829, 0.932, 0.977]
        //        let random = 0.93281
        
        interArrivals = []
        for i in 0 ... 9 {
            if i == 0 {
                self.interArrivals.append(0)
            }
            else if let interArrival = findInterArrivalIndex() {
                self.interArrivals.append(interArrival)
            }
        }
        self.interArrivals = [0, 0, 1, 4, 2, 4, 3, 4, 3, 1]
        print("Inter Arrival Data")
        print(self.interArrivals)
        print("\n")
    }
    
    func getArrivalTimeData() {
        var arrivalTime = 0
        
        arrivalTimes = []
        for i in 0 ... 9 {
            if i == 0 {
                self.arrivalTimes.append(0)
            }
            else {
                arrivalTime += Int(interArrivals[i])
                self.arrivalTimes.append(Double(arrivalTime))
            }
        }
        print("Arrival Time")
        print(self.arrivalTimes)
        print("\n")
    }
    
    func getServiceTimeData() {
        serviceTimes = []
        while serviceTimes.count < 10 {
            let random = Double.random(in: 0...1)
            let serviceTime = (-meo * log(random))
            let roundedServiceTime = serviceTime.rounded()
            if roundedServiceTime > 0 {
                serviceTimes.append(roundedServiceTime)
            }
        }
        serviceTimes = [1,2,5,3,6,4,2,5,3,1]
        print("Service Time")
        print(self.serviceTimes)
        print("\n")
    }
    
    func getStartTime() {
        startTimes = []
        var currentTime = 0.0
        
        for i in 0...9 {
            if i == 0 {
                startTimes.append(0)
            }
            else {
                currentTime += serviceTimes[i - 1]
                self.startTimes.append(currentTime)
            }
        }
        print("Start Time")
        print(startTimes)
        print("\n")
    }
    
    func getEndTime() {
        endTimes = []
        for i in 0 ... 9 {
            let start = startTimes[i]
            let serviceTime = serviceTimes[i]
            let endTime = start + serviceTime
            self.endTimes.append(endTime)
        }
        print("End Time")
        print(endTimes)
        print("\n")
    }
    
    func getTurnAround() {
        turnArounds = []
        for i in 0 ... 9 {
            let end = endTimes[i]
            let arrival = arrivalTimes[i]
            let turnAround = end - arrival
            self.turnArounds.append(turnAround)
        }
        print("Turn Arounds")
        print(turnArounds)
        print("\n")
    }
    
    func getWaitTime() {
        waitTimes = []
        for i in 0 ... 9 {
            let turnAround = turnArounds[i]
            let service = serviceTimes[i]
            let waitTime = turnAround - service
            waitTimes.append(waitTime)
        }
        print("Wait Times")
        print(waitTimes)
        print("\n")
    }
    
    func getResponseTime() {
        responseTimes = []
        for i in 0 ... 9 {
            let start = startTimes[i]
            let arrival = arrivalTimes[i]
            let response = start - arrival
            responseTimes.append(response)
        }
        print("Response Times")
        print(responseTimes)
        print("\n")
    }
    

    
//    func getInterArrival() {
//        var interArrivals: [Double] = []
//
//        for i in 0 .. 9 {
//            let random = Double.random(in: 0...1)
//            if i == 0 {
//                interArrivals.append(0)
//            }
//            else {
//                let
//                if let index =
//            }
//        }
//    }
    
    //MARK: Helper Functions
    private func findInterArrivalIndex() -> Double? {
        
        let random = Double.random(in: 0...1)
        
        guard let index = self.lookUpList.firstIndex(where: { $0 > random }) else {
            return nil
        }
        return Double(index - 1)
    }
    
    private func cumulativeFrequency(lambda: Double, x: Int) -> Double {
        let eToMinusLambda = exp(-lambda)
        let lambdaToX = pow(lambda, Double(x))
        let factorialX = factorial(x)
        
        let result = (eToMinusLambda * lambdaToX) / factorialX
        return result
    }
    
    private func factorial(_ n: Int) -> Double {
        if n == 0 {
            return 1
        } else {
            return Double(n) * factorial(n - 1)
        }
    }
}
