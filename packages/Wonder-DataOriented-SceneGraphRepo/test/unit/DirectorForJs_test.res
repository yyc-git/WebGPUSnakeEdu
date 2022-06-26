open Wonder_jest

let _ = describe("DirectorForJs", () => {
  open Expect
  open! Expect.Operators
  open Sinon

  let sandbox = getSandboxDefaultVal()

  beforeEach(() => {
    sandbox := createSandbox()
    TestTool.preparePO()
  })
  afterEach(() => restoreSandbox(refJsObjToSandbox(sandbox.contents)))

  describe("buildSceneGraphRepo", () => {
    describe("has setIsDebug", () => {
      test("set is debug to config", () => {
        let isDebug = true

        DirectorForJs.buildSceneGraphRepo().setIsDebug(isDebug)

        ConfigTool.getIsDebug()->expect == isDebug
      })
    })

    describe("createAndSetAllComponentPOs", () => {
      test("create all component POs", () => {
        let isDebug = true

        let {setComponentCount, createAndSetAllComponentPOs} = DirectorForJs.buildSceneGraphRepo()
        setComponentCount({transformCount: 10})
        createAndSetAllComponentPOs()

        SharedArrayBufferDataTool.getTransformSharedArrayBufferData().localScales
        ->Js.Typed_array.Float32Array.length
        ->expect == 30
      })
    })
  })

  //   describe("create all component po with shared array buffer data", () => {
  //     test("test transform shared array buffer data", () => {
  //       let localScales = Js.TypedArray2.Float32Array.make([1., 2., 3.])

  //       DirectorForJs.initForRenderWorker(
  //         true,
  //         SharedArrayBufferDataTool.createSharedArrayBufferData(
  //           ~localScales,
  //           (),
  //         )->VODOConvertApService.sharedArrayBufferDataDOToSharedArrayBufferDataVO,
  //       )

  //       SharedArrayBufferDataTool.getTransformSharedArrayBufferData().localScales->expect ==
  //         localScales
  //     })
  //   })
})
