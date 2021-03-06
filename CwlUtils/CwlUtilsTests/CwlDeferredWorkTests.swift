//
//  CwlDeferredWorkTests.swift
//  CwlUtils
//
//  Created by Matt Gallagher on 11/6/16.
//  Copyright © 2016 Matt Gallagher ( http://cocoawithlove.com ). All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
//  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
//  IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//

import Foundation
import XCTest
import CwlUtils
import CwlPreconditionTesting

class DeferredWorkTests: XCTestCase {
	func testDeferredWork() {
		let dw = DeferredWork()
		dw.runWork()
	}

	func testDeferredWorkClosureOnConstruction() {
		var reachedPoint1 = false
		let dw = DeferredWork { reachedPoint1 = true }
		XCTAssert(!reachedPoint1)
		dw.runWork()
		XCTAssert(reachedPoint1)
	}

	func testDeferredWorkAppend() {
		var reachedPoint1 = false
		var reachedPoint2 = false
		var reachedPoint3 = false
		var dw = DeferredWork {
			XCTAssert(!reachedPoint2)
			XCTAssert(!reachedPoint3)
			reachedPoint1 = true
		}
		dw.append {
			XCTAssert(reachedPoint1)
			XCTAssert(!reachedPoint3)
			reachedPoint2 = true
		}
		dw.append {
			XCTAssert(reachedPoint1)
			XCTAssert(reachedPoint2)
			reachedPoint3 = true
		}
		XCTAssert(!reachedPoint1)
		XCTAssert(!reachedPoint2)
		XCTAssert(!reachedPoint3)
		dw.runWork()
		XCTAssert(reachedPoint1)
		XCTAssert(reachedPoint2)
		XCTAssert(reachedPoint3)

		var reachedPoint4 = false
		var dw2 = DeferredWork()
		dw2.append { reachedPoint4 = true }
		XCTAssert(!reachedPoint4)
		dw2.runWork()
		XCTAssert(reachedPoint4)
	}

	func testDeferredWorkAppendOther() {
		do {
			// None plus none
			var dw1 = DeferredWork()
			let dw2 = DeferredWork()
			dw1.append(dw2)
			dw1.runWork()
		}

		do {
			// None plus single
			var reachedPoint2 = false
			var dw1 = DeferredWork()
			let dw2 = DeferredWork { reachedPoint2 = true }
			dw1.append(dw2)
			XCTAssert(!reachedPoint2)
			dw1.runWork()
			XCTAssert(reachedPoint2)
		}

		do {
			// None plus multiple
			var reachedPoint1 = false
			var reachedPoint2 = false
			var dw1 = DeferredWork()
			var dw2 = DeferredWork { reachedPoint2 = true }
			dw2.append { reachedPoint1 = true }
			dw1.append(dw2)
			XCTAssert(!reachedPoint1)
			XCTAssert(!reachedPoint2)
			dw1.runWork()
			XCTAssert(reachedPoint1)
			XCTAssert(reachedPoint2)
		}

		do {
			// Single plus none
			var reachedPoint1 = false
			var dw1 = DeferredWork { reachedPoint1 = true }
			let dw2 = DeferredWork()
			dw1.append(dw2)
			XCTAssert(!reachedPoint1)
			dw1.runWork()
			XCTAssert(reachedPoint1)
		}

		do {
			// Single plus single
			var reachedPoint1 = false
			var reachedPoint2 = false
			var dw1 = DeferredWork { reachedPoint1 = true }
			let dw2 = DeferredWork { reachedPoint2 = true }
			dw1.append(dw2)
			XCTAssert(!reachedPoint1)
			XCTAssert(!reachedPoint2)
			dw1.runWork()
			XCTAssert(reachedPoint1)
			XCTAssert(reachedPoint2)
		}

		do {
			// Single plus multiple
			var reachedPoint1 = false
			var reachedPoint2 = false
			var reachedPoint3 = false
			var dw1 = DeferredWork { reachedPoint1 = true }
			var dw2 = DeferredWork { reachedPoint2 = true }
			dw2.append { reachedPoint3 = true }
			dw1.append(dw2)
			XCTAssert(!reachedPoint1)
			XCTAssert(!reachedPoint2)
			XCTAssert(!reachedPoint3)
			dw1.runWork()
			XCTAssert(reachedPoint1)
			XCTAssert(reachedPoint2)
			XCTAssert(reachedPoint3)
		}

		do {
			// Multiple plus none
			var reachedPoint1 = false
			var reachedPoint2 = false
			var dw1 = DeferredWork { reachedPoint1 = true }
			let dw2 = DeferredWork()
			dw1.append { reachedPoint2 = true }
			dw1.append(dw2)
			XCTAssert(!reachedPoint1)
			XCTAssert(!reachedPoint2)
			dw1.runWork()
			XCTAssert(reachedPoint1)
			XCTAssert(reachedPoint2)
		}

		do {
			// Multiple plus single
			var reachedPoint1 = false
			var reachedPoint2 = false
			var reachedPoint3 = false
			var dw1 = DeferredWork { reachedPoint1 = true }
			let dw2 = DeferredWork { reachedPoint3 = true }
			dw1.append { reachedPoint2 = true }
			dw1.append(dw2)
			XCTAssert(!reachedPoint1)
			XCTAssert(!reachedPoint2)
			XCTAssert(!reachedPoint3)
			dw1.runWork()
			XCTAssert(reachedPoint1)
			XCTAssert(reachedPoint2)
			XCTAssert(reachedPoint3)
		}

		do {
			// Multiple plus multiple
			var reachedPoint1 = false
			var reachedPoint2 = false
			var reachedPoint3 = false
			var reachedPoint4 = false
			var dw1 = DeferredWork { reachedPoint1 = true }
			var dw2 = DeferredWork { reachedPoint3 = true }
			dw1.append { reachedPoint2 = true }
			dw2.append { reachedPoint4 = true }
			dw1.append(dw2)
			XCTAssert(!reachedPoint1)
			XCTAssert(!reachedPoint2)
			XCTAssert(!reachedPoint3)
			XCTAssert(!reachedPoint4)
			dw1.runWork()
			XCTAssert(reachedPoint1)
			XCTAssert(reachedPoint2)
			XCTAssert(reachedPoint3)
			XCTAssert(reachedPoint4)
		}
	}

	func testDeferredWorkWithoutRunning() {
		let e = catchBadInstruction {
			_ = DeferredWork()
		}
		XCTAssert(e != nil)
	}
}
