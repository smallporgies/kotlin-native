/*
 * Copyright 2010-2018 JetBrains s.r.o.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import Values

// -------- Tests --------

func testVals() throws {
    print("Values from Swift")
    let dbl = ValuesKt.dbl
    let flt = ValuesKt.flt
    let int = ValuesKt.integer
    let long = ValuesKt.longInt
    
    print(dbl)
    print(flt)
    print(int)
    print(long)
    
    try assertEquals(actual: dbl, expected: 3.14 as Double, "Double value isn't equal.")
    try assertEquals(actual: flt, expected: 2.73 as Float, "Float value isn't equal.")
    try assertEquals(actual: int, expected: 42)
    try assertEquals(actual: long, expected: 1984)
}

func testVars() throws {
    print("Variables from Swift")
    var intVar = ValuesKt.intVar
    var strVar = ValuesKt.str
    var strAsId = ValuesKt.strAsAny
    
    print(intVar)
    print(strVar)
    print(strAsId)
    
    try assertEquals(actual: intVar, expected: 451)
    try assertEquals(actual: strVar, expected: "Kotlin String")
    try assertEquals(actual: strAsId as! String, expected: "Kotlin String as Any")
    
    strAsId = "Swift str"
    ValuesKt.strAsAny = strAsId
    print(ValuesKt.strAsAny)
    try assertEquals(actual: ValuesKt.strAsAny as! String, expected: strAsId as! String)
    
    // property with custom getter/setter backed by the Kotlin's var
    var intProp : Int32 {
        get {
            return ValuesKt.intVar * 2
        }
        set(value) {
            ValuesKt.intVar = 123 + value
        }
    }
    intProp += 10   
    print(intProp)
    print(ValuesKt.intVar)
    try assertEquals(actual: ValuesKt.intVar * 2, expected: intProp, "Property backed by var")
}

func testDoubles() throws {
    print("Doubles in Swift")
    let minDouble = ValuesKt.minDoubleVal as! Double
    let maxDouble = ValuesKt.maxDoubleVal as! NSNumber

    print(minDouble)
    print(maxDouble)
    print(ValuesKt.nanDoubleVal)
    print(ValuesKt.nanFloatVal)
    print(ValuesKt.infDoubleVal)
    print(ValuesKt.infFloatVal)

    try assertEquals(actual: minDouble, expected: Double.leastNonzeroMagnitude, "Min double")
    try assertEquals(actual: maxDouble, expected: Double.greatestFiniteMagnitude as NSNumber, "Max double")
    try assertTrue(ValuesKt.nanDoubleVal.isNaN, "NaN double")
    try assertTrue(ValuesKt.nanFloatVal.isNaN, "NaN float")
    try assertEquals(actual: ValuesKt.infDoubleVal, expected: Double.infinity, "Inf double")
    try assertEquals(actual: ValuesKt.infFloatVal, expected: -Float.infinity, "-Inf float")
}

func testNumbers() throws {
    try assertEquals(actual: KotlinBoolean(value: true).boolValue, expected: true)
    try assertEquals(actual: KotlinBoolean(value: false).intValue, expected: 0)
    try assertEquals(actual: KotlinBoolean(value: true), expected: true)
    try assertFalse(KotlinBoolean(value: false) as! Bool)

    try assertEquals(actual: KotlinByte(value: -1).int8Value, expected: -1)
    try assertEquals(actual: KotlinByte(value: -1).int32Value, expected: -1)
    try assertEquals(actual: KotlinByte(value: -1).doubleValue, expected: -1.0)
    try assertEquals(actual: KotlinByte(value: -1), expected: NSNumber(value: Int64(-1)))
    try assertFalse(KotlinByte(value: -1) == NSNumber(value: -1.5))
    try assertEquals(actual: KotlinByte(value: -1), expected: -1)
    try assertTrue(KotlinByte(value: -1) == -1)
    try assertFalse(KotlinByte(value: -1) == 1)
    try assertEquals(actual: KotlinByte(value: -1) as! Int32, expected: -1)

    try assertEquals(actual: KotlinShort(value: 111).int16Value, expected: 111)
    try assertEquals(actual: KotlinShort(value: -15) as! Int16, expected: -15)
    try assertEquals(actual: KotlinShort(value: 47), expected: 47)

    try assertEquals(actual: KotlinInt(value: 99).int32Value, expected: 99)
    try assertEquals(actual: KotlinInt(value: -1) as! Int32, expected: -1)
    try assertEquals(actual: KotlinInt(value: 72), expected: 72)

    try assertEquals(actual: KotlinLong(value: 65).int64Value, expected: 65)
    try assertEquals(actual: KotlinLong(value: 10000000000) as! Int64, expected: 10000000000)
    try assertEquals(actual: KotlinLong(value: 8), expected: 8)

    try assertEquals(actual: KotlinUByte(value: 17).uint8Value, expected: 17)
    try assertEquals(actual: KotlinUByte(value: 42) as! UInt8, expected: 42)
    try assertEquals(actual: 88, expected: KotlinUByte(value: 88))

    try assertEquals(actual: KotlinUShort(value: 40000).uint16Value, expected: 40000)
    try assertEquals(actual: KotlinUShort(value: 1) as! UInt16, expected: UInt16(1))
    try assertEquals(actual: KotlinUShort(value: 65000), expected: 65000)

    try assertEquals(actual: KotlinUInt(value: 3).uint32Value, expected: 3)
    try assertEquals(actual: KotlinUInt(value: UInt32.max) as! UInt32, expected: UInt32.max)
    try assertEquals(actual: KotlinUInt(value: 2), expected: 2)

    try assertEquals(actual: KotlinULong(value: 55).uint64Value, expected: 55)
    try assertEquals(actual: KotlinULong(value: 0) as! UInt64, expected: 0)
    try assertEquals(actual: KotlinULong(value: 7), expected: 7)

    try assertEquals(actual: KotlinFloat(value: 1.0).floatValue, expected: 1.0)
    try assertEquals(actual: KotlinFloat(value: 22.0) as! Float, expected: 22)
    try assertEquals(actual: KotlinFloat(value: 41.0), expected: 41)
    try assertEquals(actual: KotlinFloat(value: -5.5), expected: -5.5)

    try assertEquals(actual: KotlinDouble(value: 0.5).doubleValue, expected: 0.5)
    try assertEquals(actual: KotlinDouble(value: 45.0) as! Double, expected: 45)
    try assertEquals(actual: KotlinDouble(value: 89.0), expected: 89)
    try assertEquals(actual: KotlinDouble(value: -3.7), expected: -3.7)

    ValuesKt.ensureEqualBooleans(actual: KotlinBoolean(value: true), expected: true)
    ValuesKt.ensureEqualBooleans(actual: false, expected: false)

    ValuesKt.ensureEqualBytes(actual: KotlinByte(value: 42), expected: 42)
    ValuesKt.ensureEqualBytes(actual: -11, expected: -11)

    ValuesKt.ensureEqualShorts(actual: KotlinShort(value: 256), expected: 256)
    ValuesKt.ensureEqualShorts(actual: -1, expected: -1)

    ValuesKt.ensureEqualInts(actual: KotlinInt(value: 100000), expected: 100000)
    ValuesKt.ensureEqualInts(actual: -7, expected: -7)

    ValuesKt.ensureEqualLongs(actual: KotlinLong(value: Int64.max), expected: Int64.max)
    ValuesKt.ensureEqualLongs(actual: 17, expected: 17)

    ValuesKt.ensureEqualUBytes(actual: KotlinUByte(value: 6), expected: 6)
    ValuesKt.ensureEqualUBytes(actual: 255, expected: 255)

    ValuesKt.ensureEqualUShorts(actual: KotlinUShort(value: 300), expected: 300)
    ValuesKt.ensureEqualUShorts(actual: 65535, expected: UInt16.max)

    ValuesKt.ensureEqualUInts(actual: KotlinUInt(value: 70000), expected: 70000)
    ValuesKt.ensureEqualUInts(actual: 48, expected: 48)

    ValuesKt.ensureEqualULongs(actual: KotlinULong(value: UInt64.max), expected: UInt64.max)
    ValuesKt.ensureEqualULongs(actual: 39, expected: 39)

    ValuesKt.ensureEqualFloats(actual: KotlinFloat(value: 36.6), expected: 36.6)
    ValuesKt.ensureEqualFloats(actual: 49.5, expected: 49.5)
    ValuesKt.ensureEqualFloats(actual: 18, expected: 18.0)

    ValuesKt.ensureEqualDoubles(actual: KotlinDouble(value: 12.34), expected: 12.34)
    ValuesKt.ensureEqualDoubles(actual: 56.78, expected: 56.78)
    ValuesKt.ensureEqualDoubles(actual: 3, expected: 3)

    func checkBox<T: Equatable, B : NSObject>(_ value: T, _ boxFunction: (T) -> B?) throws {
        let box = boxFunction(value)!
        try assertEquals(actual: box as! T, expected: value)
        print(type(of: box))
        print(B.self)
        try assertTrue(box.isKind(of: B.self))
    }

    try checkBox(true, ValuesKt.box)
    try checkBox(Int8(-1), ValuesKt.box)
    try checkBox(Int16(-2), ValuesKt.box)
    try checkBox(Int32(-3), ValuesKt.box)
    try checkBox(Int64(-4), ValuesKt.box)
    try checkBox(UInt8(5), ValuesKt.box)
    try checkBox(UInt16(6), ValuesKt.box)
    try checkBox(UInt32(7), ValuesKt.box)
    try checkBox(UInt64(8), ValuesKt.box)
    try checkBox(Float(8.7), ValuesKt.box)
    try checkBox(Double(9.4), ValuesKt.box)
}

func testLists() throws {
    let numbersList = ValuesKt.numbersList
    let gold = [1, 2, 13]
    for i in 0..<gold.count {
        try assertEquals(actual: gold[i], expected: Int(numbersList[i] as! NSNumber), "Numbers list")
    }

    let anyList = ValuesKt.anyList
    for i in anyList {
        print(i)
    }
//    try assertEquals(actual: gold, expected: anyList, "Numbers list")
}

func testLazyVal() throws {
    let lazyVal = ValuesKt.lazyVal
    print(lazyVal)
    try assertEquals(actual: lazyVal, expected: "Lazily initialized string", "lazy value")
}

let goldenArray = ["Delegated", "global", "array", "property"]

func testDelegatedProp() throws {
    let delegatedGlobalArray = ValuesKt.delegatedGlobalArray
    guard Int(delegatedGlobalArray.size) == goldenArray.count else {
        throw TestError.assertFailed("Size differs")
    }
    for i in 0..<delegatedGlobalArray.size {
        print(delegatedGlobalArray.get(index: i)!)
    }
}

func testGetterDelegate() throws {
    let delegatedList = ValuesKt.delegatedList
    guard delegatedList.count == goldenArray.count else {
        throw TestError.assertFailed("Size differs")
    }
    for val in delegatedList {
        print(val)
    }
}

func testNulls() throws {
    let nilVal : Any? = ValuesKt.nullVal
    try assertTrue(nilVal == nil, "Null value")

    ValuesKt.nullVar = nil
    var nilVar : Any? = ValuesKt.nullVar
    try assertTrue(nilVar == nil, "Null variable")
}

func testAnyVar() throws {
    let anyVar : Any = ValuesKt.anyValue
    print(anyVar)
    if let str = anyVar as? String {
        print(str)
        try assertEquals(actual: str, expected: "Str")
    } else {
        throw TestError.assertFailed("Incorrect type passed from Any")
    }
}

func testFunctions() throws {
    let _: Any? = ValuesKt.emptyFun()

    let str = ValuesKt.strFun()
    try assertEquals(actual: str, expected: "fooStr")

    try assertEquals(actual: ValuesKt.argsFun(i: 10, l: 20, d: 3.5, s: "res") as! String,
            expected: "res10203.5")

    try assertEquals(actual: ValuesKt.multiply(int: 3, long: 2), expected: 6)
}


func testExceptions() throws {
    let bridge = Bridge()
    do {
        try bridge.foo1()
    } catch let error as NSError {
        try assertTrue(error.kotlinException is MyException)
    }
    do {
        var result: Int32 = 0
        try bridge.foo2(result: &result)
    } catch let error as NSError {
        try assertTrue(error.kotlinException is MyException)
    }
    do {
        try bridge.foo3()
    } catch let error as NSError {
        try assertTrue(error.kotlinException is MyException)
    }
    do {
        var result: KotlinNothing? = nil
        try bridge.foo4(result: &result)
    } catch let error as NSError {
        try assertTrue(error.kotlinException is MyException)
    }
}

func testFuncType() throws {
    let s = "str"
    let fFunc: () -> String = { return s }
    try assertEquals(actual: ValuesKt.funArgument(foo: fFunc), expected: s, "Using function type arguments failed")
}

func testGenericsFoo() throws {
    let fun = { (i: Int) -> String in return "S \(i)" }
    // wrap lambda to workaround issue with type conversion inability:
    // (Int) -> String can't be cast to (Any?) -> Any?
    let wrapper = { (t: Any?) -> Any? in return fun(t as! Int) }
    let res = ValuesKt.genericFoo(t: 42, foo: wrapper)
    try assertEquals(actual: res as! String, expected: "S 42")
}

func testVararg() throws {
    let ktArray = KotlinArray(size: 3, init: { (_) -> Int in return 42 })
    let arr: [Int] = ValuesKt.varargToList(args: ktArray) as! [Int]
    try assertEquals(actual: arr, expected: [42, 42, 42])
}

func testStrExtFun() throws {
    try assertEquals(actual: ValuesKt.subExt("String", i: 2), expected: "r")
    try assertEquals(actual: ValuesKt.subExt("A", i: 2), expected: "nothing")
}

func testAnyToString() throws {
    try assertEquals(actual: ValuesKt.toString(nil), expected: "null")
    try assertEquals(actual: ValuesKt.toString(42), expected: "42")
}

func testAnyPrint() throws {
    print("BEGIN")
    ValuesKt.print(nil)
    ValuesKt.print("Print")
    ValuesKt.print(123456789)
    ValuesKt.print(3.14)
    ValuesKt.print([3, 2, 1])
    print("END")
}

func testCharExtensions() throws {
    try assertTrue(ValuesKt.isA(ValuesKt.boxChar(65)))
    try assertFalse(ValuesKt.isA(ValuesKt.boxChar(66)))
}

func testLambda() throws {
    try assertEquals(actual: ValuesKt.sumLambda(3, 4), expected: 7)
}

// -------- Tests for classes and interfaces -------
class ValIEmptyExt : I {
    func iFun() -> String {
        return "ValIEmptyExt::iFun"
    }
}

class ValIExt : I {
    func iFun() -> String {
        return "ValIExt::iFun"
    }
}

func testInterfaceExtension() throws {
    try assertEquals(actual: ValIEmptyExt().iFun(), expected: "ValIEmptyExt::iFun")
    try assertEquals(actual: ValIExt().iFun(), expected: "ValIExt::iFun")
}

func testClassInstances() throws {
    try assertEquals(actual: OpenClassI().iFun(), expected: "OpenClassI::iFun")
    try assertEquals(actual: DefaultInterfaceExt().iFun(), expected: "I::iFun")
    try assertEquals(actual: FinalClassExtOpen().iFun(), expected: "FinalClassExtOpen::iFun")
    try assertEquals(actual: MultiExtClass().iFun(), expected: "PI::iFun")
    try assertEquals(actual: MultiExtClass().piFun() as! Int, expected: 42)
    try assertEquals(actual: ConstrClass(i: 1, s: "str", a: "Any").iFun(), expected: "OpenClassI::iFun")
    try assertEquals(actual: ExtConstrClass(i: 123).iFun(), expected: "ExtConstrClass::iFun::123-String-AnyS")
}

func testEnum() throws {
    try assertEquals(actual: ValuesKt.passEnum().enumValue, expected: 42)
    try assertEquals(actual: ValuesKt.passEnum().name, expected: "ANSWER")
    ValuesKt.receiveEnum(e: 1)
}

func testDataClass() throws {
    let f = "1"
    let s = "2"
    let t = "3"

    let tripleVal = TripleVals(first: f, second: s, third: t)
    try assertEquals(actual: tripleVal.first as! String, expected: f, "Data class' value")
    try assertEquals(actual: tripleVal.component2() as! String, expected: s, "Data class' component")
    print(tripleVal)
    try assertEquals(actual: String(describing: tripleVal), expected: "TripleVals(first=\(f), second=\(s), third=\(t))")

    let tripleVar = TripleVars(first: f, second: s, third: t)
    try assertEquals(actual: tripleVar.first as! String, expected: f, "Data class' value")
    try assertEquals(actual: tripleVar.component2() as! String, expected: s, "Data class' component")
    print(tripleVar)
    try assertEquals(actual: String(describing: tripleVar), expected: "[\(f), \(s), \(t)]")

    tripleVar.first = t
    tripleVar.second = f
    tripleVar.third = s
    try assertEquals(actual: tripleVar.component2() as! String, expected: f, "Data class' component")
    try assertEquals(actual: String(describing: tripleVar), expected: "[\(t), \(f), \(s)]")
}

func testCompanionObj() throws {
    try assertEquals(actual: WithCompanionAndObject.Companion().str, expected: "String")
    try assertEquals(actual: ValuesKt.getCompanionObject().str, expected: "String")

    let namedFromCompanion = ValuesKt.getCompanionObject().named
    let named = ValuesKt.getNamedObject()
    try assertTrue(named === namedFromCompanion, "Should be the same Named object")

    try assertEquals(actual: ValuesKt.getNamedObjectInterface().iFun(), expected: named.iFun(), "Named object's method")
}

func testInlineClasses() throws {
    let ic1: Int32 = 42
    let ic1N = ValuesKt.box(ic1: 17)
    let ic2 = "foo"
    let ic2N = "bar"
    let ic3 = TripleVals(first: 1, second: 2, third: 3)
    let ic3N = ValuesKt.box(ic3: nil)

    try assertEquals(
        actual: ValuesKt.concatenateInlineClassValues(ic1: ic1, ic1N: ic1N, ic2: ic2, ic2N: ic2N, ic3: ic3, ic3N: ic3N),
        expected: "42 17 foo bar TripleVals(first=1, second=2, third=3) null"
    )

    try assertEquals(
        actual: ValuesKt.concatenateInlineClassValues(ic1: ic1, ic1N: nil, ic2: ic2, ic2N: nil, ic3: nil, ic3N: nil),
        expected: "42 null foo null null null"
    )

    try assertEquals(actual: ValuesKt.getValue1(ic1), expected: 42)
    try assertEquals(actual: ValuesKt.getValueOrNull1(ic1N) as! Int, expected: 17)

    try assertEquals(actual: ValuesKt.getValue2(ic2), expected: "foo")
    try assertEquals(actual: ValuesKt.getValueOrNull2(ic2N), expected: "bar")

    try assertEquals(actual: ValuesKt.getValue3(ic3), expected: ic3)
    try assertEquals(actual: ValuesKt.getValueOrNull3(ic3N), expected: nil)
}

class TestSharedIImpl : NSObject, I {
    func iFun() -> String {
        return "TestSharedIImpl::iFun"
    }
}

func testShared() throws {
    func assertFrozen(_ obj: AnyObject) throws {
        try assertTrue(ValuesKt.isFrozen(obj: obj), "isFrozen(\(obj))")
    }

    func assertNotFrozen(_ obj: AnyObject) throws {
        try assertFalse(ValuesKt.isFrozen(obj: obj), "isFrozen(\(obj))")
    }

    try assertFrozen(NSObject())
    try assertFrozen(TestSharedIImpl())
    try assertFrozen(ValuesKt.kotlinLambda(block: { return $0 }) as AnyObject)
    try assertNotFrozen(FinalClassExtOpen())
}

class PureSwiftClass {
}

struct PureSwiftStruct {
    var x: Int
}
class PureSwiftKotlinInterfaceImpl : I {
    func iFun() -> String {
        return "pure"
    }
}

func testPureSwiftClasses() throws {
    let pureSwiftClass = PureSwiftClass()
    try assertTrue(ValuesKt.same(pureSwiftClass) as? AnyObject === pureSwiftClass)

    try assertEquals(actual: 123, expected: (ValuesKt.same(PureSwiftStruct(x: 123)) as? PureSwiftStruct)?.x)
    try assertEquals(actual: "pure", expected: ValuesKt.iFunExt(PureSwiftKotlinInterfaceImpl()))
}

func testNames() throws {
    try assertEquals(actual: ValuesKt.PROPERTY_NAME_MUST_NOT_BE_ALTERED_BY_SWIFT, expected: 111)
}

// -------- Execution of the test --------

class ValuesTests : TestProvider {
    var tests: [TestCase] = []

    init() {
        providers.append(self)
        tests = [
            TestCase(name: "TestValues", method: withAutorelease(testVals)),
            TestCase(name: "TestVars", method: withAutorelease(testVars)),
            TestCase(name: "TestDoubles", method: withAutorelease(testDoubles)),
            TestCase(name: "TestNumbers", method: withAutorelease(testNumbers)),
            TestCase(name: "TestLists", method: withAutorelease(testLists)),
            TestCase(name: "TestLazyValues", method: withAutorelease(testLazyVal)),
            TestCase(name: "TestDelegatedProperties", method: withAutorelease(testDelegatedProp)),
            TestCase(name: "TestGetterDelegate", method: withAutorelease(testGetterDelegate)),
            TestCase(name: "TestNulls", method: withAutorelease(testNulls)),
            TestCase(name: "TestAnyVar", method: withAutorelease(testAnyVar)),
            TestCase(name: "TestFunctions", method: withAutorelease(testFunctions)),
            TestCase(name: "TestExceptions", method: withAutorelease(testExceptions)),
            TestCase(name: "TestFuncType", method: withAutorelease(testFuncType)),
            TestCase(name: "TestGenericsFoo", method: withAutorelease(testGenericsFoo)),
            TestCase(name: "TestVararg", method: withAutorelease(testVararg)),
            TestCase(name: "TestStringExtension", method: withAutorelease(testStrExtFun)),
            TestCase(name: "TestAnyToString", method: withAutorelease(testAnyToString)),
            TestCase(name: "TestAnyPrint", method: withAutorelease(testAnyPrint)),
            TestCase(name: "TestCharExtensions", method: withAutorelease(testCharExtensions)),
            TestCase(name: "TestLambda", method: withAutorelease(testLambda)),
            TestCase(name: "TestInterfaceExtension", method: withAutorelease(testInterfaceExtension)),
            TestCase(name: "TestClassInstances", method: withAutorelease(testClassInstances)),
            TestCase(name: "TestEnum", method: withAutorelease(testEnum)),
            TestCase(name: "TestDataClass", method: withAutorelease(testDataClass)),
            TestCase(name: "TestCompanionObj", method: withAutorelease(testCompanionObj)),
            TestCase(name: "TestInlineClasses", method: withAutorelease(testInlineClasses)),
            TestCase(name: "TestShared", method: withAutorelease(testShared)),
            TestCase(name: "TestPureSwiftClasses", method: withAutorelease(testPureSwiftClasses)),
            TestCase(name: "TestNames", method: withAutorelease(testNames)),
        ]
    }
}
