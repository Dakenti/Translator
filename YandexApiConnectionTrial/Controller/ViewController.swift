//
//  ViewController.swift
//  YandexApiConnectionTrial
//
//  Created by Dake Aga on 9/27/18.
//  Copyright © 2018 Dake Aga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class ViewController: UIViewController, UITextViewDelegate {
    
    let BASE_URL = "https://translate.yandex.net/api/v1.5/tr.json/translate"
    let API_KEY = "trnsl.1.1.20180927T064550Z.8645ed7ba4eb1fe4.17e0b7cd83388796036fef6f2e8009f79f6fcd20"
    
    var firstButtonTitle = "English"
    var secondButtonTitle = "Russian"
    
    var languageFromButtonWasPressed: Bool?
    var languageFromTranslate = "en"
    var languageToTranslate = "ru"
    lazy var languagesToBeTranslated = "\(languageFromTranslate)-\(languageToTranslate)"
    
    var flagToSwapLanguages = false
    
    var tupledArray = [TupledArray]()
    
    @IBOutlet weak var LanguageFromButton: UIButton!
    @IBOutlet weak var LanguageToButton: UIButton!
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBAction func languageFromButtonWasPressed(_ sender: UIButton) {
        languageFromButtonWasPressed = true
    }
    
    @IBOutlet weak var TextViewFrom: UITextView!
    @IBOutlet weak var TextViewTo: UITextView!
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    
    
    func getTranslatedText(url: String, parameters:[String:String]){
        
        Alamofire.request(BASE_URL, method: .post, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess{
                let text: JSON = JSON(response.result.value!)
                self.TextViewTo.text = text["text"][0].stringValue
                self.SaveButton.isEnabled = true
            }else{
                print("Error \(String(describing: response.result.error))")
            }
        }
        
    }
    
    @IBAction func swapLanguages(_ sender: UIButton) {
        languagesToBeTranslated = !flagToSwapLanguages ? "\(languageToTranslate)-\(languageFromTranslate)" : "\(languageFromTranslate)-\(languageToTranslate)"
        LanguageFromButton.setTitle(!flagToSwapLanguages ? secondButtonTitle : firstButtonTitle, for: .normal)
        LanguageToButton.setTitle(!flagToSwapLanguages ? firstButtonTitle : secondButtonTitle, for: .normal)
        flagToSwapLanguages = !flagToSwapLanguages
    }
    
    @IBAction func translate(_ sender: UIButton) {
        let text = TextViewFrom.text
        let params: [String:String] = ["key" : API_KEY, "text": text!, "lang": languagesToBeTranslated]
        getTranslatedText(url: BASE_URL, parameters: params)
    }
    
    @IBAction func saveTranslation(_ sender: UIButton) {
        let tuple = TupledArray(context: PersistenceService.context)
        tuple.enteredTextLanguage = languageFromTranslate
        tuple.enteredText = TextViewFrom.text!
        tuple.outputTextLanguage = languageToTranslate
        tuple.outputText = TextViewTo.text!
        tupledArray.append(tuple)
        print("saveTranslation")
//        tupledArray += [(languageFromTranslate, TextViewFrom.text!,languageToTranslate, TextViewTo.text!)]
        TextViewFrom.text = "Write Here To Translate"
        TextViewTo.text = "Wait Here For Translation"
        SaveButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TranslationSaved"{
            let savedTranslationTVC = segue.destination as! SavedTranslationTableViewController
            savedTranslationTVC.delegate = self
            savedTranslationTVC.tupledArrayFromVC = tupledArray
            savedTranslationTVC.title = "Saved Translations"
        } else {
            let languageTVC = segue.destination as! LanguagesTableViewController
            languageTVC.delegate = self
            if let buttonPressed = sender as? UIButton {
                if buttonPressed.currentTitle == firstButtonTitle {
                    languageTVC.title = "Translate From Language"
                } else {
                    languageTVC.title = "Translate To Language"
                }
            }
        }
    }
}

extension ViewController: SelectedLanguageName, SyncronizeSavedTranslations{
    func selectedLanguage(abrivation: String, name: String) {
        if languageFromButtonWasPressed!{
            LanguageFromButton.setTitle(name, for: .normal)
            firstButtonTitle = name
            languageFromTranslate = abrivation
        } else {
            LanguageToButton.setTitle(name, for: .normal)
            secondButtonTitle = name
            languageToTranslate = abrivation
        }
        languagesToBeTranslated = "\(languageFromTranslate)-\(languageToTranslate)"
    }
    
    func keepTupledArrayUpdated(tupledArray: [TupledArray]) {
        self.tupledArray = tupledArray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        languageFromButtonWasPressed = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<TupledArray> = TupledArray.fetchRequest()
        do{
            let tupledArray = try PersistenceService.context.fetch(fetchRequest)
            self.tupledArray = tupledArray
            print("fetched")
        } catch {
            print("could not fetch")
        }
        
//        let fetchToDeleteAll = NSFetchRequest<NSFetchRequestResult>(entityName: "TupledArray")
//        let request = NSBatchDeleteRequest(fetchRequest: fetchToDeleteAll)
//        
//        do{
//            try PersistenceService.context.execute(request)
//            PersistenceService.saveContext()
//            print("deleted")
//        } catch {
//            print("could not delete")
//        }
        
        TextViewFrom.delegate = self
        SaveButton.isEnabled = false
    }
}





