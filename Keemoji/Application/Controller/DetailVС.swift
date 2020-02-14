//
//  DetailViewController.swift
//  Keemoji
//
//  Created by Alexander on 12.02.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import UIKit

class DetailVС: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var orderNowLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var dishTitle: (UIImage?, String, String, Int) = (nil , "", "", 0)
    var sum = Order.shared.cost
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = dishTitle.0
        titleLabel.text = dishTitle.1
        descriptionLabel.text = dishTitle.2
        costLabel.text = "\(String(dishTitle.3)) руб."
        countLabel.text = "Кол-во: \(Int(stepper.value))"
        orderNowLabel.text = "Ваш заказ: \(Order.shared.cost)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Order.shared.cost = sum
    }
    
    @IBAction func orderTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "Заказать", message: "Сделать заказ сейчас?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            guard self.sum != 0 else { print("RETURN")
                return }
            self.sum = 0
            
            self.stepper.value = 0
            self.countLabel.text = "Кол-во: \(Int(self.stepper.value))"
            self.orderNowLabel.text = "Ваш заказ: \(0)"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(ok)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
    
    @IBAction func stepperTapped(_ sender: UIStepper) {
        
        countLabel.text = "Кол-во: \(Int(sender.value))"
        
        guard var countString = self.countLabel.text else { return }
        countString.removeFirst(8)
        guard let count = Int(countString) else { return }
        print("Count: \(count)")
        
        sum = Order.shared.cost + self.dishTitle.3 * count
        orderNowLabel.text = "Ваш заказ: \(sum)"
        print("Order now: \(sum)")
    }
}
