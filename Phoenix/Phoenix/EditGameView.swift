//
//  EditGameView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2022-12-28.
//
import Foundation
import SwiftUI

struct EditGameView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var currentGame: Game

    @State private var nameInput: String = ""
    @State private var iconInput: String = ""
    @State private var iconOutput: String = ""
    @State private var platInput: Platform = .NONE
    @State private var cmdInput: String = ""
    @State private var descInput: String = ""
    @State private var headInput: String = ""
    @State private var headOutput: String = ""
    @State private var rateInput: String = ""
    @State private var genreInput: String = ""
    @State private var devInput: String = ""
    @State private var pubInput: String = ""
    @State private var dateInput: Date = .now

    @State private var iconIsImporting: Bool = false
    @State private var headIsImporting: Bool = false

    var body: some View {
        ScrollView {
            Text(
                "Editing \(currentGame.name). Only enter information in the fields you wish to change"
            )
            .fontWeight(.bold)
            .padding()

            VStack(alignment: .leading) {
                HStack {
                    Text("Name")
                        .frame(width: 70, alignment: .leading)

                    TextField("Enter game name", text: $nameInput)
                        .padding()
                        .accessibility(label: Text("NameInput"))
                    Text(
                        "Required. This is the name that will show up in the sidebar and in the title bar"
                    )
                    .frame(width: 300)
                }

                HStack {
                    Text("Icon")
                        .frame(width: 70, alignment: .leading)
                        .offset(x: -15)
                    Button(
                        action: {
                            iconIsImporting = true

                        },
                        label: {
                            Text("Browse")
                        })
                    Text(iconInput)
                    Spacer()
                    Text("Not required. If no icon is selected, a default icon will be used")
                        .frame(width: 275)
                }
                .padding()
                .fileImporter(
                    isPresented: $iconIsImporting,
                    allowedContentTypes: [.image],
                    allowsMultipleSelection: false
                ) { result in
                    do {
                        let selectedFile: URL = try result.get().first ?? URL(fileURLWithPath: "")
                        iconInput = selectedFile.relativeString

                        let iconData = try Data(contentsOf: selectedFile)

                        var url = FileManager.default.urls(
                            for: .applicationSupportDirectory, in: .userDomainMask)[0]

                        if iconInput.hasSuffix(".jpg") || iconInput.hasSuffix(".jpeg") {
                            url = url.appendingPathComponent(
                                "Phoenix/cachedImages/\(currentGame.name)_icon.jpg",
                                conformingTo: .jpeg)
                        } else if iconInput.hasSuffix(".png") {
                            url = url.appendingPathComponent(
                                "Phoenix/cachedImages/\(currentGame.name)_icon.png",
                                conformingTo: .png)
                        }

                        try iconData.write(to: url)

                        iconOutput = url.relativeString
                    } catch {
                        // Handle failure.
                        logger.write("Unable to read file contents")
                        logger.write(error.localizedDescription)
                    }
                }

                HStack {
                    Picker("Platform          ", selection: $platInput) {
                        ForEach(Platform.allCases) { platform in
                            Text(platform.rawValue)
                        }
                    }
                    Text(
                        "Not required. This is mostly just for sorting purposes in the sidebar. If you do not select a platform the game will still work, it will just go under the 'Other' header"
                    )
                    .frame(width: 300)
                }

                HStack {
                    Text("Command")
                        .frame(width: 70, alignment: .leading)
                    TextField("Enter terminal command to launch game", text: $cmdInput)
                        .padding()
                    Text(
                        "Not required. If no command is entered, the game will show up in the sidebar, but the play button will not do anything"
                    )
                    .frame(width: 300)
                }

                Text("Metadata")
                    .fontWeight(.bold)
                    .font(.system(size: 16))
                Text("None of this is required, but it will make the game's detail page look nicer")
                    .padding()

                HStack {
                    Text("Description")
                        .frame(width: 87, alignment: .leading)
                    TextField("Enter game description", text: $descInput)
                }

                HStack {
                    Text("Header Image")
                        .frame(width: 87, alignment: .leading)
                        .offset(x: -15)
                    Button(
                        action: {
                            headIsImporting = true

                        },
                        label: {
                            Text("Browse")
                        })
                    Text(headInput)
                    Spacer()
                    Text("The banner image to be displayed at the top of the game's detail page")
                        .frame(width: 265)
                }
                .padding()
                .fileImporter(
                    isPresented: $headIsImporting,
                    allowedContentTypes: [.image],
                    allowsMultipleSelection: false
                ) { result in
                    do {
                        let selectedFile: URL =
                            try result.get().first ?? URL(fileURLWithPath: "test")
                        headInput = selectedFile.relativeString

                        let headerData = try Data(contentsOf: selectedFile)

                        var url = FileManager.default.urls(
                            for: .applicationSupportDirectory, in: .userDomainMask)[0]

                        if headInput.hasSuffix(".jpg") || headInput.hasSuffix(".jpeg") {
                            url = url.appendingPathComponent(
                                "Phoenix/cachedImages/\(currentGame.name)_header.jpg",
                                conformingTo: .jpeg)
                        } else if headInput.hasSuffix(".png") {
                            url = url.appendingPathComponent(
                                "Phoenix/cachedImages/\(currentGame.name)_header.png",
                                conformingTo: .png)
                        }

                        try headerData.write(to: url)

                        headOutput = url.relativeString
                    } catch {
                        // Handle failure.
                        logger.write("Unable to read file contents")
                        logger.write(error.localizedDescription)
                    }
                }

                HStack {
                    Text("Rating")
                        .frame(width: 87, alignment: .leading)
                    TextField("X / 10", text: $rateInput)
                    Text("A rating out of 10. Pretty self-explanatory")
                        .frame(width: 300)
                }

                HStack {
                    Text("Genre")
                        .frame(width: 87, alignment: .leading)
                    TextEditor(text: $genreInput)
                    Text(
                        "A list of 3 genres that describe this game. Please write each genre on a new line"
                    )
                    .frame(width: 290)
                }
            }
            .padding()

            VStack(alignment: .leading) {
                HStack {
                    Text("Developer")
                        .frame(width: 87, alignment: .leading)
                    TextField("Enter game developer", text: $devInput)
                }

                HStack {
                    Text("Publisher")
                        .frame(width: 87, alignment: .leading)
                    TextField("Enter game publisher", text: $pubInput)
                }

                HStack {
                    DatePicker(selection: $dateInput, in: ...Date.now, displayedComponents: .date) {
                        Text("Release Date")
                            .frame(width: 87, alignment: .leading)
                    }
                }
            }
            .padding()

            Button(
                action: {
                    var dateInputStr = ""

                    if nameInput == "" {
                        nameInput = currentGame.name
                    }
                    if iconOutput == "" {
                        iconOutput = currentGame.icon
                    }
                    if platInput == .NONE {
                        platInput = currentGame.platform
                    }
                    if cmdInput == "" {
                        cmdInput = currentGame.launcher
                    }
                    if descInput == "" {
                        descInput = currentGame.metadata["description"] ?? ""
                    }
                    if headOutput == "" {
                        headOutput = currentGame.metadata["header_img"] ?? ""
                    }
                    if rateInput == "" {
                        rateInput = currentGame.metadata["rating"] ?? ""
                    }
                    if genreInput == "" {
                        genreInput = currentGame.metadata["genre"] ?? ""
                    }
                    if devInput == "" {
                        devInput = currentGame.metadata["developer"] ?? ""
                    }
                    if pubInput == "" {
                        pubInput = currentGame.metadata["publisher"] ?? ""
                    }
                    if dateInput == .now {
                        dateInputStr = currentGame.metadata["release_date"] ?? ""
                    } else {
                        let dateFormatter: DateFormatter = {
                            let formatter = DateFormatter()
                            formatter.dateStyle = .long
                            return formatter
                        }()

                        dateInputStr = dateFormatter.string(from: dateInput)
                    }

                    let editedGame: Game = .init(
                        launcher: cmdInput,
                        metadata: [
                            "description": descInput,
                            "header_img": headOutput,
                            "time_played": "0 Hours",
                            "last_played": "Today",
                            "rating": rateInput,
                            "genre": genreInput,
                            "developer": devInput,
                            "publisher": pubInput,
                            "release_date": dateInputStr,
                        ],
                        icon: iconOutput,
                        name: nameInput,
                        platform: platInput)

                    let idx = games.firstIndex(where: { $0.name == currentGame.name })
                    games[idx!] = editedGame

                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted

                    do {
                        let gamesJSON = try JSONEncoder().encode(games)

                        if var gamesJSONString = String(data: gamesJSON, encoding: .utf8) {
                            // Add the necessary JSON elements for the string to be recognized as type "Games" on next read
                            gamesJSONString = "{\"games\": \(gamesJSONString)}"
                            writeGamesToJSON(data: gamesJSONString)
                        }
                    } catch {
                        logger.write(error.localizedDescription)
                    }

                    dismiss()
                },
                label: {
                    Text("Save Changes")
                }
            )
            .padding()
        }
        .font(.system(size: 13))
    }
}
