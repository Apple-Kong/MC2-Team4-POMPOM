//
//  CodeViewModel.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import Foundation

struct CodeManager {
    private let code: String = ""
    private let connectionManager: ConnectionManager = ConnectionManager()
    
    @discardableResult
    func getCode() -> String {
        // UserDefaults에 이미 code가 있을 때
        if let defaultCode: String = UserDefaults.standard.string(forKey: "code") {
            return defaultCode
        }
        // UserDefaults에 code가 없을 때
        else {
//            let newCode = await setNewCode()
            let newCode = generateCode(length: 10)
            DispatchQueue.global().async {
                connectionManager.saveCode(code: newCode)
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
        } while await connectionManager.isExistingCode(code: newCode)
        
        return newCode
    }
    
    // 길이가 length고, 숫자와 영문 대문자로만 이뤄진 코드 생성 및 반환
    private func generateCode(length: Int) -> String {
        let elements = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0 ..< length).map { _ in elements.randomElement()! })
    }
    
    func connectWithPartner(partnerCode: String) async throws {
        // partnerCode가 존재하는지부터 확인
        guard await connectionManager.isExistingCode(code: partnerCode) else {
            throw ConnectionManagerError.invalidPartnerCode
        }
        
        let ownCode: String = getCode()
        
        let ownId: String = await connectionManager.getIdByCode(code: ownCode)
        let partnerId: String = await connectionManager.getIdByCode(code: partnerCode)
        
        connectionManager.updatePartnerCode(oneId: ownId, anotherCode: partnerCode)
        connectionManager.updatePartnerCode(oneId: partnerId, anotherCode: ownCode)
    }
}

enum ConnectionManagerError: Error {
    case invalidPartnerCode // 일치하는 파트너 코드가 없는 경우
}
