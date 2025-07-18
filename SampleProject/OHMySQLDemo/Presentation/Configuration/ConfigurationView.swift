//
//  Copyright (c) 2022-Present Oleg Hnidets
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI

struct ConfigurationView:View 
{

    @ObservedObject var viewModel:ConfigurationViewModel = ConfigurationViewModel()
    
    var body:some View 
    {

        VStack(spacing:20) 
        {
            TextField("User",        text:$viewModel.username)
            TextField("Password",    text:$viewModel.password)
            TextField("Server name", text:$viewModel.serverName)
            TextField("Port",        text:$viewModel.port)
            TextField("Database",    text:$viewModel.database)
            TextField("Socket",      text:$viewModel.socket)
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)
        .textCase(.lowercase)
        .padding()
        .onAppear { viewModel.viewLoaded() }
        
    }

}

struct ConfigurationView_Previews:PreviewProvider
{
    static var previews:some View 
    {
        ConfigurationView()
    }
}

