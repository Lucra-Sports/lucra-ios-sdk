//
//  UIKitExample.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 6/26/23.
//

import SwiftUI
import LucraSDK

private struct AlternateAppearance: UIKitAppearance {
    func color(_ font: LucraColor) -> UIColor? {
        switch font {
        case .lucraOrange:
            return .blue
        default:
            return nil
        }
    }
    
    func font(_ font: LucraFont) -> UIFont? {
        switch font {
        case .h1:
            return UIFont.systemFont(ofSize: 5)
        default:
            return nil
        }
    }
}

class UIKitSampleViewController: UIViewController {
    let lucraClient = LucraClient(config: .init(environment: .init(authenticationClientID: "VTa8LJTUUKjcaNFem7UBA98b6GVNO5X3",
                                                                   environment: .develop,
                                                                   urlScheme: "TODO:"),
                                                appearance: AlternateAppearance()))
    
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
        //Image View
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 500.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 500.0).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "DylanWine")
        
        let addFundsButton = button(title: "Add Funds", action: { [weak self] in
            guard let self else { return }
            self.present(lucraFlow: .addFunds, client: lucraClient, animated: true)
        })
        
        let createGamesMatchupButton = button(title: "Create Games Matchup", action: { [weak self] in
            guard let self else { return }
            self.present(lucraFlow: .createGamesMatchup, client: lucraClient, animated: true)
        })
        
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 16.0
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(addFundsButton)
        stackView.addArrangedSubview(createGamesMatchupButton)
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
    func makeUIViewController(context: Context) -> UIKitSampleViewController {
        UIKitSampleViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIKitSampleViewController, context: Context) {
    }
}
