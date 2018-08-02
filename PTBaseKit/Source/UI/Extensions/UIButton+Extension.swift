//
//  UIButton+Extension.swift
//  BaseKit
//
//  Created by P36348 on 06/12/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import RxSwift


extension UIButton {
    public func performWhenClick(action: @escaping ()->Void) -> Disposable {
        return self.rx.controlEvent(UIControlEvents.touchUpInside).subscribe(onNext: { (_) in
            action()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
}

// MARK: Count down animation

private var timerKey: String = ""

private var timeCountKey: String = ""

private var preEnableKey: String = ""

private var countDownTitleKey: String = ""

private var preTitleKey: String = ""

private var preTitleColorKey: String = ""

private var observerKey: String = ""

extension UIButton {
    
    public var isCounting: Bool {
        return self.timer != nil
    }
    
    /// 倒计时之前的
    private var preEnable: Bool {
        set {
            objc_setAssociatedObject(self, &preEnableKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &preEnableKey) as? Bool ?? false
        }
    }
    
    private var preTitle: String? {
        set {
            objc_setAssociatedObject(self, &preTitleKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &preTitleKey) as? String ?? ""
        }
    }
    
    private var countDownTitle: String? {
        set {
            objc_setAssociatedObject(self, &countDownTitleKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &countDownTitleKey) as? String ?? ""
        }
    }
    
    private var preTitleColor: UIColor? {
        set {
            objc_setAssociatedObject(self, &preTitleColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &preTitleColorKey) as? UIColor
        }
    }
    
    private var timeCount: Int {
        set {
            objc_setAssociatedObject(self, &timeCountKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &timeCountKey) as? Int ?? 60
        }
    }
    
    private var countDownObserver: AnyObserver<UIButton>? {
        set {
            objc_setAssociatedObject(self, &observerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &observerKey) as? AnyObserver<UIButton> ?? nil
        }
    }
    
    private var timer: Timer? {
        set {
            objc_setAssociatedObject(self, &timerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &timerKey) as? Timer
        }
    }
    
    public func startCountDown(count:Int = 60, countDownTitle: String) {
        self.timeCount = count
        
        self.preTitle = self.title(for: .normal) ?? ""
        self.preTitleColor  = titleColor(for: .normal)
        
        self.countDownTitle = countDownTitle
        
        self.setTitle("\(self.countDownTitle ?? "")(\(self.timeCount))", for: .normal)
        self.setTitleColor(UIColor.tk.lightGray, for: .normal)
        
        self.preEnable = self.isEnabled
        self.isEnabled = false
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(UIButton.changeTime(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    
    /// 返回一个Observable,在倒计时完成后会发出信号, 如果不在此处订阅, 倒计时结束后按钮的isEnable会恢复到倒计时前的状态
    public func rx_startCountDown(count:Int = 60, countDownTitle: String) -> Observable<UIButton> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            self?.startCountDown(count: count, countDownTitle: countDownTitle)
            self?.countDownObserver = observer
            return Disposables.create()
        })
    }
    
    @objc public func changeTime(_ time:Timer){
        self.timeCount -= 1
        if
            self.timeCount >= 0
        {
            self.setTitle("\(self.countDownTitle ?? "")(\(self.timeCount))", for: .normal)
        }
        else
        {
            self.setTitle(self.preTitle, for: .normal)
            
            self.setTitleColor(preTitleColor, for: .normal)
            
            self.timeCount = 60
            self.isEnabled = self.preEnable
            
            time.invalidate()
            self.timer = nil
            self.countDownObserver?.onNext(self)
        }
    }
}

