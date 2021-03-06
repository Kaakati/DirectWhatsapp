//
//  ViewController.swift
//  DirectWhatsapp
//
//  Created by Mohamad Kaakati on 8/4/18.
//  Copyright © 2018 Mohamad Kaakati. All rights reserved.
//

import UIKit
import CountryKit
import SwifterSwift
import IHKeyboardAvoiding

class ViewController: UIViewController {
    
    let countryKit = CountryKit()
    
    let hStackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.spacing = 3
        sv.distribution = .fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let vStackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        sv.alignment = .fill
        sv.distribution = .fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "WhatsAppLogo")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let countryCode : UITextField = {
        let tf = UITextField()
        tf.placeholder = "+1"
        tf.backgroundColor = UIColor(hexString: "FAFAFA")
        tf.layer.borderColor = UIColor(hexString: "EFEFEF")?.cgColor
        tf.layer.borderWidth = 1
        tf.textAlignment = .left
        tf.keyboardType = .numberPad
        tf.addPaddingLeft(15)
        tf.layer.cornerRadius = 4
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let mobileNumber : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "Mobile Number"
        tf.backgroundColor = UIColor(hexString: "FAFAFA")
        tf.layer.borderColor = UIColor(hexString: "EFEFEF")?.cgColor
        tf.layer.borderWidth = 1
        tf.keyboardType = .numberPad
        tf.textAlignment = .left
        tf.addPaddingLeft(15)
        tf.layer.cornerRadius = 4
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var sendButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Open Direct Chat", for: UIControlState.normal)
        btn.backgroundColor = UIColor(hexString: "128C7E")
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(createMessage), for: UIControlEvents.touchUpInside)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUICompnents()
        let country = countryKit.current?.countryCode
        if let countryCd = country?.string {
            countryCode.text = "+\(countryCd)"
        }
        
        view.backgroundColor = UIColor(hexString: "ECE5DD")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        KeyboardAvoiding.avoidingView = self.vStackView
    }
    
    private func setupUICompnents() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        view.addSubview(vStackView)
        vStackView.addArrangedSubview(imageView)
        vStackView.addArrangedSubview(hStackView)
        hStackView.addArrangedSubview(countryCode)
        hStackView.addArrangedSubview(mobileNumber)
        vStackView.addArrangedSubview(sendButton)
        
        vStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        vStackView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        imageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        hStackView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 50, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        countryCode.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 38)
        mobileNumber.anchor(top: nil, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 38)
        sendButton.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 55)
    }

    
    @objc func createMessage() {
        
        var formattedNumber : String = ""
        
        if self.mobileNumber.text?.first == "0" {
            formattedNumber = (self.mobileNumber.text?.removingPrefix("0"))!
        } else {
            formattedNumber = self.mobileNumber.text!
        }
        
//        let message = "".addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
//        let whatsappDeeplink = "whatsapp://send?text=\(String(describing: message))&phone=+\(String(describing: formattedNumber))"
        
        if !self.mobileNumber.isEmpty {
            let whatsappHooks = "whatsapp://send?text=&phone=+\(String(describing: countryCode.text! + formattedNumber))"
            let whatsAppUrl = URL(string: whatsappHooks)
            if UIApplication.shared.canOpenURL(whatsAppUrl! as URL)
            {
                UIApplication.shared.open(whatsAppUrl!)
                
            } else {
                //redirect to safari because the user doesn't have Instagram
                print("App not installed")
                showAlert(title: "Whatsapp Requiered", message: "Whatsapp is not installed on this device.")
            }
        } else {
            showAlert(title: "Mobile Requiered", message: "Mobile Number is Requiered.")
        }
        
        
        
    }
    
    @objc private func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        mobileNumber.resignFirstResponder()
        countryCode.resignFirstResponder()
    }


}

