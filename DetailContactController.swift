//
//  DetailContactController.swift
//  InnoCrux
//
//  Created by sakthi on 18/08/22.
//

import UIKit

class DetailContactController: UIViewController {
    @IBOutlet weak var imageInContact: UIImageView!
    @IBOutlet weak var nameInContact: UILabel!
    @IBOutlet weak var numberInContact: UILabel!
    @IBOutlet weak var mailInContact: UILabel!
    
    
    var contactImage = UIImage()
    var contactName = ""
    var contactNumber = ""
    var contactMail = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageInContact.image = contactImage
        nameInContact.text = contactName
        numberInContact.text = contactNumber
        mailInContact.text = contactMail
        imageInContact.contentMode = .scaleAspectFit
        
        
        nameInContact.textColor = .white
        numberInContact.textColor = .white
        mailInContact.textColor = .white// Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
