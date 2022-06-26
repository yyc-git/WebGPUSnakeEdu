open Wonder_jest

let _ = describe("Scene", () => {
  open Expect
  open Expect.Operators
  open Sinon

  let sandbox = getSandboxDefaultVal()

  beforeEach(() => {
    sandbox := createSandbox()
    TestTool.init(~sandbox, ())
  })
  afterEach(() => restoreSandbox(refJsObjToSandbox(sandbox.contents)))

  describe("setScene", () =>
    test("test", () => {
      let scene1 = SceneTool.create()->ResultTool.getExnSuccessValue

      let scene2 = SceneTool.create()->ResultTool.getExnSuccessValue

      SceneTool.setScene(scene2)

      SceneTool.getScene()->expect == scene2->Some
    })
  )

  describe("getAllGameObjects", () =>
    test("get all gameObjects", () => {
      let scene = SceneTool.create()->ResultTool.getExnSuccessValue
      SceneTool.setScene(scene)
      // let geometry1 = GeometryTool.create()->ResultTool.getExnSuccessValue
      let gameObject1 = GameObjectTool.create()->ResultTool.getExnSuccessValue
      let gameObject2 = GameObjectTool.create()->ResultTool.getExnSuccessValue
      // GameObjectTool.addGeometry(gameObject1, geometry1)->ResultTool.getExnSuccessValueIgnore

      SceneTool.getAllGameObjects()->expect == list{scene, gameObject1, gameObject2}
    })
  )

  // describe("getAllRenderGameObjects", () =>
  //   test("get all gameObjects with geometry component", () => {
  //     let scene = SceneTool.create()->ResultTool.getExnSuccessValue
  //     SceneTool.setScene(scene)
  //     let geometry1 = GeometryTool.create()->ResultTool.getExnSuccessValue
  //     let geometry2 = GeometryTool.create()->ResultTool.getExnSuccessValue
  //     let gameObject1 = GameObjectTool.create()->ResultTool.getExnSuccessValue
  //     let gameObject2 = GameObjectTool.create()->ResultTool.getExnSuccessValue
  //     GameObjectTool.addGeometry(gameObject1, geometry1)->ResultTool.getExnSuccessValueIgnore

  //     SceneTool.getAllRenderGameObjects()->expect == list{gameObject1}
  //   })
  // )

  // describe("getAllGameObjectGeometries", () =>
  //   test("test", () => {
  //     let scene = SceneTool.create()->ResultTool.getExnSuccessValue
  //     SceneTool.setScene(scene)
  //     let geometry1 = GeometryTool.create()->ResultTool.getExnSuccessValue
  //     let geometry2 = GeometryTool.create()->ResultTool.getExnSuccessValue
  //     let gameObject1 = GameObjectTool.create()->ResultTool.getExnSuccessValue
  //     let gameObject2 = GameObjectTool.create()->ResultTool.getExnSuccessValue
  //     GameObjectTool.addGeometry(gameObject1, geometry1)->ResultTool.getExnSuccessValueIgnore
  //     GameObjectTool.addGeometry(gameObject2, geometry2)->ResultTool.getExnSuccessValueIgnore

  //     SceneTool.getAllGameObjectGeometries()->expect == list{geometry1, geometry2}
  //   })
  // )

  // describe("getAllGameObjectPBRMaterials", () =>
  //   test("test", () => {
  //     let scene = SceneTool.create()->ResultTool.getExnSuccessValue
  //     SceneTool.setScene(scene)
  //     let material1 = PBRMaterialTool.create()->ResultTool.getExnSuccessValue
  //     let material2 = PBRMaterialTool.create()->ResultTool.getExnSuccessValue
  //     let gameObject1 = GameObjectTool.create()->ResultTool.getExnSuccessValue
  //     let gameObject2 = GameObjectTool.create()->ResultTool.getExnSuccessValue
  //     GameObjectTool.addPBRMaterial(gameObject1, material1)->ResultTool.getExnSuccessValueIgnore
  //     GameObjectTool.addPBRMaterial(gameObject2, material2)->ResultTool.getExnSuccessValueIgnore

  //     SceneTool.getAllGameObjectPBRMaterials()->expect == list{material1, material2}
  //   })
  // )
})
