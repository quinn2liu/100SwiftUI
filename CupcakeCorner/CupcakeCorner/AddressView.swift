//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Quinn Liu on 7/27/24.
//

import SwiftUI

struct AddressView: View {
    
    // we're not making the instance of order here, this is just binding the order to the one that's passed in.
    @Bindable var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            
            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
            }
            .disabled(order.hasValidAddress == false)
        }
    }
}

#Preview {
    AddressView(order: Order())
}
