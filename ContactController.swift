//
//  ContactController.swift
//  InnoCrux
//
//  Created by sakthi on 18/08/22.
//
struct Contacts{
    var givenName: String
    var familyName:String
    var number: String
    var email: String
    var imageData: String
}


//controller
import UIKit
import Contacts
import CoreData
import ContactsUI

class ContactController: UIViewController, CNContactPickerDelegate  {

    var contactStore = CNContactStore()
    var contacts = [Contacts]()
    let defImage: UIImage = UIImage(named: "noImageIcon")!
    var image: UIImage?
    var imageAssect = ["kate","daniel","jhon","anna","hank","david","donaldTrump","parthiban","sundhar","dhanushKRaja","cheran"]
    var countid: Int = 0
    var contactUser: [NSManagedObject] = []

    
    //GET CONTEXT
    func getcontext() -> NSManagedObjectContext {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        return appdelegate.persistentContainer.viewContext
    }

    
    @IBOutlet weak var contactListView: UITableView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactListView.delegate = self
        contactListView.dataSource = self
        contactListView.separatorColor = .clear
        self.contactListView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        
        contactStore.requestAccess(for: .contacts){(success, error)in

            if success{
//                print("success")
                self.fetchContacts()
                self.saverecord()
            }
        }
    }
    
    func fetchContacts(){
        
        let contactVC = CNContactPickerViewController()
        contactVC.delegate = self
        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey, CNContactEmailAddressesKey]
        let request = CNContactFetchRequest(keysToFetch: key as! [CNKeyDescriptor])
        
      try! contactStore.enumerateContacts(with: request) { (contact, stopingPoint) in
          let name = contact.givenName
          let familyName = contact.familyName
          let number = contact.phoneNumbers.first?.value.stringValue
          let emailAddress = contact.emailAddresses.first?.value ?? ""
          let contactProperty = CNContactProperty()
          let contact = contactProperty.contact
          let contactImage = contact.imageData
          if let go = contactImage {
              self.image = UIImage(data: go)
          }
          let imageStringData = self.convertImageToBase64(image: self.image ?? self.defImage)
          let letAppend = Contacts(givenName: name, familyName: familyName, number: number!, email: emailAddress as String, imageData: imageStringData)
                        self.contacts.append(letAppend)
        }
        contactListView.reloadData()
        for list in contacts{
            print(list.givenName + " " + list.familyName)
            print(list.number)
            print(list.email)
        }
    }
    
    
    //SAVE CONTACTS
    func saverecord() {
        let context  = getcontext()
        let entity = NSEntityDescription.entity(forEntityName: "ContactsInfo", in: context)
        let newuser = NSManagedObject(entity: entity!, insertInto: context)
        countid = countid+1
        newuser.setValue(contacts.first?.givenName, forKey: "givenName")
        newuser.setValue(contacts.first?.familyName, forKey: "familyName")
        newuser.setValue(contacts.first?.number, forKey: "phone")
        newuser.setValue(contacts.first?.email, forKey: "email")
        newuser.setValue(contacts.first?.imageData, forKey: "image")
        print("countid")
        do{
            try context.save()
            print("Saved")
        }catch{
            print("ERROR: Failed")
        }
    }
    
    func convertImageToBase64(image: UIImage) -> String {
            let imageData = image.pngData()!
            return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        }
        
        func convertBase64ToImage(imageString: String) -> UIImage {
            let imageData = Data(base64Encoded: imageString,
                                 options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
            return UIImage(data: imageData)!
        }


}

extension ContactController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        contacts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = contactListView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        
        let contactToCell = contacts[indexPath.row]
        
        cell.contactName.text = "\(contactToCell.givenName + " " + contactToCell.familyName)"
        cell.contactNumber.text = contactToCell.number
//        cell.contactImage.image = UIImage(named: contactToCell.imageData)
        
        let contactImage = contactToCell.imageData
        cell.contactImage.image = UIImage(named: imageAssect[indexPath.row])
        cell.contactImage.contentMode = .scaleAspectFit
        
//        cell.contactImage.image = convertBase64ToImage(imageString: contactToCell.imageData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactListView.deselectRow(at: indexPath, animated: true)
       
        let updatevc: DetailContactController = self.storyboard?.instantiateViewController(identifier: "DetailContactController")as! DetailContactController
        let contactToCell = contacts[indexPath.row]
        updatevc.contactName = "NAME: \(contactToCell.givenName + " " + contactToCell.familyName)"
        updatevc.contactNumber = "PHONE: \(contactToCell.number)"
        
        var contactImage : UIImage = UIImage(named:imageAssect[indexPath.row])!
        updatevc.contactImage = contactImage
        
        updatevc.contactMail = "E-Mail: \(contactToCell.email)"
        
        self.present(updatevc, animated: true, completion: nil)
    }
}
