open BasicCameraViewPOType

let getMaxIndex = () => ContainerManager.getBasicCameraView().maxIndex

let setMaxIndex = maxIndex =>
  ContainerManager.setBasicCameraView({
    ...ContainerManager.getBasicCameraView(),
    maxIndex: maxIndex,
  })

let getGameObject = cameraView =>
  ContainerManager.getBasicCameraView().gameObjectMap->WonderCommonlib.ImmutableSparseMap.get(cameraView)

let setGameObject = (cameraView, gameObject) => {
  let {gameObjectMap} as cameraViewPO = ContainerManager.getBasicCameraView()

  ContainerManager.setBasicCameraView({
    ...cameraViewPO,
    gameObjectMap: gameObjectMap->WonderCommonlib.ImmutableSparseMap.set(cameraView, gameObject),
  })
}

let isActive = cameraView =>
  ContainerManager.getBasicCameraView().isActiveMap
  ->WonderCommonlib.ImmutableSparseMap.get(cameraView)
  ->WonderCommonlib.OptionSt.getWithDefault(false)

let setAllNotActive = () => {
  let {isActiveMap} as cameraViewPO = ContainerManager.getBasicCameraView()

  ContainerManager.setBasicCameraView({
    ...cameraViewPO,
    isActiveMap: isActiveMap->WonderCommonlib.ImmutableSparseMap.map((. value) => false),
  })
}

let setActive = (cameraView, isActive) => {
  let {isActiveMap} as cameraViewPO = ContainerManager.getBasicCameraView()

  ContainerManager.setBasicCameraView({
    ...cameraViewPO,
    isActiveMap: isActiveMap->WonderCommonlib.ImmutableSparseMap.set(cameraView, isActive),
  })
}

let getActiveBasicCameraViews = () =>
  ContainerManager.getBasicCameraView().isActiveMap
  ->WonderCommonlib.ImmutableSparseMap.reducei(
    (. list, isActive, cameraView) => isActive === true ? list->WonderCommonlib.ListSt.push(cameraView) : list,
    list{},
  )
  ->WonderCommonlib.Contract.ensureCheck(r => {
    open WonderCommonlib.Contract
    open Operators
    test(
      WonderCommonlib.Log.buildAssertMessage(~expect=j`only has one active cameraView at most`, ~actual=j`not`),
      () => r->WonderCommonlib.ListSt.length <= 1,
    )
  }, ConfigRepo.getIsDebug())
