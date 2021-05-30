import SwiftUI

struct EditServiceView: View {
    private let serviceModel: ServiceModel
    private let editServiceModelView: EditServiceModelView
    
    init(serviceModel: ServiceModel, editServiceModelView: EditServiceModelView) {
        self.serviceModel = serviceModel
        self.editServiceModelView = editServiceModelView
    }
    
    var body: some View {
        Image(uiImage: serviceModel.image).resizable().aspectRatio(contentMode: .fit).scaledToFit()

        Spacer()
        
        Button(action: {
                                                
        }){
            Text("Activate")
        }
        .padding(10)
        .foregroundColor(.white)
        .background(Color.green)
        .cornerRadius(5)
        
        Spacer()
    }
}
