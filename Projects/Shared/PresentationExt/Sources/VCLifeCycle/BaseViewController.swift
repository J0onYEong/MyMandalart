//
//  BaseViewController.swift
//  SharedPresentationExt
//
//  Created by choijunios on 2/28/25.
//

import UIKit

import RxSwift

open class BaseViewController: UIViewController {
    // LifeCycleEvent
    public private(set) lazy var lifeCycleEvent: Observable<ViewControllerLifeCycle> = lifeCycleEventPub.asObservable()
    private let lifeCycleEventPub: PublishSubject<ViewControllerLifeCycle> = .init()
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    public required init?(coder: NSCoder) { super.init(coder: coder) }
    
    open override func loadView() {
        super.loadView()
        lifeCycleEventPub.onNext(.loadView)
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        lifeCycleEventPub.onNext(.viewDidLoad)
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lifeCycleEventPub.onNext(.viewWillAppear)
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lifeCycleEventPub.onNext(.viewDidAppear)
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lifeCycleEventPub.onNext(.viewWillDisappear)
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lifeCycleEventPub.onNext(.viewDidDisappear)
    }
}
