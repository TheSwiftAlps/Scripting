#!/usr/bin/swift

// Swift Alps 2016 - Swift Scripting 
// @ikhsan & @kaalita. mentor: @marmelroy

import Foundation

struct Artist {
    let name: String
    let emoji: String
    let uri: String
}

let artists = [
    Artist(name: "Arctic Monkeys", emoji: "❄️ 🐒 🐒", uri: "spotify:track:3jfr0TF6DQcOLat8gGn7E2"),
    Artist(name: "Radiohead", emoji: "📻 👤", uri: "spotify:track:3SVAN3BRByDmHOhKyIDxfC"),
    Artist(name: "ZZ Top", emoji: "💤🎩", uri: "spotify:track:1UBQ5GK8JaQjm5VbkBZY66"),
]

func play(_ artist: Artist) {
    let script = NSAppleScript(source: "tell application \"Spotify\" to play track \"\(artist.uri)\"")
    script?.executeAndReturnError(nil)
}

print("Welcome to 🤓 Band Quiz!")
print("Can you guess the band?")


let i = arc4random_uniform(UInt32(artists.count))
let question = artists[Int(i)]

print(question.emoji)
let answer1 = readLine() ?? ""
if answer1.lowercased() == question.name.lowercased()
{
    print("YEAH, you rock!")
    play(question)
}
else
{
    print("D'Oh, try again.")
}