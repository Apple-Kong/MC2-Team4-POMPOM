//
//  ConnectionManager.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import Foundation
import FirebaseFirestore

struct CodeManager {
    let usersRef = Firestore.firestore().collection("users")
    
    func isExistingCode(code: String) async -> Bool {
        var returnValue: Bool = false
        
        do {
            let querySnapShot = try await usersRef.whereField("code", isEqualTo: code).getDocuments()
            returnValue = querySnapShot.isEmpty ? false : true
        } catch { }
        
        return returnValue
    }
    
    @discardableResult
    func getCode() -> String {
        if let defaultCode: String = UserDefaults.standard.string(forKey: "code") {
            // UserDefaults에 이미 code가 있을 때
            return defaultCode
        } else {
            // UserDefaults에 code가 없을 때
            let newCode = generateCode(length: 10)
            DispatchQueue.global().async {
                saveCode(code: newCode)
            }
            UserDefaults.standard.set(newCode, forKey: "code")
            print("DEUBG: 코드 생성 완료 - \(newCode)")
            return newCode
        }
    }
    
    func setNewCode() async -> String {
        var newCode: String = ""
        repeat {
            newCode = generateCode(length: 10)
        } while await isExistingCode(code: newCode)
        
        return newCode
    }
    
    func getPartnerCode() -> String {
        // UserDefaults에 partner_code가 있을 때
        if let partnerCode: String = UserDefaults.standard.string(forKey: "partner_code") {
            return partnerCode
        }
        // UserDefaults에 partner_code가 없을 때
        else {
            return ""
        }
    }
    
    func addListnerToPartnerCode(completion: @escaping (Result<Bool, Error>) -> Void) async {
        guard let ID = getId(with: getCode()) else { return }
        
        usersRef.document(ID).addSnapshotListener { snapShot, err in
                if let err = err {
                    completion(.failure(err))
                } else {
                    guard let data = snapShot?.data()?["partner_code"] as? String else {
                        completion(.success(true))
                        return
                    }
                    
                    if data != " "  && data != "" {
                        completion(.success(true))
                    } else {
                        completion(.success(false))
                    }
                    UserDefaults.standard.set(data, forKey: "partner_code")
                }
            }
    }
    
    
    func saveCode(code: String) {
        usersRef.addDocument(data: [
            "code": code,
            "partner_code": ""
        ]) { err in
            if let err = err {
                dump("Error adding users 아래 문서: \(err)")
                print("DEBUG: ConnectionManager - \(err.localizedDescription)")
            }
        }
    }
    
    func updatePartnerCode(oneId: String, anotherCode: String) {
        usersRef.document(oneId).updateData([
            "partner_code": anotherCode
        ]) { err in
            if let err = err {
                print("DEBUG: ConnectionManager - \(err)")
            }
        }
    }
    

    
    //Code 로 User ID를 불러오는 메서드.
    func getId(with code: String) -> String? {
        var ID: String?
        usersRef.whereField("code", isEqualTo: code).getDocuments { querySnapshot, error in
            if error == nil {
                if let idFromServer = querySnapshot?.documents[0].documentID {
                    ID = idFromServer
                }
            }
        }
        return ID
    }
    
    func deletePartnerCode(with code: String, completion: @escaping (Error?) -> Void) {
        guard let ID = getId(with: code) else { return }
        
        usersRef.document(ID).updateData(["partner_code": " "])  { error in
            completion(error)
        }
    }
    
    //MARK: - Private Helpers
    
    // 길이가 length고, 숫자와 영문 대문자로만 이뤄진 코드 생성 및 반환
    private func generateCode(length: Int) -> String {
        let elements = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0 ..< length).map { _ in elements.randomElement()! })
    }
}
