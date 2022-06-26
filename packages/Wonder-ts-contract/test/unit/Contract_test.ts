import { assertEqual, assertFalse, assertGt, assertLte, assertNotEqual, assertPass, assertTrue, buildAssetMessage, ensureCheck, requireCheck, test as testContract } from "../../src/Contract"

describe("Contract", () => {
    describe("buildAssetMessage", () => {
        test("default actual is 'not as expect'", () => {
            expect(buildAssetMessage("is number")).toEqual("expect is number, but actual not as expect");
        })
        test("can pass expect and actual", () => {
            expect(buildAssetMessage("is number", "not")).toEqual("expect is number, but actual not");
        })
    })

    describe("test", () => {
        test("if not true, throw", () => {
            let message = "aaa";

            expect(() => {
                testContract(message, () => false)
            }).toThrowError(message);
        })
    })

    describe("requireCheck", () => {
        test("if isTest === false, return", () => {
            let message = "aaa";

            expect(() => {
                requireCheck(() => {
                    testContract(message, () => false)
                }, false)
            }).not.toThrow()
        })

        describe("else", () => {
            test("exec func", () => {
                let message = "aaa";

                expect(() => {
                    requireCheck(() => {
                        testContract(message, () => false)
                    }, true)
                }).toThrowError(message)
            })
        })
    })

    describe("ensureCheck", () => {
        test("if isTest === false, return value", () => {
            let returnVal = 1;

            expect(ensureCheck(returnVal, (_) => { }, false)).toBe(returnVal)
        })

        describe("else", () => {
            test("exec func", () => {
                let message = "aaa";
                let returnVal = 1;

                expect(() => {
                    ensureCheck(returnVal, (returnVal) => {
                        testContract(message, () => {
                            return assertEqual(returnVal, 2);
                        })
                    }, true)
                }
                ).toThrowError(message)
            });
            test("return value", () => {
                let message = "aaa";
                let returnVal = 1;

                expect(ensureCheck(returnVal, (returnVal) => {
                    testContract(message, () => {
                        return assertEqual(returnVal, 1);
                    })
                }, true)).toBe(returnVal)
            })
        })
    })

    describe("assertPass", () => {
        test("return true", () => {
            expect(assertPass()).toBeTruthy();
        })
    })

    describe("assertTrue", () => {
        test("source should be true", () => {
            expect(assertTrue(true)).toBeTruthy();
        })
    })

    describe("assertFalse", () => {
        test("source should be false", () => {
            expect(assertFalse(false)).toBeTruthy();
        })
    })

    describe("assertEqual", () => {
        describe("test number with number", () => {
            test("if equal, return true", () => {
                expect(assertEqual(1, 1)).toBeTruthy();
            })
            test("else, return false", () => {
                expect(assertEqual(10, 1)).toBeFalsy
            })
        })

        describe("test string with string", () => {
            test("if equal, return true", () => {
                expect(assertEqual("", "")).toBeTruthy();
            })
            test("else, return false", () => {
                expect(assertEqual("aa", "x")).toBeFalsy
            })
        })

        describe("test boolean with boolean", () => {
            test("if equal, return true", () => {
                expect(assertEqual(true, true)).toBeTruthy();
            })
            test("else, return false", () => {
                expect(assertEqual(false, true)).toBeFalsy
            })
        })

        test("if number with string, return false", () => {
            expect(assertEqual(1, "s")).toBeFalsy();
        })
        test("if number with boolean, return false", () => {
            expect(assertEqual(1, false)).toBeFalsy();
        })
        test("if string with boolean, return false", () => {
            expect(assertEqual("", true)).toBeFalsy();
        })
    })

    describe("assertNotEqual", () => {
        describe("test number with number", () => {
            test("if not equal, return true", () => {
                expect(assertNotEqual(2, 1)).toBeTruthy();
            })
            test("else, return false", () => {
                expect(assertNotEqual(1, 1)).toBeFalsy
            })
        })

        describe("test string with string", () => {
            test("if not equal, return true", () => {
                expect(assertNotEqual("a", "")).toBeTruthy();
            })
            test("else, return false", () => {
                expect(assertNotEqual("x", "x")).toBeFalsy
            })
        })

        describe("test boolean with boolean", () => {
            test("if not equal, return true", () => {
                expect(assertNotEqual(false, true)).toBeTruthy();
            })
            test("else, return false", () => {
                expect(assertNotEqual(true, true)).toBeFalsy
            })
        })

        test("if number with string, return true", () => {
            expect(assertNotEqual(1, "s")).toBeTruthy();
        })
        test("if number with boolean, return false", () => {
            expect(assertNotEqual(1, false)).toBeTruthy();
        })
        test("if string with boolean, return false", () => {
            expect(assertNotEqual("", true)).toBeTruthy();
        })
    })

    describe("assertGt", () => {
        test("if source > target, return true", () => {
            expect(assertGt(2, 1)).toBeTruthy();
        })
        test("else, return false", () => {
            expect(assertGt(0, 1)).toBeFalsy();
        })
    })

    describe("assertLte", () => {
        test("if source <= target, return true", () => {
            expect(assertLte(1, 1)).toBeTruthy();
            expect(assertLte(-1, 1)).toBeTruthy();
        })
        test("else, return false", () => {
            expect(assertLte(2, 1)).toBeFalsy();
        })
    })
})