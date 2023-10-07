//
//  FireWeatherIndexManager.swift
//  Vulcan
//
//  Created by Aiden McDougal on 10/6/23.
//
//https://github.com/Unidata/MetPy/issues/636
/*
 FFWI = n*[(1+U^2)^.5]/0.3002

 where U=wind speed in mph and n=moisture damping coefficient.

 n=1-2(m/30)+1.5(m/30)^2-0.5(m/30)^3

 where m=equilibrium mositure content.

 for h < 10 %

 m=0.03229 + 0.281073h - 0.000578hT

 for 10% < h <= 50%

 m=2.22749 + 0.160107h - 0.01478T

 for h > 50%

 m=21.0606 + 0.005565H^2 - 0.00035hT - 0.483199h

 where T=temperature in F and h=relative humidity in percent.
 */



/**import Foundation

class FosbergFWIManager: ObservableObject {
    func FFWI(temp: Double, humidity: Double, wind: Double) -> Double {
        var ffwi = 0.0
        var n = 0.0
        var m = 0.0
        if humidity < 10 {
            m = 0.03229 + 0.281073 * humidity - 0.000578 * humidity * temp
        } else if humidity <= 50 {
            m = 2.22749 + 0.160107 * humidity - 0.01478 * temp
        } else {
            m = 21.0606 + 0.005565 * pow(humidity,2) - 0.00035 * humidity * temp - 0.483199 * humidity
        }
        
        n = 1 - 2*(m/30) + 1.5*pow((m/30),2) - 0.5*pow((m/30),3)
        
        ffwi = n * (pow((1 + pow(wind,2)),0.5)) / 0.3002
        
        return ffwi
    }
}
**/
