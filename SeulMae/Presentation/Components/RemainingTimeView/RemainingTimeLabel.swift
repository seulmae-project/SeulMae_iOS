//
//  RemainingTimeLabel.swift
//  SeulMae
//
//  Created by 조기열 on 6/23/24.
//

import UIKit

class RemainingTimeLabel: UILabel {
    
    var timer: Timer?
    var _remainingTime: TimeInterval = 180
    var remainingTime: TimeInterval = 180
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.textAlignment = .center
        self.font = .systemFont(ofSize: 14)
        self.textColor = .red
    }
    
    deinit {
        self.stopTimer()
    }
    
    func setRemainingTime(minutes: TimeInterval) {
        self.remainingTime = minutes * 60
        self._remainingTime = minutes * 60
        let minutes = Int(_remainingTime) / 60
        let seconds = Int(_remainingTime) % 60
        text = String(format: "%02d:%02d", minutes, seconds)
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
