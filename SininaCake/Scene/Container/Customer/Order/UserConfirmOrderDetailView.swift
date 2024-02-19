//
//  UserConfirmOrderDetailView.swift
//  SininaCake
//
//  Created by 이종원 on 2/18/24.
//

import SwiftUI

struct UserConfirmOrderDetailView: View {
    
    @EnvironmentObject var path: Path
    @ObservedObject var orderVM: OrderViewModel
    
    var body: some View {
        VStack {
            UserDetailView(orderItem: orderVM.orderItem)
            
            CustomButton(action: {
                orderVM.addOrderItem()
                path.reset()},
                         title: "주문서 보내기",
                         titleColor: .white,
                         backgroundColor: .customBlue, leading: 12, trailing: 12)
        }
    }
}


#Preview {
    UserConfirmOrderDetailView(orderVM: OrderViewModel(orderItem: OrderItem(id: UUID().uuidString, email: "", date: Date(), orderTime: Date(), cakeSize: "도시락", sheet: "바닐라 시트", cream: "크림치즈 \n프로스팅", icePack: .none, name: "", phoneNumber: "", text: "", imageURL: [], comment: "", expectedPrice: 0, confirmedPrice: 0, status: .notAssign)))
}
