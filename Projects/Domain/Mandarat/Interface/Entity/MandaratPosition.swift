//
//  MandaratPosition.swift
//  Mandarat
//
//  Created by choijunios on 12/4/24.
//

public enum MandaratPosition: CaseIterable {
    
    // Row1
    case ONE_ONE
    case ONE_TWO
    case ONE_TRD
    
    // Row2
    case TWO_ONE
    case TWO_TWO
    case TWO_TRD
    
    // Row3
    case TRD_ONE
    case TRD_TWO
    case TRD_TRD
    
    init?(x: Int, y: Int) {
        
        for positionCase in MandaratPosition.allCases {
            
            if positionCase.matrixCoordinate == (x, y) {
                
                self = positionCase
                
                return
            }
        }
        
        return nil
    }
    
    public var matrixCoordinate: (Int, Int) {
        
        switch self {
        case .ONE_ONE:
            (0, 0)
        case .ONE_TWO:
            (0, 1)
        case .ONE_TRD:
            (0, 2)
        case .TWO_ONE:
            (1, 0)
        case .TWO_TWO:
            (1, 1)
        case .TWO_TRD:
            (1, 2)
        case .TRD_ONE:
            (2, 0)
        case .TRD_TWO:
            (2, 1)
        case .TRD_TRD:
            (2, 2)
        }
    }
}
