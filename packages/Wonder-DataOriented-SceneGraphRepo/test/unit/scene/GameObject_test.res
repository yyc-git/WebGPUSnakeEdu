open Wonder_jest

open GameObjectTool

open VODOConvertApService

let _ = describe("GameObject", () => {
  open Expect
  open! Expect.Operators
  open Sinon

  let sandbox = getSandboxDefaultVal()

  beforeEach(() => {
    sandbox := createSandbox()
    TestTool.init(~sandbox, ())
  })
  afterEach(() => restoreSandbox(refJsObjToSandbox(sandbox.contents)))

  describe("createGameObject", () => {
    test("create a new gameObject", () => {
      let gameObject = create()->ResultTool.getExnSuccessValue

      expect(gameObject) == 0->GameObjectEntity.create
    })
    test("add new transform component", () => {
      let gameObject = create()->ResultTool.getExnSuccessValue

      hasTransform(gameObject)->expect == true
    })

    describe("change po", () =>
      test("po->uid + 1", () => {
        let _ = create()->ResultTool.getExnSuccessValue

        GameObjectTool.getMaxUID()->expect == 1
      })
    )
  })

  describe("test operate component", () => {
    describe("test transform component", () => {
      describe("addTransform", () => {
        test("if this type of component is already exist, fail", () => {
          let gameObject = create()->ResultTool.getExnSuccessValue

          let transform = TransformTool.create()->ResultTool.getExnSuccessValue

          addTransform(gameObject, transform)->ExpectTool.toFail(
            "expect this type of the component shouldn't be added before, but actual not",
          )
        })
        test("can get component's gameObject", () => {
          let gameObject = create()->ResultTool.getExnSuccessValue

          TransformTool.getGameObject(getTransform(gameObject)->WonderCommonlib.OptionSt.getExn)->expect ==
            gameObject->Some
        })
      })

      describe("getTransform", () =>
        test("get transform component", () => {
          let gameObject = create()->ResultTool.getExnSuccessValue

          getTransform(gameObject)->WonderCommonlib.OptionSt.getExn->TransformTool.isTransform
        })
      )

      describe("hasTransform", () =>
        test("has transform component", () => {
          let gameObject = create()->ResultTool.getExnSuccessValue

          hasTransform(gameObject)->expect == true
        })
      )
    })

    // describe("test pbrMaterial component", () => {
    //   let _createAndAddComponent = () => {
    //     let gameObject = create()->ResultTool.getExnSuccessValue

    //     let pbrMaterial = PBRMaterialTool.create()->ResultTool.getExnSuccessValue

    //     addPBRMaterial(gameObject, pbrMaterial)->ResultTool.getExnSuccessValue
    //   }

    //   describe("addPBRMaterial", () =>
    //     test("if this type of component is already exist, fail", () => {
    //       let gameObject = _createAndAddComponent()

    //       let pbrMaterial = PBRMaterialTool.create()->ResultTool.getExnSuccessValue

    //       addPBRMaterial(gameObject, pbrMaterial)->ExpectTool.toFail(
    //         "expect this type of the component shouldn't be added before, but actual not",
    //       )
    //     })
    //   )

    //   describe("getPBRMaterial", () =>
    //     test("get pbrMaterial component", () => {
    //       let gameObject = _createAndAddComponent()

    //       getPBRMaterial(gameObject)->WonderCommonlib.OptionSt.getExn->PBRMaterialTool.isPBRMaterial
    //     })
    //   )

    //   describe("hasPBRMaterial", () =>
    //     test("has pbrMaterial component", () => {
    //       let gameObject = _createAndAddComponent()

    //       hasPBRMaterial(gameObject)->expect == true
    //     })
    //   )
    // })

    // describe("test geometry component", () => {
    //   let _createAndAddComponent = () => {
    //     let gameObject = create()->ResultTool.getExnSuccessValue

    //     let geometry = GeometryTool.create()->ResultTool.getExnSuccessValue

    //     addGeometry(gameObject, geometry)->ResultTool.getExnSuccessValue
    //   }

    //   describe("addGeometry", () =>
    //     test("if this type of component is already exist, fail", () => {
    //       let gameObject = _createAndAddComponent()

    //       let geometry = GeometryTool.create()->ResultTool.getExnSuccessValue

    //       addGeometry(gameObject, geometry)->ExpectTool.toFail(
    //         "expect this type of the component shouldn't be added before, but actual not",
    //       )
    //     })
    //   )

    //   describe("getGeometry", () =>
    //     test("get geometry component", () => {
    //       let gameObject = _createAndAddComponent()

    //       getGeometry(gameObject)->WonderCommonlib.OptionSt.getExn->GeometryTool.isGeometry
    //     })
    //   )

    //   describe("hasGeometry", () =>
    //     test("has geometry component", () => {
    //       let gameObject = _createAndAddComponent()

    //       hasGeometry(gameObject)->expect == true
    //     })
    //   )
    // })
  })
})
