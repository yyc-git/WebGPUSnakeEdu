let _check = (hasComponentFunc, gameObject) => WonderCommonlib.Contract.requireCheck(() => {
    open WonderCommonlib.Contract
    open Operators
    test(
      WonderCommonlib.Log.buildAssertMessage(
        ~expect=j`this type of the component shouldn't be added before`,
        ~actual=j`not`,
      ),
      () => hasComponentFunc(gameObject)->assertFalse,
    )
  }, ConfigRepo.getIsDebug())

let _addComponent = (
  (hasComponentFunc, addComponentFunc, handleAddComponentFunc),
  (gameObject, component),
) =>
  _check(hasComponentFunc, gameObject)->WonderCommonlib.Result.mapSuccess(() => {
    addComponentFunc(gameObject, component)

    handleAddComponentFunc(. component, gameObject)

    gameObject->GameObjectEntity.create
  })

let addTransform = (gameObject, transform) =>
  _addComponent(
    (
      GameObjectRepo.hasTransform,
      GameObjectRepo.addTransform,
      AddTransformDoService.handleAddComponent,
    ),
    (gameObject->GameObjectEntity.value, transform->TransformEntity.value),
  )

let addPBRMaterial = (gameObject, material) =>
  _addComponent(
    (
      GameObjectRepo.hasPBRMaterial,
      GameObjectRepo.addPBRMaterial,
      AddPBRMaterialDoService.handleAddComponent,
    ),
    (gameObject->GameObjectEntity.value, material->PBRMaterialEntity.value),
  )

let addGeometry = (gameObject, geometry) =>
  _addComponent(
    (
      GameObjectRepo.hasGeometry,
      GameObjectRepo.addGeometry,
      AddGeometryDoService.handleAddComponent,
    ),
    (gameObject->GameObjectEntity.value, geometry->GeometryEntity.value),
  )

let addDirectionLight = (gameObject, light) =>
  _addComponent(
    (
      GameObjectRepo.hasDirectionLight,
      GameObjectRepo.addDirectionLight,
      AddDirectionLightDoService.handleAddComponent,
    ),
    (gameObject->GameObjectEntity.value, light->DirectionLightEntity.value),
  )

let addBasicCameraView = (gameObject, cameraView) =>
  _addComponent(
    (
      GameObjectRepo.hasBasicCameraView,
      GameObjectRepo.addBasicCameraView,
      AddBasicCameraViewDoService.handleAddComponent,
    ),
    (gameObject->GameObjectEntity.value, cameraView->BasicCameraViewEntity.value),
  )

let addPerspectiveCameraProjection = (gameObject, cameraProjection) =>
  _addComponent(
    (
      GameObjectRepo.hasPerspectiveCameraProjection,
      GameObjectRepo.addPerspectiveCameraProjection,
      AddPerspectiveCameraProjectionDoService.handleAddComponent,
    ),
    (gameObject->GameObjectEntity.value, cameraProjection->PerspectiveCameraProjectionEntity.value),
  )

let addArcballCameraController = (gameObject, cameraController) =>
  _addComponent(
    (
      GameObjectRepo.hasArcballCameraController,
      GameObjectRepo.addArcballCameraController,
      AddArcballCameraControllerDoService.handleAddComponent,
    ),
    (gameObject->GameObjectEntity.value, cameraController->ArcballCameraControllerEntity.value),
  )
