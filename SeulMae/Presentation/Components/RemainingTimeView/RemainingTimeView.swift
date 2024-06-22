//
//  RemainingTimeView.swift
//  SeulMae
//
//  Created by 조기열 on 6/23/24.
//

import UIKit

class RemainingTimeView: UILabel {
    
    var timer: Timer?
    var _remainingTime: TimeInterval = 180
    var remainingTime: TimeInterval = 180
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.textAlignment = .center
        self.font = UIFont.systemFont(ofSize: 24.0)
        self.textColor = .red
    }
    
    deinit {
        self.stopTimer()
    }
    
    func setRemainingTime(minutes: TimeInterval) {
        self.remainingTime = minutes
        self._remainingTime = minutes
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let strongSelf = self else { return }
            strongSelf._remainingTime -= 1
            if strongSelf._remainingTime >= 0 {
                let minutes = Int(strongSelf._remainingTime) / 60
                let seconds = Int(strongSelf._remainingTime) % 60
                strongSelf.text = String(format: "%02d:%02d", minutes, seconds)
            } else {
                strongSelf.stopTimer()
                strongSelf.text = "00:00"
            }
        }
    }
    
    func resetTimer() {
        stopTimer()
        _remainingTime = remainingTime
        startTimer()
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        timer = nil
    }
}
