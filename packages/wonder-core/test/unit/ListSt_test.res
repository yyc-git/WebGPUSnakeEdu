open Wonder_jest

open PipelineType
open Js.Promise

let _ = describe("WonderCommonLib->ListSt", () => {
  open Expect
  open Expect.Operators
  open Sinon

  let sandbox = getSandboxDefaultVal()

  beforeEach(() => {
    sandbox := createSandbox()

    CreatePO.createState()->POContainer.setState
  })
  afterEach(() => restoreSandbox(refJsObjToSandbox(sandbox.contents)))

  describe("addInReduce", () => {
    test("the list order should be the same", () => {
      let list = list{1, 2, 3}

      list
      ->WonderCommonlib.ListSt.reduce(list{}, (newList, value) => {
        newList->WonderCommonlib.ListSt.addInReduce(value)
      })
      ->expect == list
    })
  })
})
