//
//  ViewController.swift
//  Messenger
//
//  Created by Siddique on 10/02/18.
//  Copyright © 2018 Siddique. All rights reserved.
//

import UIKit

class FriendViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Recent"
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        setupData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        if let message = messages?[indexPath.item]{
            cell.message = message
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controller = ChatLogViewController(collectionViewLayout: layout)
        controller.friend = messages?[indexPath.item].friend
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

class MessageCell: BaseCell {
    var message: Message? {
        didSet {
            nameLabel.text = message?.friend?.name
            messageLabel.text = message?.text
            if let profile = message?.friend?.profileImageName {
                profileImageView.image = UIImage(named: profile)
                hasReadMessage.image = UIImage(named: profile)
            }
            if let date = message?.time {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                timeLabel.text = dateFormatter.string(from: date as Date)
            }
            //            if let user = message?.friend?.profileImageName {
            //                hasReadMessage.image = UIImage(named: user)
            //            }
        }
    }
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckprofile")
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let dividerLine: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return divider
    }()
    let nameLabel: UILabel = {
        let name = UILabel()
        name.text = "Friend Name"
        name.textColor = UIColor.black
        name.font = UIFont.systemFont(ofSize: 18)
        return name
    }()
    let messageLabel: UILabel = {
        let message = UILabel()
        message.text = "Message send by your friend"
        message.font = UIFont.systemFont(ofSize: 14)
        message.textColor = UIColor.gray
        return message
    }()
    let timeLabel: UILabel = {
        let name = UILabel()
        name.text = "12:00 PM"
        name.textColor = UIColor.black
        name.font = UIFont.systemFont(ofSize: 14)
        name.textAlignment = .right
        return name
    }()
    let hasReadMessage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckprofile")
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override func setUpView() {
        addSubview(profileImageView)
        addSubview(dividerLine)
        
        setupContainerView()
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintwithFormat("H:|-12-[v0(68)]", profileImageView)
        addConstraintwithFormat("V:|-12-[v0(68)]", profileImageView)
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraintwithFormat("H:|-82-[v0]|", dividerLine)
        addConstraintwithFormat("V:[v0(1)]|", dividerLine)
        
    }
    private func setupContainerView(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadMessage)
        addConstraintwithFormat("H:|-90-[v0]|", containerView)
        addConstraintwithFormat("V:[v0(50)]", containerView)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraintwithFormat("H:|[v0][v1(80)]-12-|", nameLabel, timeLabel)
        addConstraintwithFormat("V:|[v0][v1(24)]|", nameLabel, messageLabel)
        addConstraintwithFormat("H:|[v0]-8-[v1(20)]-20-|", messageLabel, hasReadMessage)
        addConstraintwithFormat("V:|[v0(20)]", timeLabel)
        addConstraintwithFormat("V:[v0(20)]|", hasReadMessage)
        
    }
}
extension UIView {
    func addConstraintwithFormat(_ format: String,_ views: UIView...) {
        var viewDictionary = [String : UIView]()
        for(index, view) in views.enumerated(){
            let key = "v\(index)"
            viewDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(frame: ) has not been implemented")
    }
    func setUpView(){
        backgroundColor = UIColor.blue
    }
}

