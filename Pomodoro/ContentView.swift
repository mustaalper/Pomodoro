//
//  ContentView.swift
//  Pomodoro
//
//  Created by MAA on 2.09.2022.
//

import SwiftUI
import AVFoundation

struct AppBtn: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(minWidth: 50, maxHeight: 50)
            .font(.title)
            .background(color)
    }
}

extension Button {
    func appBtn(color: Color = .red) -> some View {
        modifier(AppBtn(color: color))
    }
}

struct ContentView: View {
    
    @State var appState = AppState {
        AudioServicesPlaySystemSound(1032)
    }
    
    @State var timer: Timer? = nil
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .purple], startPoint: .center, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 10) {
                Text("25 + 5 Clock")
                    .foregroundColor(.white)
                    .font(.system(size: 50))
                Stepper("\(appState.workMinutes) minutes session", value: $appState.workMinutes, in: 1...99)
                    .disabled(timer != nil)
                    .padding()
                    .background(.white)
                    .foregroundColor(.black)
                    .font(.title)
                Stepper("\(appState.restMinutes) minutes rest", value: $appState.restMinutes, in: 1...99)
                    .disabled(timer != nil)
                    .padding()
                    .background(.white)
                    .font(.title)
                GeometryReader { geo in
                    VStack(spacing: 10) {
                        Text(appState.mode.rawValue)
                            .foregroundColor(.white)
                            .font(.system(size: 50))
                        Text(appState.currentTimeDisplay)
                            .foregroundColor(.white)
                            .font(.system(size: 50))
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .background(.purple)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                }.frame(maxHeight: 150)
                HStack {
                    Button("Start") {
                        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            appState.next()
                        }
                    }.appBtn(color: .green)
                    Button("Stop") {
                        timer?.invalidate()
                        timer = nil
                    }.appBtn(color: .red)
                    Button("Reset") {
                        timer?.invalidate()
                        timer = nil
                        appState.reset()
                    }.appBtn(color: .yellow)
                }
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
