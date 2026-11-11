import Foundation

extension Skill {
    var iconName: String {
        let name = name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
        let icons: [(String, [String])] = [
            ("location.north", ["navigation", "orienteer", "map reading", "compass", "cartograph"]),
            ("camera", ["photograph", "camera", "film", "video"]),
            ("guitars", ["guitar", "ukulele", "banjo"]),
            ("pianokeys", ["piano", "keyboard"]),
            ("music.mic", ["sing", "vocal"]),
            ("music.note", ["music", "drum", "violin", "cello", "flute"]),
            ("paintbrush.pointed", ["paint", "draw", "illustrat", "sketch", "fine art", "visual art"]),
            ("fork.knife", ["cook", "bake", "bread", "pastry", "culinary"]),
            ("leaf", ["garden", "plant", "botan", "horticultur"]),
            ("hammer", ["woodwork", "carpentry", "joinery", "furniture"]),
            ("scissors", ["sew", "knit", "crochet", "tailor"]),
            ("water.waves", ["swim", "surf", "diving", "kayak"]),
            ("sailboat", ["sail", "boat"]),
            ("figure.run", ["run", "jog", "athletic"]),
            ("bicycle", ["cycl", "bik"]),
            ("mountain.2", ["hike", "hiking", "climb", "mountain"]),
            ("figure.dance", ["danc", "ballet"]),
            ("figure.mind.and.body", ["yoga", "meditat", "pilates"]),
            ("chevron.left.forwardslash.chevron.right", ["cod", "program", "swift", "python", "software"]),
            ("bubble.left.and.bubble.right", ["language", "french", "spanish", "japanese", "mandarin", "speaking"]),
            ("pencil.and.outline", ["writ", "poetry", "calligraph"]),
            ("cup.and.saucer", ["coffee", "barista", "tea"]),
            ("hand.raised", ["pottery", "ceramic", "sculpt"]),
            ("checkerboard.rectangle", ["chess"])
        ]
        return icons.first { $0.1.contains { name.contains($0) } }?.0 ?? "book.closed"
    }
}
