//
//  ViewController.swift
//  滑动选中button
//
//  Created by satoshi_umaM1 on 2023/12/13.
//

import UIKit

class ViewController: UIViewController {
    private var buttons: [UIButton] = []
    private var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        createButtons()
        setupGestureRecognizer()
    }

    func createButtons() {
        let buttonSize = CGSize(width: view.frame.width, height: 50)
        var buttonOrigin = CGPoint(x: (view.frame.width - buttonSize.width) / 2, y: 100)
        for i in 1 ... 5 {
            let button = UIButton(frame: CGRect(origin: buttonOrigin, size: buttonSize))
            button.setTitle("Button \(i)", for: .normal)
            button.setTitleColor(.red, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            view.addSubview(button)
            buttons.append(button)

            buttonOrigin.y += buttonSize.height
        }

        view.addSubview({
            nameLabel = UILabel()
            nameLabel?.frame = CGRect(x: 0, y: view.frame.height - 100, width: view.frame.width, height: 50)
            nameLabel?.textColor = .green
            nameLabel?.font = UIFont.systemFont(ofSize: 20)
            nameLabel?.textAlignment = .center
            return nameLabel!
        }())
    }

    func setupGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)

        for button in buttons {
            if button.frame.contains(location) {
                if !button.isSelected {
                    button.isSelected = true
                    button.backgroundColor = .green
                    buttonScrollTapped(button)
                }
            } else {
                button.isSelected = false
                button.backgroundColor = .white
            }
        }
    }

    @objc func buttonTapped(_ sender: UIButton) {
        for button in buttons {
            button.backgroundColor = .white
        }
        sender.backgroundColor = .green

        print("Button tapped: \(sender.currentTitle ?? "")")
        nameLabel?.text = sender.currentTitle ?? ""
    }

    func buttonScrollTapped(_ sender: UIButton) {
        // 判断按钮的选中状态，以防止多次执行
        guard sender.isSelected else {
            print("返回")

            return
        }
        print("Button tapped: \(sender.currentTitle ?? "")")
        nameLabel?.text = sender.currentTitle ?? ""
    }
}


//
//  SliderBtnView.swift
//  BJYYGHT
//
//  Created by satoshi_umaM1 on 2024/5/10.
//

import UIKit

protocol SliderBtnViewDelegate: AnyObject {
    func returnClickIndex(_ index: Int, str: String)
    func returnClickShowOrHide(_ isBool: Bool)
}

class SliderBtnView: UIViewController {
    weak var delegate: SliderBtnViewDelegate?
    private var buttons: [UIButton] = []
    private var normalTag: Int = 5000
    private var lastBtn: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.backgroundColor = rgba(237, 237, 237, 1)

        setupGestureRecognizer()
    }

    func selectBtn(_ index: Int) {
        if let tempBtn = view.viewWithTag(normalTag + index) as? UIButton {
            for button in buttons {
                button.setTitleColor(rgba(46, 46, 46, 1), for: .normal)
                button.backgroundColor = rgba(237, 237, 237, 1)
            }
            tempBtn.setTitleColor(.white, for: .normal)
            tempBtn.backgroundColor = rgba(71, 160, 255, 1) // 选中
//            print("t滑动按钮: \(tempBtn.currentTitle ?? "")")
        }
    }

    func setBtns(_ arr: [String]) {
        let viewW = 27
        let btnWH = 23
        let buttonSize = CGSize(width: btnWH, height: btnWH)
        var buttonOrigin = CGPoint(x: (viewW - btnWH) / 2, y: 10)
        for (index, item) in arr.enumerated() {
            let button = UIButton(frame: CGRect(origin: buttonOrigin, size: buttonSize))
            button.tag = normalTag + index
            button.setTitle("\(item)", for: .normal)
            button.setTitleColor(rgba(46, 46, 46, 1), for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 13)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 5
            if index == 0 { // 选中
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = rgba(71, 160, 255, 1)
                lastBtn = button
                delegate?.returnClickIndex(index, str: item)
            }
            view.addSubview(button)
            buttons.append(button)

            buttonOrigin.y += buttonSize.height
        }
    }

    func setupGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        delegate?.returnClickShowOrHide(true)
        let location = sender.location(in: view)
        var shouldUpdateButtonState = false

        for button in buttons {
            if button.frame.contains(location) {
                if !button.isSelected {
                    button.isSelected = true
                    button.setTitleColor(.white, for: .normal)
                    button.backgroundColor = rgba(71, 160, 255, 1) // 选中
                    buttonScrollTapped(button)
                    lastBtn = button
                    shouldUpdateButtonState = true
                }
            } else {
                if button.isSelected {
                    button.isSelected = false
                    button.setTitleColor(rgba(46, 46, 46, 1), for: .normal)
                    button.backgroundColor = rgba(237, 237, 237, 1)
                    shouldUpdateButtonState = true
                }
            }
        }

        if sender.state == .changed || sender.state == .ended {
            if shouldUpdateButtonState {
                selectBtn((lastBtn?.tag ?? normalTag) - normalTag)
            }
        }

        if sender.state == .ended {
            delegate?.returnClickShowOrHide(false)
        }
    }

    @objc func handlePan1(_ sender: UIPanGestureRecognizer) {
        delegate?.returnClickShowOrHide(true)
        let location = sender.location(in: view)
        for button in buttons {
            if button.frame.contains(location) {
                if !button.isSelected {
                    button.isSelected = true
                    button.setTitleColor(.white, for: .normal)
                    button.backgroundColor = rgba(71, 160, 255, 1) // 选中
                    buttonScrollTapped(button)
                    lastBtn = button
                }
            } else {
                button.isSelected = false
                button.setTitleColor(rgba(46, 46, 46, 1), for: .normal)
                button.backgroundColor = rgba(237, 237, 237, 1)
            }
        }
        if sender.state == .changed {
            selectBtn((lastBtn?.tag ?? normalTag) - normalTag)
        }
        if sender.state == .ended {
            delegate?.returnClickShowOrHide(false)
            selectBtn((lastBtn?.tag ?? normalTag) - normalTag)
        }
    }

    @objc func buttonTapped(_ sender: UIButton) {
        for button in buttons {
            button.setTitleColor(rgba(46, 46, 46, 1), for: .normal)
            button.backgroundColor = rgba(237, 237, 237, 1)
        }
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = rgba(71, 160, 255, 1) // 选中

        let index = sender.tag - normalTag
        delegate?.returnClickIndex(index, str: sender.currentTitle ?? "")
    }

    func buttonScrollTapped(_ sender: UIButton) {
        guard sender.isSelected else { return }
        let index = sender.tag - normalTag
        delegate?.returnClickIndex(index, str: sender.currentTitle ?? "")
    }
}

