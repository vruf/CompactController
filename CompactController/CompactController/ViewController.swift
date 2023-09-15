//
//  ViewController.swift
//  CompactController
//
//  Created by Vadim Rufov on 14.9.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var button: UIButton = {
        let view = UIButton()
        view.configuration = UIButton.Configuration.plain()
        view.configuration?.title = "Present"
        view.addTarget(self, action: #selector(showPopover), for: [.touchUpInside, .touchUpOutside])
        return view
    }()
    
    private var popover: UIViewController {
        let controller = PopoverViewController()
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.sourceView = button
        controller.popoverPresentationController?.permittedArrowDirections = .up
        controller.popoverPresentationController?.delegate = self
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @objc func showPopover() {
        present(popover, animated: true)
    }
    
    private func setupViews() {
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

}


extension ViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}


class PopoverViewController: UIViewController {
    private lazy var segmentedControl = {
        let actionOne = UIAction(title: "280pt", handler: { _ in self.setFrameHeight(height: 280, index: 0) })
        let actionTwo = UIAction(title: "150pt", handler: { _ in self.setFrameHeight(height: 150, index: 1) })
        return UISegmentedControl(frame: .zero, actions: [actionOne, actionTwo])
    }()
    
    private lazy var dismissButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        view.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(segmentedControl)
        view.addSubview(dismissButton)
        setFrameHeight(height: 280, index: 0)
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),
            segmentedControl.widthAnchor.constraint(equalToConstant: 100),
            
            dismissButton.topAnchor.constraint(equalTo: segmentedControl.topAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
    
    private func setFrameHeight(height: Int, index: Int) {
        UIView.animate(withDuration: 0.2) {
            self.preferredContentSize = .init(width: self.view.frame.width, height: CGFloat(height))
        }
        self.segmentedControl.selectedSegmentIndex = index
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
}
