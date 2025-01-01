//
//  Logger.swift
//  Logger
//
//  Created by choijunios on 1/2/25.
//

import SharedLoggerInterface

import AmplitudeSwift
import RxSwift
import RxRelay

public class DefaultLogger: SharedLoggerInterface.Logger {
    
    private let logCollector: PublishRelay<LogObject> = .init()
    private let disposeBag: DisposeBag = .init()
    
    private let applitude: Amplitude = {
        return Amplitude(configuration: Configuration(
            apiKey: "AMPLITUDE_API_KEY",
            autocapture: [ .screenViews ]
        ))
    }()
    
    public init() {
        
        logCollector
            .delay(.milliseconds(350), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] logObject in
                
                // send log
                let eventObject = BaseEvent(
                    eventType: logObject.eventType,
                    eventProperties: logObject.properties
                )
                
                self?.applitude.track(event: eventObject)
            })
            .disposed(by: disposeBag)
    }
}


// MARK: Logger
public extension DefaultLogger {
    
    func send(_ log: LogObject) {
        
        logCollector.accept(log)
    }
}
