import Foundation
import MintKit
import PathKit
import Rainbow
import SwiftCLI

public class MintCLI {

    public let version = "0.18.0"

    let mint: Mint
    let cli: CLI

    public init() {

        var mintPath: Path = "~/.mint"
        var linkPath: Path = "~/.mint/bin"

        if let path = ProcessInfo.processInfo.environment["MINT_PATH"], !path.isEmpty {
            mintPath = Path(path)
        }
        if let path = ProcessInfo.processInfo.environment["MINT_LINK_PATH"], !path.isEmpty {
            linkPath = Path(path)
        }

        mint = Mint(path: mintPath, linkPath: linkPath)

        cli = CLI(name: "mint", version: version, description: "Run and install Swift Package Manager executables", commands: [
            RunCommand(mint: mint),
            InstallCommand(mint: mint),
            UninstallCommand(mint: mint),
            ListCommand(mint: mint),
            BootstrapCommand(mint: mint),
            WhichCommand(mint: mint),
            OutdatedCommand(mint: mint),
        ])
    }

    public func execute(arguments: [String]? = nil) {
        let status: Int32
        if let arguments = arguments {
            status = cli.go(with: arguments)
        } else {
            status = cli.go()
        }
        exit(status)
    }
}

extension MintError: ProcessError {

    public var message: String? {
        "🌱  \(description.red)"
    }

    public var exitStatus: Int32 { 1 }
}
