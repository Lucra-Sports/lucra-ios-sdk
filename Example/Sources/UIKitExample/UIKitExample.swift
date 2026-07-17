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
    private var collectionView: UICollectionView!
    private let flows = LucraFlow.allCases

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
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FlowButtonCell.self, forCellWithReuseIdentifier: "FlowButtonCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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

extension UIKitSampleViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flows.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlowButtonCell", for: indexPath) as! FlowButtonCell
        let flow = flows[indexPath.item]
        cell.configure(title: flow.displayName) { [weak self] in
            guard let self else { return }
            self.present(lucraFlow: flow, client: lucraClient, animated: true)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpacing = flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let width = (collectionView.bounds.width - totalSpacing) / 2
        return CGSize(width: width, height: 60)
    }
}

class FlowButtonCell: UICollectionViewCell {
    private var button: UIButton!
    private var action: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    func configure(title: String, action: @escaping () -> Void) {
        self.action = action

        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = .blue
        configuration.baseForegroundColor = .white
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .boldSystemFont(ofSize: outgoing.font?.pointSize ?? 17)
            return outgoing
        }
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 15,
            bottom: 0,
            trailing: 15
        )

        button.configuration = configuration
        button.layer.cornerRadius = 24
        button.clipsToBounds = true

        button.removeTarget(nil, action: nil, for: .allEvents)
        button.addAction(UIAction { [weak self] _ in
            self?.action?()
        }, for: .touchUpInside)
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
