//
//  CodeViewModel.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/06/09.
//

import Foundation
import UIKit

struct ConnectionManager {
    static let shared = ConnectionManager()
    
    private let code: String = ""
    private let codeManager: CodeManager = CodeManager()
    
    private init() { } // 생성 금지.
    
    func connectWithPartner(partnerCode: String) async throws {
        // partnerCode를 본인의 코드로 입력했는지 확인
        guard partnerCode != codeManager.getCode() else {
            throw ConnectionManagerResultType.callMySelf
        }
        
        // partnerCode가 존재하는지부터 확인
        guard await codeManager.isExistingCode(code: partnerCode) else {
            throw ConnectionManagerResultType.invalidPartnerCode
        }
        
        let ownCode: String = codeManager.getCode()
        
        guard let ownId: String = codeManager.getId(with: ownCode) else { return }
        guard let partnerId: String = codeManager.getId(with: partnerCode) else { return }
        
        codeManager.updatePartnerCode(oneId: ownId, anotherCode: partnerCode)
        codeManager.updatePartnerCode(oneId: partnerId, anotherCode: ownCode)
        UserDefaults.standard.set(partnerCode, forKey: "partner_code")
        throw ConnectionManagerResultType.success
    }
    
    func disconnectPartner(completion: @escaping (Bool) -> Void) {
        
        codeManager.deletePartnerCode(with: codeManager.getPartnerCode()) { _ in
            codeManager.deletePartnerCode(with: codeManager.getCode()) { _ in
                if let _ = UserDefaults.standard.string(forKey: "partner_code") {
                    UserDefaults.standard.removeObject(forKey: "partner_code")
                    
                }
            }
        }
        completion(true)
    }
}

enum ConnectionManagerResultType: Error {
    case success
    case callMySelf // 자신의 코드를 불러오는 경우
    case invalidPartnerCode // 일치하는 파트너 코드가 없는 경우
}


