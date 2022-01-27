//
//  locationPopUpView.swift
//  NRContacts
//
//  Created by Nikola Rosic on 27/01/2022.
//

import UIKit

final class locationPopUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        //        button.backgroundColor = .white
        //        button.setImage(#imageLiteral(resourceName: "clear_black"), for: .normal)
        //        button.tintColor = .black
        //        button.backgroundColor = .white
        return button
    }()
    
    private let popupView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.addBoundsToView(borderColor: . , borderWidth: 0.5)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    
    
    //    private lazy var cancelButton: UIButton = {
    //        let button = UIButton()
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        button.backgroundColor = .white
    //        button.setTitle(Language.cancel.localized.uppercased(), for: .normal)
    //        button.setTitleColor(.infinityDarkGray, for: .normal)
    //        button.setTitleColor(.infinityLightGray, for: .highlighted)
    //        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    //        return button
    //    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("enter FinalInfoBeforePaymentViewController")
        setupView()
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        navigationController?.setNavigationBarHidden(true, animated: animated)
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        navigationController?.setNavigationBarHidden(false, animated: animated)
    //    }
    
    deinit {
        print("deinit locationPopUpViewController")
    }
    
    //    init(withOrder order: TheOrder, infoForPayment: InfoForPayment, sectorSvg: SectorSVG, ticketAction: TicketAction, delegate: GoToPaymentDelegate) {
    //        self.order = order
    //        self.infoForPayment = infoForPayment
    //        self.svgSector = sectorSvg
    //        self.ticketAction = ticketAction
    //        self.delegate = delegate
    //
    //        super.init(nibName: nil, bundle: nil)
    //    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func cancel() {
        closePressed()
    }
    
    @objc private func closePressed() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupView() {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        view.addSubview(popupView)
        
        popupView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 1.8).isActive = true
        popupView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 35).isActive = true
        popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(closeButton)
        //        closeButton.anchor(nil, left: nil, bottom: popupView.topAnchor, right: popupView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 15, rightConstant: 15, widthConstant: 36, heightConstant: 36)
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        closeButton.layer.cornerRadius = 18
        closeButton.clipsToBounds = true
    }
}

