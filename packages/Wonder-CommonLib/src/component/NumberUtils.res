let bigThan = (num, below) => num < below ? below : num

<<<<<<< HEAD:packages/Wonder-CommonLib/src/component/NumberUtils.res
let clamp = (isDebug, num, below, up) => {
  Contract.requireCheck(() => {
    open Contract
=======
let clamp = (num, below, up) => {
  WonderCommonlib.Contract.requireCheck(() => {
    open WonderCommonlib.Contract
>>>>>>> 3fe27b0fb1e47f3ed2b3f28029190c71ef49a9dc:packages/Wonder-DataOriented-SceneGraphRepo/src/domain_layer/domain/scene/scene_graph/service/NumberDoService.res
    open Operators
    test(WonderCommonlib.Log.buildAssertMessage(~expect={j`below <= up`}, ~actual={j`not`}), () =>
      assertLte(Float, below, up)
    )
  }, isDebug)

  num < below ? below : num > up ? up : num
}

let dividInt = (a: int, b: int): float => Belt.Float.fromInt(a) /. Belt.Float.fromInt(b)
