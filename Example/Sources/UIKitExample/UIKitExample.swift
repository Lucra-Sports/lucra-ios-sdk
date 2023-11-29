//
//  UIKitExample.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 6/26/23.
//

import SwiftUI
import LucraSDK

class UIKitSampleViewController: UIViewController {
    private let lucraClient: LucraClient
    
    init(lucraClient: LucraClient) {
        self.lucraClient = lucraClient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        let navButton = button(title: "⚡️ \((lucraClient.user?.balance ?? 0.0).money)", action: { [weak self] in
            guard let self else { return }
            self.present(lucraFlow: .profile, client: lucraClient, animated: true)
        })
        
        self.parent?.navigationItem.title = "UIKit Example"
        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navButton)
    }
    
    func setup() {        
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 16.0
                
        for flow in LucraFlow.allCases {
            let flowButton = button(title: flow.displayName, action: { [weak self] in
                guard let self else { return }
                self.present(lucraFlow: flow, client: lucraClient, animated: true)
            })
            stackView.addArrangedSubview(flowButton)
        }
                
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        
        //Constraints
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    private func button(title: String, action: @escaping () -> Void) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        
        configuration.title = title
        configuration.baseBackgroundColor = .blue
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 20,
            bottom: 10,
            trailing: 20
        )
        
        let button = UIButton(configuration: configuration, primaryAction: UIAction(title: title, handler: { _ in action() }))
        
        return button
    }
}

// MARK: - Just needed to be able to launch UIKit since this sample project's root is SwiftUI
struct UIKitSampleViewControllerRepresentable: UIViewControllerRepresentable {
    @EnvironmentObject var lucraClient: LucraClient

    func makeUIViewController(context: Context) -> TabBarViewController {
        TabBarViewController(lucraClient: lucraClient)
    }
    
    func updateUIViewController(_ uiViewController: TabBarViewController, context: Context) {
    }
}


public class TabBarViewController: UITabBarController {
    private let lucraClient: LucraClient
    
    init(lucraClient: LucraClient) {
        self.lucraClient = lucraClient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
           tabBarAppearance.configureWithDefaultBackground()
              UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    func setupViewControllers() {
        let firstVC = UIKitSampleViewController(lucraClient: lucraClient)
        let secondVC: UIViewController = lucraClient.ui.flow(.publicFeed, hideCloseButton: true)

            
            firstVC.tabBarItem = UITabBarItem(title: "Sheet", image: UIImage(systemName: "square.on.square.intersection.dashed"),selectedImage: UIImage(systemName: "square.on.square.intersection.dashed.fill"))
            secondVC.tabBarItem = UITabBarItem(title: "Embedded", image: UIImage(systemName: "square.dashed.inset.filled"),selectedImage: UIImage(systemName: "square.dashed.inset.filled.fill"))

            viewControllers = [firstVC, secondVC]
    }
}
