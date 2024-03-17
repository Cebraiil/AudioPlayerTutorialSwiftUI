//
//  ContentView.swift
//  AudioPlayerTutorial
//
//  Created by Eymen on 6.08.2023.
//

import SwiftUI
import AVKit

struct ContentView: View {
    let audioFileName = "bird"
    
    @State private var player: AVAudioPlayer?
    
    @State private var isPlaying = false
    @State private var totalTime: TimeInterval = 0.0
    @State private var currentTime: TimeInterval = 0.0

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            
            VStack(spacing: 20) {
                Text("Bird Sound")
                    .font(.title)
                
                VStack(spacing: 20){
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.largeTitle)
                        .onTapGesture {
                            isPlaying ? stopAudio() : playAudio()
                        }
                    Slider(value: Binding(get: {
                       currentTime
                   }, set: { newValue in
                       seekAudio(to: newValue)
                   }), in: 0...totalTime)
                   .accentColor(.white)
                    HStack {
                       Text(timeString(time: currentTime))
                           .foregroundColor(.white)
                       Spacer()
                       Text(timeString(time: totalTime))
                           .foregroundColor(.white)
                   }
                   .padding(.horizontal)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            }
            .foregroundColor(.white)
        }
        .onAppear(perform: setupAudio)
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            updateProgress()
        }
    }
    
    private func setupAudio() {
        guard let url = Bundle.main.url(forResource: audioFileName, withExtension: "mp3") else {
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            totalTime = player?.duration ?? 0.0
        } catch {
            print("Error loading audio: \(error)")
        }
    }
    
    private func playAudio(){
        player?.play()
        isPlaying = true
    }
    
    private func stopAudio(){
        player?.pause()
        isPlaying = false
    }
    
    private func updateProgress() {
       guard let player = player else { return }
       currentTime = player.currentTime
   }
    
    private func seekAudio(to time: TimeInterval) {
        player?.currentTime = time
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
