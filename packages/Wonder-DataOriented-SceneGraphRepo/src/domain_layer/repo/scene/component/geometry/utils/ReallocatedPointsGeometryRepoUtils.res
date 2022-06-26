open Js.Typed_array

open TypeArrayRepoUtils

let getInfo = (infoIndex, infos) =>
  (
    TypeArrayRepoUtils.getUint32_1(infoIndex, infos),
    TypeArrayRepoUtils.getUint32_1(infoIndex + 1, infos),
  )->WonderCommonlib.Contract.ensureCheck(((startIndex, endIndex)) => {
    open WonderCommonlib.Contract
    open Operators

    test(WonderCommonlib.Log.buildAssertMessage(~expect=j`has info data`, ~actual=j`not`), () =>
      list{startIndex, endIndex}->assertNullableListExist
    )
    test(WonderCommonlib.Log.buildAssertMessage(~expect=j`endIndex >= startIndex`, ~actual=j`is $endIndex`), () =>
      endIndex >= startIndex
    )
  }, ConfigRepo.getIsDebug())

let setInfo = (infoIndex, startIndex, endIndex, infos) => WonderCommonlib.Contract.requireCheck(() => {
    open WonderCommonlib.Contract
    open Operators
    test(WonderCommonlib.Log.buildAssertMessage(~expect=j`startIndex >= 0`, ~actual=j`is $startIndex`), () =>
      startIndex >= 0
    )
    test(WonderCommonlib.Log.buildAssertMessage(~expect=j`endIndex >= startIndex`, ~actual=j`is $endIndex`), () =>
      endIndex >= startIndex
    )
  }, ConfigRepo.getIsDebug())->WonderCommonlib.Result.bind(() =>
    TypeArrayRepoUtils.setUint32_1(infoIndex, startIndex, infos)
  )->WonderCommonlib.Result.bind(() => TypeArrayRepoUtils.setUint32_1(infoIndex + 1, endIndex, infos))

let hasPointData = (infoIndex, infos) =>
  getInfo(infoIndex, infos)->WonderCommonlib.Result.mapSuccess(((startIndex, endIndex)) => endIndex > startIndex)

let getFloat32PointData = (infoIndex, points: Float32Array.t, infos) =>
  getInfo(infoIndex, infos)->WonderCommonlib.Result.mapSuccess(((startIndex, endIndex)) =>
    TypeArrayRepoUtils.getFloat32Array(points, startIndex, endIndex)
  )

let _setPointData = ((infoIndex: int, infos, offset: int, count), fillTypeArrayFunc) => {
  let startIndex = offset
  let newOffset = offset + count
  setInfo(infoIndex, startIndex, newOffset, infos)
  ->WonderCommonlib.Result.bind(() => fillTypeArrayFunc(startIndex))
  ->WonderCommonlib.Result.mapSuccess(() => newOffset)
}

let setFloat32PointData = (dataTuple, fillFloat32ArrayFunc) =>
  _setPointData(dataTuple, fillFloat32ArrayFunc)

let getUint32PointData = (infoIndex: int, points: Uint32Array.t, infos) =>
  getInfo(infoIndex, infos)->WonderCommonlib.Result.mapSuccess(((startIndex, endIndex)) =>
    getUint32Array(points, startIndex, endIndex)
  )

let setUint32PointData = (dataTuple, fillUint32ArraryFunc) =>
  _setPointData(dataTuple, fillUint32ArraryFunc)
