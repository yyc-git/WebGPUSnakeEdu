<<<<<<< HEAD:packages/Wonder-CommonLib/src/component/BufferComponentUtils.res
let checkNotExceedMaxCountByIndex = (isDebug, index, maxCount) =>
  index->Contract.ensureCheck(index => {
    open Contract
=======
let checkNotExceedMaxCountByIndex = (index, maxCount) => index->WonderCommonlib.Contract.ensureCheck(index => {
    open WonderCommonlib.Contract
>>>>>>> 3fe27b0fb1e47f3ed2b3f28029190c71ef49a9dc:packages/Wonder-DataOriented-SceneGraphRepo/src/domain_layer/domain/scene/scene_graph/service/BufferComponentDoService.res
    open Operators

    let maxIndex = maxCount - 1

    test(
      WonderCommonlib.Log.buildAssertMessage(~expect=j`index: $index <= maxIndex: $maxIndex`, ~actual=j`not`),
      () => index <= maxIndex,
    )
  }, isDebug)
