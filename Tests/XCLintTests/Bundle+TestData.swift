import Foundation
import Testing

extension Bundle {
	func testDataURL(named: String) throws -> URL {
		let bundle = Bundle.module

		let resourceURL = try #require(bundle.resourceURL)

		return resourceURL
			.appendingPathComponent("TestData", isDirectory: true)
			.appendingPathComponent(named)
			.standardizedFileURL
	}
}
