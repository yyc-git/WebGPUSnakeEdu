open GeometryPOType

let getVertexInfo = index => {
  let {verticesInfos} = ContainerManager.getExnGeometry()

  ReallocatedPointsGeometryRepoUtils.getInfo(
    BufferGeometryRepoUtils.getInfoIndex(index),
    verticesInfos,
  )->WonderCommonlib.Result.bind(((startIndex, endIndex)) =>
    (startIndex, endIndex)->WonderCommonlib.Contract.ensureCheck(((startIndex, endIndex)) => {
      open WonderCommonlib.Contract
      open Operators

      test(
        WonderCommonlib.Log.buildAssertMessage(~expect=j`equal to the info get from normals`, ~actual=j`not equal`),
        () => {
          let {normalsInfos} = ContainerManager.getExnGeometry()

          let (startIndexGetFromNormals, endIndexGetFromNormals) =
            ReallocatedPointsGeometryRepoUtils.getInfo(
              BufferGeometryRepoUtils.getInfoIndex(index),
              normalsInfos,
            )->WonderCommonlib.Result.getExn

          startIndex == startIndexGetFromNormals && endIndex == endIndexGetFromNormals
        },
      )
      test(
        WonderCommonlib.Log.buildAssertMessage(~expect=j`startIndex:$startIndex is 3 times`, ~actual=j`not`),
        () => {
          let x = Number.dividInt(startIndex, 3)

          \"==."(x -. x->Js.Math.floor_float, 0.0)
        },
      )
    }, ConfigRepo.getIsDebug())
  )
}

let getIndexInfo = index => {
  let {indicesInfos} = ContainerManager.getExnGeometry()

  ReallocatedPointsGeometryRepoUtils.getInfo(
    BufferGeometryRepoUtils.getInfoIndex(index),
    indicesInfos,
  )
}

let _getVerticesTypeArr = () => ContainerManager.getExnGeometry().vertices

let _getTexCoordsTypeArr = () => ContainerManager.getExnGeometry().texCoords

let _getNormalsTypeArr = () => ContainerManager.getExnGeometry().normals

let _getTangentsTypeArr = () => ContainerManager.getExnGeometry().tangents

let _getIndicesTypeArr = () => ContainerManager.getExnGeometry().indices

let getVerticesOffset = () => ContainerManager.getExnGeometry().verticesOffset

let getVertexCount = () => WonderCommonlib.Contract.requireCheck(() => {
    open WonderCommonlib.Contract
    open Operators
    test(WonderCommonlib.Log.buildAssertMessage(~expect=j`verticesOffset be 3 times`, ~actual=j`not`), () => {
      let x = Number.dividInt(getVerticesOffset(), 3)

      \"==."(x -. x->Js.Math.floor_float, 0.0)
    })
  }, ConfigRepo.getIsDebug())->WonderCommonlib.Result.mapSuccess(() =>
    getVerticesOffset() / 3
  )

let _getTexCoordsOffset = () => ContainerManager.getExnGeometry().texCoordsOffset

let getNormalsOffset = () => ContainerManager.getExnGeometry().normalsOffset

let _getTangentsOffset = () => ContainerManager.getExnGeometry().tangentsOffset

let _getIndicesOffset = () => ContainerManager.getExnGeometry().indicesOffset

let getSubUsedVerticesTypeArr = () =>
  Js.Typed_array.Float32Array.subarray(~start=0, ~end_=getVerticesOffset(), _getVerticesTypeArr())

let getSubUsedTexCoordsTypeArr = () =>
  Js.Typed_array.Float32Array.subarray(
    ~start=0,
    ~end_=_getTexCoordsOffset(),
    _getTexCoordsTypeArr(),
  )

let getSubUsedNormalsTypeArr = () =>
  Js.Typed_array.Float32Array.subarray(~start=0, ~end_=getNormalsOffset(), _getNormalsTypeArr())

let getSubUsedTangentsTypeArr = () =>
  Js.Typed_array.Float32Array.subarray(~start=0, ~end_=_getTangentsOffset(), _getTangentsTypeArr())

let getSubUsedIndicesTypeArr = () =>
  Js.Typed_array.Uint32Array.subarray(~start=0, ~end_=_getIndicesOffset(), _getIndicesTypeArr())

let getCopyUsedIndicesTypeArr = () =>
  Js.Typed_array.Uint32Array.slice(~start=0, ~end_=_getIndicesOffset(), _getIndicesTypeArr())
