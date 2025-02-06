//
//  NearEarthObject+Mocks.swift
//  Service
//
//  Created by Carter Foughty on 2/4/25.
//

import Foundation

public extension NearEarthObject {
    
    static var mock1: NearEarthObject {
        NearEarthObject(
            id: "2465633",
            referenceID: "2465633",
            name: "(2009 JR5)",
            absoluteMagnitude: 20.44,
            estimatedMinimumDiameter: 217.0475943071,
            estimatedMaximumDiameter: 485.3331752235,
            isPotentiallyHazardousAsteroid: false,
            closeApproachDate: Date(),
            relativeVelocity: 18.1279360862,
            missDistance: 45290298.225725659,
            orbitingBody: "Earth"
        )
    }
    
    static var mock2: NearEarthObject {
        NearEarthObject(
            id: "3426410",
            referenceID: "3426410",
            name: "(2008 QV11)",
            absoluteMagnitude: 21.34,
            estimatedMinimumDiameter: 143.4019234645,
            estimatedMaximumDiameter: 320.6564489709,
            isPotentiallyHazardousAsteroid: false,
            closeApproachDate: Date().advanced(by: 24 * 60 * 60),
            relativeVelocity: 19.7498128142,
            missDistance: 38764558.550560687,
            orbitingBody: "Earth"
        )
    }
    
    static var mock3: NearEarthObject {
        NearEarthObject(
            id: "3553060",
            referenceID: "3553060",
            name: "(2010 XT10)",
            absoluteMagnitude: 26.5,
            estimatedMinimumDiameter: 13.3215566698,
            estimatedMaximumDiameter: 29.7879062798,
            isPotentiallyHazardousAsteroid: false,
            closeApproachDate: Date(),
            relativeVelocity: 19.1530348886,
            missDistance: 73563782.385433689,
            orbitingBody: "Earth"
        )
    }
    
    static var mock4: NearEarthObject {
        NearEarthObject(
            id: "3726710",
            referenceID: "3726710",
            name: "(2015 RC)",
            absoluteMagnitude: 24.3,
            estimatedMinimumDiameter: 36.6906137531,
            estimatedMaximumDiameter: 82.0427064882,
            isPotentiallyHazardousAsteroid: false,
            closeApproachDate: Date().advanced(by: 24 * 60 * 60),
            relativeVelocity: 19.486643553,
            missDistance: 4027962.697099799,
            orbitingBody: "Earth"
        )
    }
    
    static var mock5: NearEarthObject {
        NearEarthObject(
            id: "3727181",
            referenceID: "3727181",
            name: "(2015 RO36)",
            absoluteMagnitude: 22.93,
            estimatedMinimumDiameter: 68.9532874451,
            estimatedMaximumDiameter: 154.1842379994,
            isPotentiallyHazardousAsteroid: false,
            closeApproachDate: Date().advanced(by: 24 * 60 * 60),
            relativeVelocity: 15.8091452192,
            missDistance: 8086031.995456672,
            orbitingBody: "Earth"
        )
    }
    
    static var mock6: NearEarthObject {
        NearEarthObject(
            id: "3727639",
            referenceID: "3727639",
            name: "(2015 RN83)",
            absoluteMagnitude: 21.77,
            estimatedMinimumDiameter: 117.639989374,
            estimatedMaximumDiameter: 263.0510131126,
            isPotentiallyHazardousAsteroid: false,
            closeApproachDate: Date(),
            relativeVelocity: 12.0811420305,
            missDistance: 25195177.358205543,
            orbitingBody: "Earth"
        )
    }
    
    static var mock7: NearEarthObject {
        NearEarthObject(
            id: "723",
            referenceID: "323",
            name: "(2015 CB)",
            absoluteMagnitude: 21.34,
            estimatedMinimumDiameter: 90.4019234645,
            estimatedMaximumDiameter: 180.6564489709,
            isPotentiallyHazardousAsteroid: true,
            closeApproachDate: Date().advanced(by: 24 * 60 * 60 * 2),
            relativeVelocity: 19.7498128142,
            missDistance: 32764558.550560687,
            orbitingBody: "Earth"
        )
    }
    
    static var mock8: NearEarthObject {
        NearEarthObject(
            id: "3730577",
            referenceID: "3730577",
            name: "(2015 TX237)",
            absoluteMagnitude: 23.3,
            estimatedMinimumDiameter: 58.1507039646,
            estimatedMaximumDiameter: 130.0289270043,
            isPotentiallyHazardousAsteroid: false,
            closeApproachDate: Date(),
            relativeVelocity: 6.573400491,
            missDistance: 11896602.433824546,
            orbitingBody: "Earth"
        )
    }
    
    static var mock9: NearEarthObject {
        NearEarthObject(
            id: "3731587",
            referenceID: "3731587",
            name: "(2015 UG)",
            absoluteMagnitude: 22.81,
            estimatedMinimumDiameter: 72.8710414898,
            estimatedMaximumDiameter: 162.9446023625,
            isPotentiallyHazardousAsteroid: false,
            closeApproachDate: Date().advanced(by: 24 * 60 * 60),
            relativeVelocity: 11.9557600601,
            missDistance: 16940461.018585347,
            orbitingBody: "Earth"
        )
    }
    
    static var mock10: NearEarthObject {
        NearEarthObject(
            id: "3747356",
            referenceID: "3747356",
            name: "(2016 EK158)",
            absoluteMagnitude: 20.49,
            estimatedMinimumDiameter: 212.1069878758,
            estimatedMaximumDiameter: 474.2856433931,
            isPotentiallyHazardousAsteroid: false,
            closeApproachDate: Date(),
            relativeVelocity: 16.9572895141,
            missDistance: 41958497.683910302,
            orbitingBody: "Earth"
        )
    }
}
