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
