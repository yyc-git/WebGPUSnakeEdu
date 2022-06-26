let _createAndSetAllComponentPOs = () =>
  CreatePOTransformRepo.createPO()
  ->WonderCommonlib.Result.mapSuccess(po => po->ContainerManager.setTransform)
  ->WonderCommonlib.Result.bind(() =>
    CreatePOPBRMaterialRepo.createPO()->WonderCommonlib.Result.mapSuccess(po =>
      po->ContainerManager.setPBRMaterial
    )
  )
  ->WonderCommonlib.Result.bind(() =>
    CreatePOGeometryRepo.createPO()->WonderCommonlib.Result.mapSuccess(po =>
      po->ContainerManager.setGeometry
    )
  )
  ->WonderCommonlib.Result.bind(() =>
    CreatePODirectionLightRepo.createPO()->WonderCommonlib.Result.mapSuccess(po =>
      po->ContainerManager.setDirectionLight
    )
  )

let _setComponentCount = (
  {
    transformCount,
    // geometryCount,
    // geometryPointCount,
    // pbrMaterialCount,
    // directionLightCount,
  }: WonderCore.ISceneGraphRepoForJs.componentCountData,
) => {
  ConfigApService.setTransformCount(transformCount)
  // ConfigApService.setGeometryCount(geometryCount)
  // ConfigApService.setGeometryPointCount(geometryPointCount)
  // ConfigApService.setPBRMaterialCount(pbrMaterialCount)
  // ConfigApService.setDirectionLightCount(directionLightCount)
}

let _setGlobalTempData = (
  {float9Array1, float32Array1}: WonderCore.ISceneGraphRepoForJs.globalTempData,
) => {
  GlobalTempApService.setFloat9Array1(float9Array1)
  GlobalTempApService.setFloat32Array1(float32Array1)
}

// let initForNoWorker = (
//   canvas,
//   {
//     isDebug,
//     transformCount,
//     geometryCount,
//     geometryPointCount,
//     pbrMaterialCount,
//     directionLightCount,
//   }: WonderCore.ISceneGraphRepoForJs.configData,
//   {float9Array1, float32Array1}: WonderCore.ISceneGraphRepoForJs.globalTempData,
// ) => {
//   CanvasApService.setCanvas(canvas)

//   ConfigApService.setIsDebug(isDebug)
//   ConfigApService.setTransformCount(transformCount)
//   ConfigApService.setGeometryCount(geometryCount)
//   ConfigApService.setGeometryPointCount(geometryPointCount)
//   ConfigApService.setPBRMaterialCount(pbrMaterialCount)
//   ConfigApService.setDirectionLightCount(directionLightCount)

//   GlobalTempApService.setFloat9Array1(float9Array1)
//   GlobalTempApService.setFloat32Array1(float32Array1)

//   _createAndSetAllComponentPOs()
// }

// let initForMainWorker = initForNoWorker

// let _createAndSetAllComponentPOsWithSharedArrayBufferData = sharedArrayBufferData => {
//   let {
//     transformSharedArrayBufferData,
//     pbrMaterialSharedArrayBufferData,
//     geometrySharedArrayBufferData,
//     directionLightSharedArrayBufferData,
//   }: SharedArrayBufferDataType.sharedArrayBufferData =
//     sharedArrayBufferData->VODOConvertApService.sharedArrayBufferDataVOToSharedArrayBufferDataDO

//   CreatePOTransformRepo.createPOWithSharedArrayBufferData(
//     transformSharedArrayBufferData,
//   )->ContainerManager.setTransform

//   CreatePOGeometryRepo.createPOWithSharedArrayBufferData(
//     geometrySharedArrayBufferData,
//   )->ContainerManager.setGeometry

//   CreatePOPBRMaterialRepo.createPOWithSharedArrayBufferData(
//     pbrMaterialSharedArrayBufferData,
//   )->ContainerManager.setPBRMaterial

//   CreatePODirectionLightRepo.createPOWithSharedArrayBufferData(
//     directionLightSharedArrayBufferData,
//   )->ContainerManager.setDirectionLight
// }

// let initForRenderWorker = (isDebug, sharedArrayBufferData) => {
//   ConfigApService.setIsDebug(isDebug)

//   _createAndSetAllComponentPOsWithSharedArrayBufferData(sharedArrayBufferData)
// }

let buildSceneGraphRepo = (): WonderCore.ISceneGraphRepoForJs.sceneGraphRepo => {
  setIsDebug: ConfigApService.setIsDebug,
  setComponentCount: _setComponentCount,
  setGlobalTempData: _setGlobalTempData,
  createAndSetAllComponentPOs: () => _createAndSetAllComponentPOs()->WonderCommonlib.Result.getExn,
  getCanvas: () => CanvasApService.getCanvas()->WonderCommonlib.OptionSt.toNullable,
  setCanvas: CanvasApService.setCanvas,
  configRepo: {
    getIsDebug: ConfigApService.getIsDebug,
    setIsDebug: ConfigApService.setIsDebug,
    getTransformCount: ConfigApService.getTransformCount,
    setTransformCount: ConfigApService.setTransformCount,
    // getGeometryCount: ConfigApService.getGeometryCount,
    // setGeometryCount: ConfigApService.setGeometryCount,
    // getGeometryPointCount: ConfigApService.getGeometryPointCount,
    // setGeometryPointCount: ConfigApService.setGeometryPointCount,
    // getDirectionLightCount: ConfigApService.getDirectionLightCount,
    // setDirectionLightCount: ConfigApService.setDirectionLightCount,
    // getPBRMaterialCount: ConfigApService.getPBRMaterialCount,
    // setPBRMaterialCount: ConfigApService.setPBRMaterialCount,
  },
  sceneRepo: {
    create: () => SceneApService.create()->WonderCommonlib.Result.getExn,
    add: SceneApService.add,
    getScene: unit => SceneApService.getScene()->WonderCommonlib.OptionSt.toNullable,
    setScene: SceneApService.setScene,
    getAllGameObjects: scene =>
      SceneApService.getAllGameObjects(scene)->WonderCommonlib.ListSt.toArray,
    // getAllRenderGameObjects: scene =>
    //   SceneApService.getAllRenderGameObjects(scene)->WonderCommonlib.ListSt.toArray,
    // getAllGeometries: scene =>
    //   SceneApService.getAllGameObjectGeometries(scene)->WonderCommonlib.ListSt.toArray,
    // getAllPBRMaterials: scene =>
    //   SceneApService.getAllGameObjectPBRMaterials(scene)->WonderCommonlib.ListSt.toArray,
  },
  gameObjectRepo: {
    create: () => GameObjectApService.create()->WonderCommonlib.Result.getExn,
    addTransform: (gameObject, transform) =>
      GameObjectApService.addTransform(gameObject, transform)->WonderCommonlib.Result.getExn,
    getTransform: gameObject =>
      GameObjectApService.getTransform(gameObject)->WonderCommonlib.OptionSt.toNullable,
    hasTransform: GameObjectApService.hasTransform,
    // addGeometry: (gameObject, geometry) =>
    //   GameObjectApService.addGeometry(gameObject, geometry)->WonderCommonlib.Result.getExn,
    // getGeometry: gameObject =>
    //   GameObjectApService.getGeometry(gameObject)->WonderCommonlib.OptionSt.toNullable,
    // hasGeometry: GameObjectApService.hasGeometry,
    // addPBRMaterial: (gameObject, material) =>
    //   GameObjectApService.addPBRMaterial(gameObject, material)->WonderCommonlib.Result.getExn,
    // getPBRMaterial: gameObject =>
    //   GameObjectApService.getPBRMaterial(gameObject)->WonderCommonlib.OptionSt.toNullable,
    // hasPBRMaterial: GameObjectApService.hasPBRMaterial,
    // addDirectionLight: (gameObject, light) =>
    //   GameObjectApService.addDirectionLight(gameObject, light)->WonderCommonlib.Result.getExn,
    // getDirectionLight: gameObject =>
    //   GameObjectApService.getDirectionLight(gameObject)->WonderCommonlib.OptionSt.toNullable,
    // hasDirectionLight: GameObjectApService.hasDirectionLight,
    // addBasicCameraView: (gameObject, cameraView) =>
    //   GameObjectApService.addBasicCameraView(gameObject, cameraView)->WonderCommonlib.Result.getExn,
    // getBasicCameraView: gameObject =>
    //   GameObjectApService.getBasicCameraView(gameObject)->WonderCommonlib.OptionSt.toNullable,
    // hasBasicCameraView: GameObjectApService.hasBasicCameraView,
    // addPerspectiveCameraProjection: (gameObject, cameraProjection) =>
    //   GameObjectApService.addPerspectiveCameraProjection(
    //     gameObject,
    //     cameraProjection,
    //   )->WonderCommonlib.Result.getExn,
    // getPerspectiveCameraProjection: gameObject =>
    //   GameObjectApService.getPerspectiveCameraProjection(
    //     gameObject,
    //   )->WonderCommonlib.OptionSt.toNullable,
    // hasPerspectiveCameraProjection: GameObjectApService.hasPerspectiveCameraProjection,
    // addArcballCameraController: (gameObject, cameraController) =>
    //   GameObjectApService.addArcballCameraController(
    //     gameObject,
    //     cameraController,
    //   )->WonderCommonlib.Result.getExn,
    // getArcballCameraController: gameObject =>
    //   GameObjectApService.getArcballCameraController(
    //     gameObject,
    //   )->WonderCommonlib.OptionSt.toNullable,
    // hasArcballCameraController: GameObjectApService.hasArcballCameraController,
  },
  transformRepo: {
    getIndex: TransformApService.getIndex,
    toComponent: TransformApService.toComponent,
    create: () => TransformApService.create()->WonderCommonlib.Result.getExn,
    getGameObject: transform =>
      TransformApService.getGameObject(transform)->WonderCommonlib.OptionSt.toNullable,
    getParent: transform =>
      TransformApService.getParent(transform)->WonderCommonlib.OptionSt.toNullable,
    hasParent: TransformApService.hasParent,
    removeParent: TransformApService.removeParent,
    getChildren: transform =>
      TransformApService.getChildren(transform)
      ->WonderCommonlib.OptionSt.map(WonderCommonlib.ListSt.toArray)
      ->WonderCommonlib.OptionSt.toNullable,
    getLocalPosition: TransformApService.getLocalPosition,
    setLocalPosition: (transform, localPosition) =>
      TransformApService.setLocalPosition(transform, localPosition)->WonderCommonlib.Result.getExn,
    getPosition: TransformApService.getPosition,
    setPosition: (transform, position) =>
      TransformApService.setPosition(transform, position)->WonderCommonlib.Result.getExn,
    getLocalRotation: TransformApService.getLocalRotation,
    setLocalRotation: (transform, localRotation) =>
      TransformApService.setLocalRotation(transform, localRotation)->WonderCommonlib.Result.getExn,
    getRotation: TransformApService.getRotation,
    setRotation: (transform, rotation) =>
      TransformApService.setRotation(transform, rotation)->WonderCommonlib.Result.getExn,
    getLocalScale: TransformApService.getLocalScale,
    setLocalScale: (transform, localScale) =>
      TransformApService.setLocalScale(transform, localScale)->WonderCommonlib.Result.getExn,
    getScale: TransformApService.getScale,
    setScale: (transform, scale) =>
      TransformApService.setScale(transform, scale)->WonderCommonlib.Result.getExn,
    getLocalEulerAngles: TransformApService.getLocalEulerAngles,
    setLocalEulerAngles: (transform, localEulerAngles) =>
      TransformApService.setLocalEulerAngles(
        transform,
        localEulerAngles,
      )->WonderCommonlib.Result.getExn,
    getEulerAngles: TransformApService.getEulerAngles,
    setEulerAngles: (transform, eulerAngles) =>
      TransformApService.setEulerAngles(transform, eulerAngles)->WonderCommonlib.Result.getExn,
    // rotateLocalOnAxis: (transform, (angle, localAxis)) =>
    //   TransformApService.rotateLocalOnAxis(
    //     transform,
    //     (angle, localAxis),
    //   )->WonderCommonlib.Result.getExn,
    // rotateWorldOnAxis: (transform, (angle, localAxis)) =>
    //   TransformApService.rotateWorldOnAxis(
    //     transform,
    //     (angle, localAxis),
    //   )->WonderCommonlib.Result.getExn,
    getLocalToWorldMatrix: TransformApService.getLocalToWorldMatrix,
    getNormalMatrix: transform =>
      TransformApService.getNormalMatrix(transform)->WonderCommonlib.Result.getExn,
    // lookAt: (transform, target) =>
    //   TransformApService.lookAt(transform, target)->WonderCommonlib.Result.getExn,
    // getSharedArrayBufferData:()
    // update: () => TransformApService.update(),
    getAllTransforms: () => TransformApService.getAllTransforms()->WonderCommonlib.ListSt.toArray,
    updateTransform: TransformApService.updateTransform,
  },
  // geometryRepo: {
  //   getIndex: GeometryApService.getIndex,
  //   toComponent: GeometryApService.toComponent,
  //   create: () => GeometryApService.create()->WonderCommonlib.Result.getExn,
  //   createTriangleGeometry: () =>
  //     GeometryApService.createTriangleGeometry()->WonderCommonlib.Result.getExn,
  //   createSphereGeometry: (radius, bands) =>
  //     GeometryApService.createSphereGeometry(radius, bands)->WonderCommonlib.Result.getExn,
  //   createPlaneGeometry: (width, height, widthSegments, heightSegments) =>
  //     GeometryApService.createPlaneGeometry(
  //       width,
  //       height,
  //       widthSegments,
  //       heightSegments,
  //     )->WonderCommonlib.Result.getExn,
  //   getGameObjects: geometry =>
  //     GeometryApService.getGameObjects(geometry)
  //     ->WonderCommonlib.OptionSt.map(WonderCommonlib.ListSt.toArray)
  //     ->WonderCommonlib.OptionSt.toNullable,
  //   getVertices: geometry =>
  //     GeometryApService.getVertices(geometry)->WonderCommonlib.Result.toNullable,
  //   setVertices: (geometry, vertices) =>
  //     GeometryApService.setVertices(geometry, vertices)->WonderCommonlib.Result.getExn,
  //   getNormals: geometry =>
  //     GeometryApService.getNormals(geometry)->WonderCommonlib.Result.toNullable,
  //   setNormals: (geometry, normals) =>
  //     GeometryApService.setNormals(geometry, normals)->WonderCommonlib.Result.getExn,
  //   getTexCoords: geometry =>
  //     GeometryApService.getTexCoords(geometry)->WonderCommonlib.Result.toNullable,
  //   setTexCoords: (geometry, texCoords) =>
  //     GeometryApService.setTexCoords(geometry, texCoords)->WonderCommonlib.Result.getExn,
  //   getTangents: geometry =>
  //     GeometryApService.getTangents(geometry)->WonderCommonlib.Result.toNullable,
  //   setTangents: (geometry, tangents) =>
  //     GeometryApService.setTangents(geometry, tangents)->WonderCommonlib.Result.getExn,
  //   getIndices: geometry =>
  //     GeometryApService.getIndices(geometry)->WonderCommonlib.Result.toNullable,
  //   setIndices: (geometry, indices) =>
  //     GeometryApService.setIndices(geometry, indices)->WonderCommonlib.Result.getExn,
  //   hasVertices: geometry => GeometryApService.hasVertices(geometry)->WonderCommonlib.Result.getExn,
  //   hasNormals: geometry => GeometryApService.hasNormals(geometry)->WonderCommonlib.Result.getExn,
  //   hasTexCoords: geometry =>
  //     GeometryApService.hasTexCoords(geometry)->WonderCommonlib.Result.getExn,
  //   hasTangents: geometry => GeometryApService.hasTangents(geometry)->WonderCommonlib.Result.getExn,
  //   hasIndices: geometry => GeometryApService.hasIndices(geometry)->WonderCommonlib.Result.getExn,
  //   getIndicesCount: geometry =>
  //     GeometryApService.getIndicesCount(geometry)->WonderCommonlib.Result.toNullable,
  //   computeTangents: GeometryApService.computeTangents,
  // },
  // pbrMaterialRepo: {
  //   getIndex: PBRMaterialApService.getIndex,
  //   toComponent: PBRMaterialApService.toComponent,
  //   create: () => PBRMaterialApService.create()->WonderCommonlib.Result.getExn,
  //   getGameObjects: pbrMaterial =>
  //     PBRMaterialApService.getGameObjects(pbrMaterial)
  //     ->WonderCommonlib.OptionSt.map(WonderCommonlib.ListSt.toArray)
  //     ->WonderCommonlib.OptionSt.toNullable,
  //   getDiffuseColor: material => PBRMaterialApService.getDiffuseColor(material),
  //   setDiffuseColor: (material, color) =>
  //     PBRMaterialApService.setDiffuseColor(material, color)->WonderCommonlib.Result.getExn,
  //   getSpecularColor: material => PBRMaterialApService.getSpecularColor(material),
  //   setSpecularColor: (material, color) =>
  //     PBRMaterialApService.setSpecularColor(material, color)->WonderCommonlib.Result.getExn,
  //   getSpecular: material => PBRMaterialApService.getSpecular(material),
  //   setSpecular: (material, specular) =>
  //     PBRMaterialApService.setSpecular(material, specular)->WonderCommonlib.Result.getExn,
  //   getRoughness: material => PBRMaterialApService.getRoughness(material),
  //   setRoughness: (material, roughness) =>
  //     PBRMaterialApService.setRoughness(material, roughness)->WonderCommonlib.Result.getExn,
  //   getMetalness: material => PBRMaterialApService.getMetalness(material),
  //   setMetalness: (material, metalness) =>
  //     PBRMaterialApService.setMetalness(material, metalness)->WonderCommonlib.Result.getExn,
  //   getTransmission: material => PBRMaterialApService.getTransmission(material),
  //   setTransmission: (material, transmission) =>
  //     PBRMaterialApService.setTransmission(material, transmission)->WonderCommonlib.Result.getExn,
  //   getIOR: material => PBRMaterialApService.getIOR(material),
  //   setIOR: (material, ior) =>
  //     PBRMaterialApService.setIOR(material, ior)->WonderCommonlib.Result.getExn,
  //   getDiffuseMap: material =>
  //     PBRMaterialApService.getDiffuseMap(material)->WonderCommonlib.OptionSt.toNullable,
  //   setDiffuseMap: (material, map) => PBRMaterialApService.setDiffuseMap(material, map),
  //   getChannelRoughnessMetallicMap: material =>
  //     PBRMaterialApService.getChannelRoughnessMetallicMap(
  //       material,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   setChannelRoughnessMetallicMap: (material, map) =>
  //     PBRMaterialApService.setChannelRoughnessMetallicMap(material, map),
  //   getEmissionMap: material =>
  //     PBRMaterialApService.getEmissionMap(material)->WonderCommonlib.OptionSt.toNullable,
  //   setEmissionMap: (material, map) => PBRMaterialApService.setEmissionMap(material, map),
  //   getNormalMap: material =>
  //     PBRMaterialApService.getNormalMap(material)->WonderCommonlib.OptionSt.toNullable,
  //   setNormalMap: (material, map) => PBRMaterialApService.setNormalMap(material, map),
  //   getTransmissionMap: material =>
  //     PBRMaterialApService.getTransmissionMap(material)->WonderCommonlib.OptionSt.toNullable,
  //   setTransmissionMap: (material, map) => PBRMaterialApService.setTransmissionMap(material, map),
  //   getSpecularMap: material =>
  //     PBRMaterialApService.getSpecularMap(material)->WonderCommonlib.OptionSt.toNullable,
  //   setSpecularMap: (material, map) => PBRMaterialApService.setSpecularMap(material, map),
  // },
  // directionLightRepo: {
  //   getIndex: DirectionLightApService.getIndex,
  //   toComponent: DirectionLightApService.toComponent,
  //   create: () => DirectionLightApService.create()->WonderCommonlib.Result.getExn,
  //   getGameObject: light =>
  //     DirectionLightApService.getGameObject(light)->WonderCommonlib.OptionSt.toNullable,
  //   getColor: light => DirectionLightApService.getColor(light),
  //   setColor: (light, color) =>
  //     DirectionLightApService.setColor(light, color)->WonderCommonlib.Result.getExn,
  //   getIntensity: light => DirectionLightApService.getIntensity(light),
  //   setIntensity: (light, intensity) =>
  //     DirectionLightApService.setIntensity(light, intensity)->WonderCommonlib.Result.getExn,
  //   getAllLights: () => DirectionLightApService.getAllLights(),
  //   getDirection: light =>
  //     DirectionLightApService.getDirection(light)->WonderCommonlib.OptionSt.toNullable,
  //   getLightCount: () => DirectionLightApService.getLightCount(),
  // },
  // basicCameraViewRepo: {
  //   getIndex: BasicCameraViewApService.getIndex,
  //   toComponent: BasicCameraViewApService.toComponent,
  //   create: () => BasicCameraViewApService.create(),
  //   getGameObject: cameraView =>
  //     BasicCameraViewApService.getGameObject(cameraView)->WonderCommonlib.OptionSt.toNullable,
  //   getViewWorldToCameraMatrix: cameraView =>
  //     BasicCameraViewApService.getViewWorldToCameraMatrix(cameraView)
  //     ->WonderCommonlib.Result.mapSuccess(WonderCommonlib.OptionSt.toNullable)
  //     ->WonderCommonlib.Result.getExn,
  //   isActive: cameraView => BasicCameraViewApService.isActive(cameraView),
  //   active: cameraView => BasicCameraViewApService.active(cameraView),
  //   unactive: cameraView => BasicCameraViewApService.unactive(cameraView),
  //   setActive: (cameraView, isActive) => BasicCameraViewApService.setActive(cameraView, isActive),
  //   getActiveBasicCameraView: () =>
  //     BasicCameraViewApService.getActiveBasicCameraView()
  //     ->WonderCommonlib.Result.mapSuccess(WonderCommonlib.OptionSt.toNullable)
  //     ->WonderCommonlib.Result.getExn,
  // },
  // perspectiveCameraProjectionRepo: {
  //   getIndex: PerspectiveCameraProjectionApService.getIndex,
  //   toComponent: PerspectiveCameraProjectionApService.toComponent,
  //   create: () => PerspectiveCameraProjectionApService.create(),
  //   getGameObject: cameraProjection =>
  //     PerspectiveCameraProjectionApService.getGameObject(
  //       cameraProjection,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   getPMatrix: cameraProjection =>
  //     PerspectiveCameraProjectionApService.getPMatrix(
  //       cameraProjection,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   getFovy: cameraProjection =>
  //     PerspectiveCameraProjectionApService.getFovy(
  //       cameraProjection,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   setFovy: (cameraProjection, fovy) =>
  //     PerspectiveCameraProjectionApService.setFovy(cameraProjection, fovy),
  //   getAspect: cameraProjection =>
  //     PerspectiveCameraProjectionApService.getAspect(
  //       cameraProjection,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   setAspect: (cameraProjection, fovy) =>
  //     PerspectiveCameraProjectionApService.setAspect(cameraProjection, fovy),
  //   getNear: cameraProjection =>
  //     PerspectiveCameraProjectionApService.getNear(
  //       cameraProjection,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   setNear: (cameraProjection, fovy) =>
  //     PerspectiveCameraProjectionApService.setNear(cameraProjection, fovy),
  //   getFar: cameraProjection =>
  //     PerspectiveCameraProjectionApService.getFar(
  //       cameraProjection,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   setFar: (cameraProjection, fovy) =>
  //     PerspectiveCameraProjectionApService.setFar(cameraProjection, fovy),
  //   markDirty: cameraProjection => PerspectiveCameraProjectionApService.markDirty(cameraProjection),
  //   markNotDirty: cameraProjection =>
  //     PerspectiveCameraProjectionApService.markNotDirty(cameraProjection),
  //   update: () => PerspectiveCameraProjectionApService.update()->WonderCommonlib.Result.getExn,
  // },
  // arcballCameraControllerRepo: {
  //   getIndex: ArcballCameraControllerApService.getIndex,
  //   toComponent: ArcballCameraControllerApService.toComponent,
  //   create: () => ArcballCameraControllerApService.create(),
  //   getGameObject: cameraController =>
  //     ArcballCameraControllerApService.getGameObject(
  //       cameraController,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   getDistance: cameraController =>
  //     ArcballCameraControllerApService.getDistance(
  //       cameraController,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   setDistance: (cameraController, distance) =>
  //     ArcballCameraControllerApService.setDistance(
  //       cameraController,
  //       distance,
  //     )->WonderCommonlib.Result.getExn,
  //   getMinDistance: cameraController =>
  //     ArcballCameraControllerApService.getMinDistance(
  //       cameraController,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   setMinDistance: (cameraController, minDistance) =>
  //     ArcballCameraControllerApService.setMinDistance(cameraController, minDistance),
  //   getWheelSpeed: cameraController =>
  //     ArcballCameraControllerApService.getWheelSpeed(
  //       cameraController,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   setWheelSpeed: (cameraController, wheelSpeed) =>
  //     ArcballCameraControllerApService.setWheelSpeed(cameraController, wheelSpeed),
  //   getPhi: cameraController =>
  //     ArcballCameraControllerApService.getPhi(
  //       cameraController,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   setPhi: (cameraController, phi) =>
  //     ArcballCameraControllerApService.setPhi(cameraController, phi),
  //   getTheta: cameraController =>
  //     ArcballCameraControllerApService.getTheta(
  //       cameraController,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   setTheta: (cameraController, theta) =>
  //     ArcballCameraControllerApService.setTheta(
  //       cameraController,
  //       theta,
  //     )->WonderCommonlib.Result.getExn,
  //   getThetaMargin: cameraController =>
  //     ArcballCameraControllerApService.getThetaMargin(
  //       cameraController,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   setThetaMargin: (cameraController, thetaMargin) =>
  //     ArcballCameraControllerApService.setThetaMargin(
  //       cameraController,
  //       thetaMargin,
  //     )->WonderCommonlib.Result.getExn,
  //   getTarget: cameraController =>
  //     ArcballCameraControllerApService.getTarget(
  //       cameraController,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   setTarget: (cameraController, target) =>
  //     ArcballCameraControllerApService.setTarget(cameraController, target),
  //   getRotateSpeed: cameraController =>
  //     ArcballCameraControllerApService.getRotateSpeed(
  //       cameraController,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   setRotateSpeed: (cameraController, rotateSpeed) =>
  //     ArcballCameraControllerApService.setRotateSpeed(cameraController, rotateSpeed),
  //   getMoveSpeedX: cameraController =>
  //     ArcballCameraControllerApService.getMoveSpeedX(
  //       cameraController,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   setMoveSpeedX: (cameraController, moveSpeedX) =>
  //     ArcballCameraControllerApService.setMoveSpeedX(cameraController, moveSpeedX),
  //   getMoveSpeedY: cameraController =>
  //     ArcballCameraControllerApService.getMoveSpeedY(
  //       cameraController,
  //     )->WonderCommonlib.OptionSt.toNullable,
  //   setMoveSpeedY: (cameraController, moveSpeedY) =>
  //     ArcballCameraControllerApService.setMoveSpeedY(cameraController, moveSpeedY),
  //   update: () => ArcballCameraControllerApService.update()->WonderCommonlib.Result.getExn,
  // },
}

// let buildSceneGraphRepoForMainWorker = (): WonderCore.ISceneGraphRepoForJs.sceneGraphRepoForMainWorker => {
//   init: (canvas, configData, globalTempData) =>
//     initForNoWorker(canvas, configData, globalTempData)->WonderCommonlib.Result.getExn,
//   getCanvas: () => CanvasApService.getCanvas()->WonderCommonlib.OptionSt.toNullable,
//   configRepo: {
//     getIsDebug: ConfigApService.getIsDebug,
//     setIsDebug: ConfigApService.setIsDebug,
//     getTransformCount: ConfigApService.getTransformCount,
//     setTransformCount: ConfigApService.setTransformCount,
//     getGeometryCount: ConfigApService.getGeometryCount,
//     setGeometryCount: ConfigApService.setGeometryCount,
//     getGeometryPointCount: ConfigApService.getGeometryPointCount,
//     setGeometryPointCount: ConfigApService.setGeometryPointCount,
//     getDirectionLightCount: ConfigApService.getDirectionLightCount,
//     setDirectionLightCount: ConfigApService.setDirectionLightCount,
//     getPBRMaterialCount: ConfigApService.getPBRMaterialCount,
//     setPBRMaterialCount: ConfigApService.setPBRMaterialCount,
//   },
//   sceneRepo: {
//     create: () => SceneApService.create()->WonderCommonlib.Result.getExn,
//     add: SceneApService.add,
//     getScene: unit => SceneApService.getScene()->WonderCommonlib.OptionSt.toNullable,
//     setScene: SceneApService.setScene,
//     getAllGameObjects: scene =>
//       SceneApService.getAllGameObjects(scene)->WonderCommonlib.ListSt.toArray,
//     getAllRenderGameObjects: scene =>
//       SceneApService.getAllRenderGameObjects(scene)->WonderCommonlib.ListSt.toArray,
//     getAllGeometries: scene =>
//       SceneApService.getAllGameObjectGeometries(scene)->WonderCommonlib.ListSt.toArray,
//     getAllPBRMaterials: scene =>
//       SceneApService.getAllGameObjectPBRMaterials(scene)->WonderCommonlib.ListSt.toArray,
//   },
//   gameObjectRepo: {
//     create: () => GameObjectApService.create()->WonderCommonlib.Result.getExn,
//     addTransform: (gameObject, transform) =>
//       GameObjectApService.addTransform(gameObject, transform)->WonderCommonlib.Result.getExn,
//     getTransform: gameObject =>
//       GameObjectApService.getTransform(gameObject)->WonderCommonlib.OptionSt.toNullable,
//     hasTransform: GameObjectApService.hasTransform,
//     addGeometry: (gameObject, geometry) =>
//       GameObjectApService.addGeometry(gameObject, geometry)->WonderCommonlib.Result.getExn,
//     getGeometry: gameObject =>
//       GameObjectApService.getGeometry(gameObject)->WonderCommonlib.OptionSt.toNullable,
//     hasGeometry: GameObjectApService.hasGeometry,
//     addPBRMaterial: (gameObject, material) =>
//       GameObjectApService.addPBRMaterial(gameObject, material)->WonderCommonlib.Result.getExn,
//     getPBRMaterial: gameObject =>
//       GameObjectApService.getPBRMaterial(gameObject)->WonderCommonlib.OptionSt.toNullable,
//     hasPBRMaterial: GameObjectApService.hasPBRMaterial,
//     addDirectionLight: (gameObject, light) =>
//       GameObjectApService.addDirectionLight(gameObject, light)->WonderCommonlib.Result.getExn,
//     getDirectionLight: gameObject =>
//       GameObjectApService.getDirectionLight(gameObject)->WonderCommonlib.OptionSt.toNullable,
//     hasDirectionLight: GameObjectApService.hasDirectionLight,
//     addBasicCameraView: (gameObject, cameraView) =>
//       GameObjectApService.addBasicCameraView(gameObject, cameraView)->WonderCommonlib.Result.getExn,
//     getBasicCameraView: gameObject =>
//       GameObjectApService.getBasicCameraView(gameObject)->WonderCommonlib.OptionSt.toNullable,
//     hasBasicCameraView: GameObjectApService.hasBasicCameraView,
//     addPerspectiveCameraProjection: (gameObject, cameraProjection) =>
//       GameObjectApService.addPerspectiveCameraProjection(
//         gameObject,
//         cameraProjection,
//       )->WonderCommonlib.Result.getExn,
//     getPerspectiveCameraProjection: gameObject =>
//       GameObjectApService.getPerspectiveCameraProjection(
//         gameObject,
//       )->WonderCommonlib.OptionSt.toNullable,
//     hasPerspectiveCameraProjection: GameObjectApService.hasPerspectiveCameraProjection,
//     addArcballCameraController: (gameObject, cameraController) =>
//       GameObjectApService.addArcballCameraController(
//         gameObject,
//         cameraController,
//       )->WonderCommonlib.Result.getExn,
//     getArcballCameraController: gameObject =>
//       GameObjectApService.getArcballCameraController(
//         gameObject,
//       )->WonderCommonlib.OptionSt.toNullable,
//     hasArcballCameraController: GameObjectApService.hasArcballCameraController,
//   },
//   transformRepo: {
//     getIndex: TransformApService.getIndex,
//     toComponent: TransformApService.toComponent,
//     create: () => TransformApService.create()->WonderCommonlib.Result.getExn,
//     getGameObject: transform =>
//       TransformApService.getGameObject(transform)->WonderCommonlib.OptionSt.toNullable,
//     getParent: transform =>
//       TransformApService.getParent(transform)->WonderCommonlib.OptionSt.toNullable,
//     hasParent: TransformApService.hasParent,
//     removeParent: TransformApService.removeParent,
//     getChildren: transform =>
//       TransformApService.getChildren(transform)
//       ->WonderCommonlib.OptionSt.map(WonderCommonlib.ListSt.toArray)
//       ->WonderCommonlib.OptionSt.toNullable,
//     getLocalPosition: TransformApService.getLocalPosition,
//     setLocalPosition: (transform, localPosition) =>
//       TransformApService.setLocalPosition(transform, localPosition)->WonderCommonlib.Result.getExn,
//     getPosition: TransformApService.getPosition,
//     setPosition: (transform, position) =>
//       TransformApService.setPosition(transform, position)->WonderCommonlib.Result.getExn,
//     getLocalRotation: TransformApService.getLocalRotation,
//     setLocalRotation: (transform, localRotation) =>
//       TransformApService.setLocalRotation(transform, localRotation)->WonderCommonlib.Result.getExn,
//     getRotation: TransformApService.getRotation,
//     setRotation: (transform, rotation) =>
//       TransformApService.setRotation(transform, rotation)->WonderCommonlib.Result.getExn,
//     getLocalScale: TransformApService.getLocalScale,
//     setLocalScale: (transform, localScale) =>
//       TransformApService.setLocalScale(transform, localScale)->WonderCommonlib.Result.getExn,
//     getScale: TransformApService.getScale,
//     setScale: (transform, scale) =>
//       TransformApService.setScale(transform, scale)->WonderCommonlib.Result.getExn,
//     getLocalEulerAngles: TransformApService.getLocalEulerAngles,
//     setLocalEulerAngles: (transform, localEulerAngles) =>
//       TransformApService.setLocalEulerAngles(
//         transform,
//         localEulerAngles,
//       )->WonderCommonlib.Result.getExn,
//     getEulerAngles: TransformApService.getEulerAngles,
//     setEulerAngles: (transform, eulerAngles) =>
//       TransformApService.setEulerAngles(transform, eulerAngles)->WonderCommonlib.Result.getExn,
//     rotateLocalOnAxis: (transform, (angle, localAxis)) =>
//       TransformApService.rotateLocalOnAxis(
//         transform,
//         (angle, localAxis),
//       )->WonderCommonlib.Result.getExn,
//     rotateWorldOnAxis: (transform, (angle, localAxis)) =>
//       TransformApService.rotateWorldOnAxis(
//         transform,
//         (angle, localAxis),
//       )->WonderCommonlib.Result.getExn,
//     getLocalToWorldMatrix: TransformApService.getLocalToWorldMatrix,
//     getNormalMatrix: transform =>
//       TransformApService.getNormalMatrix(transform)->WonderCommonlib.Result.getExn,
//     lookAt: (transform, target) =>
//       TransformApService.lookAt(transform, target)->WonderCommonlib.Result.getExn,
//     // getSharedArrayBufferData:()
//     update: () => TransformApService.update(),
//   },
//   geometryRepo: {
//     getIndex: GeometryApService.getIndex,
//     toComponent: GeometryApService.toComponent,
//     create: () => GeometryApService.create()->WonderCommonlib.Result.getExn,
//     createTriangleGeometry: () =>
//       GeometryApService.createTriangleGeometry()->WonderCommonlib.Result.getExn,
//     createSphereGeometry: (radius, bands) =>
//       GeometryApService.createSphereGeometry(radius, bands)->WonderCommonlib.Result.getExn,
//     createPlaneGeometry: (width, height, widthSegments, heightSegments) =>
//       GeometryApService.createPlaneGeometry(
//         width,
//         height,
//         widthSegments,
//         heightSegments,
//       )->WonderCommonlib.Result.getExn,
//     getGameObjects: geometry =>
//       GeometryApService.getGameObjects(geometry)
//       ->WonderCommonlib.OptionSt.map(WonderCommonlib.ListSt.toArray)
//       ->WonderCommonlib.OptionSt.toNullable,
//     getVertices: geometry =>
//       GeometryApService.getVertices(geometry)->WonderCommonlib.Result.toNullable,
//     setVertices: (geometry, vertices) =>
//       GeometryApService.setVertices(geometry, vertices)->WonderCommonlib.Result.getExn,
//     getNormals: geometry =>
//       GeometryApService.getNormals(geometry)->WonderCommonlib.Result.toNullable,
//     setNormals: (geometry, normals) =>
//       GeometryApService.setNormals(geometry, normals)->WonderCommonlib.Result.getExn,
//     getTexCoords: geometry =>
//       GeometryApService.getTexCoords(geometry)->WonderCommonlib.Result.toNullable,
//     setTexCoords: (geometry, texCoords) =>
//       GeometryApService.setTexCoords(geometry, texCoords)->WonderCommonlib.Result.getExn,
//     getTangents: geometry =>
//       GeometryApService.getTangents(geometry)->WonderCommonlib.Result.toNullable,
//     setTangents: (geometry, tangents) =>
//       GeometryApService.setTangents(geometry, tangents)->WonderCommonlib.Result.getExn,
//     getIndices: geometry =>
//       GeometryApService.getIndices(geometry)->WonderCommonlib.Result.toNullable,
//     setIndices: (geometry, indices) =>
//       GeometryApService.setIndices(geometry, indices)->WonderCommonlib.Result.getExn,
//     hasVertices: geometry => GeometryApService.hasVertices(geometry)->WonderCommonlib.Result.getExn,
//     hasNormals: geometry => GeometryApService.hasNormals(geometry)->WonderCommonlib.Result.getExn,
//     hasTexCoords: geometry =>
//       GeometryApService.hasTexCoords(geometry)->WonderCommonlib.Result.getExn,
//     hasTangents: geometry => GeometryApService.hasTangents(geometry)->WonderCommonlib.Result.getExn,
//     hasIndices: geometry => GeometryApService.hasIndices(geometry)->WonderCommonlib.Result.getExn,
//     getIndicesCount: geometry =>
//       GeometryApService.getIndicesCount(geometry)->WonderCommonlib.Result.toNullable,
//     computeTangents: GeometryApService.computeTangents,
//   },
//   pbrMaterialRepo: {
//     getIndex: PBRMaterialApService.getIndex,
//     toComponent: PBRMaterialApService.toComponent,
//     create: () => PBRMaterialApService.create()->WonderCommonlib.Result.getExn,
//     getGameObjects: pbrMaterial =>
//       PBRMaterialApService.getGameObjects(pbrMaterial)
//       ->WonderCommonlib.OptionSt.map(WonderCommonlib.ListSt.toArray)
//       ->WonderCommonlib.OptionSt.toNullable,
//     getDiffuseColor: material => PBRMaterialApService.getDiffuseColor(material),
//     setDiffuseColor: (material, color) =>
//       PBRMaterialApService.setDiffuseColor(material, color)->WonderCommonlib.Result.getExn,
//     getSpecularColor: material => PBRMaterialApService.getSpecularColor(material),
//     setSpecularColor: (material, color) =>
//       PBRMaterialApService.setSpecularColor(material, color)->WonderCommonlib.Result.getExn,
//     getSpecular: material => PBRMaterialApService.getSpecular(material),
//     setSpecular: (material, specular) =>
//       PBRMaterialApService.setSpecular(material, specular)->WonderCommonlib.Result.getExn,
//     getRoughness: material => PBRMaterialApService.getRoughness(material),
//     setRoughness: (material, roughness) =>
//       PBRMaterialApService.setRoughness(material, roughness)->WonderCommonlib.Result.getExn,
//     getMetalness: material => PBRMaterialApService.getMetalness(material),
//     setMetalness: (material, metalness) =>
//       PBRMaterialApService.setMetalness(material, metalness)->WonderCommonlib.Result.getExn,
//     getTransmission: material => PBRMaterialApService.getTransmission(material),
//     setTransmission: (material, transmission) =>
//       PBRMaterialApService.setTransmission(material, transmission)->WonderCommonlib.Result.getExn,
//     getIOR: material => PBRMaterialApService.getIOR(material),
//     setIOR: (material, ior) =>
//       PBRMaterialApService.setIOR(material, ior)->WonderCommonlib.Result.getExn,
//     getDiffuseMap: material =>
//       PBRMaterialApService.getDiffuseMap(material)->WonderCommonlib.OptionSt.toNullable,
//     setDiffuseMap: (material, map) => PBRMaterialApService.setDiffuseMap(material, map),
//     getChannelRoughnessMetallicMap: material =>
//       PBRMaterialApService.getChannelRoughnessMetallicMap(
//         material,
//       )->WonderCommonlib.OptionSt.toNullable,
//     setChannelRoughnessMetallicMap: (material, map) =>
//       PBRMaterialApService.setChannelRoughnessMetallicMap(material, map),
//     getEmissionMap: material =>
//       PBRMaterialApService.getEmissionMap(material)->WonderCommonlib.OptionSt.toNullable,
//     setEmissionMap: (material, map) => PBRMaterialApService.setEmissionMap(material, map),
//     getNormalMap: material =>
//       PBRMaterialApService.getNormalMap(material)->WonderCommonlib.OptionSt.toNullable,
//     setNormalMap: (material, map) => PBRMaterialApService.setNormalMap(material, map),
//     getTransmissionMap: material =>
//       PBRMaterialApService.getTransmissionMap(material)->WonderCommonlib.OptionSt.toNullable,
//     setTransmissionMap: (material, map) => PBRMaterialApService.setTransmissionMap(material, map),
//     getSpecularMap: material =>
//       PBRMaterialApService.getSpecularMap(material)->WonderCommonlib.OptionSt.toNullable,
//     setSpecularMap: (material, map) => PBRMaterialApService.setSpecularMap(material, map),
//   },
//   directionLightRepo: {
//     getIndex: DirectionLightApService.getIndex,
//     toComponent: DirectionLightApService.toComponent,
//     create: () => DirectionLightApService.create()->WonderCommonlib.Result.getExn,
//     getGameObject: light =>
//       DirectionLightApService.getGameObject(light)->WonderCommonlib.OptionSt.toNullable,
//     getColor: light => DirectionLightApService.getColor(light),
//     setColor: (light, color) =>
//       DirectionLightApService.setColor(light, color)->WonderCommonlib.Result.getExn,
//     getIntensity: light => DirectionLightApService.getIntensity(light),
//     setIntensity: (light, intensity) =>
//       DirectionLightApService.setIntensity(light, intensity)->WonderCommonlib.Result.getExn,
//     getAllLights: () => DirectionLightApService.getAllLights(),
//     getDirection: light =>
//       DirectionLightApService.getDirection(light)->WonderCommonlib.OptionSt.toNullable,
//     getLightCount: () => DirectionLightApService.getLightCount(),
//   },
//   basicCameraViewRepo: {
//     getIndex: BasicCameraViewApService.getIndex,
//     toComponent: BasicCameraViewApService.toComponent,
//     create: () => BasicCameraViewApService.create(),
//     getGameObject: cameraView =>
//       BasicCameraViewApService.getGameObject(cameraView)->WonderCommonlib.OptionSt.toNullable,
//     getViewWorldToCameraMatrix: cameraView =>
//       BasicCameraViewApService.getViewWorldToCameraMatrix(cameraView)
//       ->WonderCommonlib.Result.mapSuccess(WonderCommonlib.OptionSt.toNullable)
//       ->WonderCommonlib.Result.getExn,
//     isActive: cameraView => BasicCameraViewApService.isActive(cameraView),
//     active: cameraView => BasicCameraViewApService.active(cameraView),
//     unactive: cameraView => BasicCameraViewApService.unactive(cameraView),
//     setActive: (cameraView, isActive) => BasicCameraViewApService.setActive(cameraView, isActive),
//     getActiveBasicCameraView: () =>
//       BasicCameraViewApService.getActiveBasicCameraView()
//       ->WonderCommonlib.Result.mapSuccess(WonderCommonlib.OptionSt.toNullable)
//       ->WonderCommonlib.Result.getExn,
//   },
//   perspectiveCameraProjectionRepo: {
//     getIndex: PerspectiveCameraProjectionApService.getIndex,
//     toComponent: PerspectiveCameraProjectionApService.toComponent,
//     create: () => PerspectiveCameraProjectionApService.create(),
//     getGameObject: cameraProjection =>
//       PerspectiveCameraProjectionApService.getGameObject(
//         cameraProjection,
//       )->WonderCommonlib.OptionSt.toNullable,
//     getPMatrix: cameraProjection =>
//       PerspectiveCameraProjectionApService.getPMatrix(
//         cameraProjection,
//       )->WonderCommonlib.OptionSt.toNullable,
//     getFovy: cameraProjection =>
//       PerspectiveCameraProjectionApService.getFovy(
//         cameraProjection,
//       )->WonderCommonlib.OptionSt.toNullable,
//     setFovy: (cameraProjection, fovy) =>
//       PerspectiveCameraProjectionApService.setFovy(cameraProjection, fovy),
//     getAspect: cameraProjection =>
//       PerspectiveCameraProjectionApService.getAspect(
//         cameraProjection,
//       )->WonderCommonlib.OptionSt.toNullable,
//     setAspect: (cameraProjection, fovy) =>
//       PerspectiveCameraProjectionApService.setAspect(cameraProjection, fovy),
//     getNear: cameraProjection =>
//       PerspectiveCameraProjectionApService.getNear(
//         cameraProjection,
//       )->WonderCommonlib.OptionSt.toNullable,
//     setNear: (cameraProjection, fovy) =>
//       PerspectiveCameraProjectionApService.setNear(cameraProjection, fovy),
//     getFar: cameraProjection =>
//       PerspectiveCameraProjectionApService.getFar(
//         cameraProjection,
//       )->WonderCommonlib.OptionSt.toNullable,
//     setFar: (cameraProjection, fovy) =>
//       PerspectiveCameraProjectionApService.setFar(cameraProjection, fovy),
//     markDirty: cameraProjection => PerspectiveCameraProjectionApService.markDirty(cameraProjection),
//     markNotDirty: cameraProjection =>
//       PerspectiveCameraProjectionApService.markNotDirty(cameraProjection),
//     update: () => PerspectiveCameraProjectionApService.update()->WonderCommonlib.Result.getExn,
//   },
//   arcballCameraControllerRepo: {
//     getIndex: ArcballCameraControllerApService.getIndex,
//     toComponent: ArcballCameraControllerApService.toComponent,
//     create: () => ArcballCameraControllerApService.create(),
//     getGameObject: cameraController =>
//       ArcballCameraControllerApService.getGameObject(
//         cameraController,
//       )->WonderCommonlib.OptionSt.toNullable,
//     getDistance: cameraController =>
//       ArcballCameraControllerApService.getDistance(
//         cameraController,
//       )->WonderCommonlib.OptionSt.toNullable,
//     setDistance: (cameraController, distance) =>
//       ArcballCameraControllerApService.setDistance(
//         cameraController,
//         distance,
//       )->WonderCommonlib.Result.getExn,
//     getMinDistance: cameraController =>
//       ArcballCameraControllerApService.getMinDistance(
//         cameraController,
//       )->WonderCommonlib.OptionSt.toNullable,
//     setMinDistance: (cameraController, minDistance) =>
//       ArcballCameraControllerApService.setMinDistance(cameraController, minDistance),
//     getWheelSpeed: cameraController =>
//       ArcballCameraControllerApService.getWheelSpeed(
//         cameraController,
//       )->WonderCommonlib.OptionSt.toNullable,
//     setWheelSpeed: (cameraController, wheelSpeed) =>
//       ArcballCameraControllerApService.setWheelSpeed(cameraController, wheelSpeed),
//     getPhi: cameraController =>
//       ArcballCameraControllerApService.getPhi(
//         cameraController,
//       )->WonderCommonlib.OptionSt.toNullable,
//     setPhi: (cameraController, phi) =>
//       ArcballCameraControllerApService.setPhi(cameraController, phi),
//     getTheta: cameraController =>
//       ArcballCameraControllerApService.getTheta(
//         cameraController,
//       )->WonderCommonlib.OptionSt.toNullable,
//     setTheta: (cameraController, theta) =>
//       ArcballCameraControllerApService.setTheta(
//         cameraController,
//         theta,
//       )->WonderCommonlib.Result.getExn,
//     getThetaMargin: cameraController =>
//       ArcballCameraControllerApService.getThetaMargin(
//         cameraController,
//       )->WonderCommonlib.OptionSt.toNullable,
//     setThetaMargin: (cameraController, thetaMargin) =>
//       ArcballCameraControllerApService.setThetaMargin(
//         cameraController,
//         thetaMargin,
//       )->WonderCommonlib.Result.getExn,
//     getTarget: cameraController =>
//       ArcballCameraControllerApService.getTarget(
//         cameraController,
//       )->WonderCommonlib.OptionSt.toNullable,
//     setTarget: (cameraController, target) =>
//       ArcballCameraControllerApService.setTarget(cameraController, target),
//     getRotateSpeed: cameraController =>
//       ArcballCameraControllerApService.getRotateSpeed(
//         cameraController,
//       )->WonderCommonlib.OptionSt.toNullable,
//     setRotateSpeed: (cameraController, rotateSpeed) =>
//       ArcballCameraControllerApService.setRotateSpeed(cameraController, rotateSpeed),
//     getMoveSpeedX: cameraController =>
//       ArcballCameraControllerApService.getMoveSpeedX(
//         cameraController,
//       )->WonderCommonlib.OptionSt.toNullable,
//     setMoveSpeedX: (cameraController, moveSpeedX) =>
//       ArcballCameraControllerApService.setMoveSpeedX(cameraController, moveSpeedX),
//     getMoveSpeedY: cameraController =>
//       ArcballCameraControllerApService.getMoveSpeedY(
//         cameraController,
//       )->WonderCommonlib.OptionSt.toNullable,
//     setMoveSpeedY: (cameraController, moveSpeedY) =>
//       ArcballCameraControllerApService.setMoveSpeedY(cameraController, moveSpeedY),
//     update: () => ArcballCameraControllerApService.update()->WonderCommonlib.Result.getExn,
//   },
//   getSharedArrayBufferData: unit => SharedArrayBufferDataApService.getSharedArrayBufferData(),
// }

// let buildSceneGraphRepoForRenderWorker = (): WonderCore.ISceneGraphRepoForJs.sceneGraphRepoForRenderWorker => {
//   init: initForRenderWorker,
//   configRepo: {
//     getIsDebug: ConfigApService.getIsDebug,
//   },
//   transformRepo: {
//     toComponent: TransformApService.toComponent,
//     getLocalPosition: TransformApService.getLocalPosition,
//     getPosition: TransformApService.getPosition,
//     getLocalRotation: TransformApService.getLocalRotation,
//     getRotation: TransformApService.getRotation,
//     getLocalScale: TransformApService.getLocalScale,
//     getScale: TransformApService.getScale,
//     getLocalEulerAngles: TransformApService.getLocalEulerAngles,
//     getEulerAngles: TransformApService.getEulerAngles,
//     getLocalToWorldMatrix: TransformApService.getLocalToWorldMatrix,
//     getNormalMatrix: transform =>
//       TransformApService.getNormalMatrix(transform)->WonderCommonlib.Result.getExn,
//   },
//   geometryRepo: {
//     toComponent: GeometryApService.toComponent,
//     getVertices: geometry =>
//       GeometryApService.getVertices(geometry)->WonderCommonlib.Result.toNullable,
//     getNormals: geometry =>
//       GeometryApService.getNormals(geometry)->WonderCommonlib.Result.toNullable,
//     getTexCoords: geometry =>
//       GeometryApService.getTexCoords(geometry)->WonderCommonlib.Result.toNullable,
//     getTangents: geometry =>
//       GeometryApService.getTangents(geometry)->WonderCommonlib.Result.toNullable,
//     getIndices: geometry =>
//       GeometryApService.getIndices(geometry)->WonderCommonlib.Result.toNullable,
//     hasVertices: geometry => GeometryApService.hasVertices(geometry)->WonderCommonlib.Result.getExn,
//     hasNormals: geometry => GeometryApService.hasNormals(geometry)->WonderCommonlib.Result.getExn,
//     hasTexCoords: geometry =>
//       GeometryApService.hasTexCoords(geometry)->WonderCommonlib.Result.getExn,
//     hasTangents: geometry => GeometryApService.hasTangents(geometry)->WonderCommonlib.Result.getExn,
//     hasIndices: geometry => GeometryApService.hasIndices(geometry)->WonderCommonlib.Result.getExn,
//     getIndicesCount: geometry =>
//       GeometryApService.getIndicesCount(geometry)->WonderCommonlib.Result.toNullable,
//     computeTangents: GeometryApService.computeTangents,
//   },
//   pbrMaterialRepo: {
//     toComponent: PBRMaterialApService.toComponent,
//     getDiffuseColor: material => PBRMaterialApService.getDiffuseColor(material),
//     getSpecularColor: material => PBRMaterialApService.getSpecularColor(material),
//     getSpecular: material => PBRMaterialApService.getSpecular(material),
//     getRoughness: material => PBRMaterialApService.getRoughness(material),
//     getMetalness: material => PBRMaterialApService.getMetalness(material),
//     getTransmission: material => PBRMaterialApService.getTransmission(material),
//     getIOR: material => PBRMaterialApService.getIOR(material),
//     getDiffuseMap: material =>
//       PBRMaterialApService.getDiffuseMap(material)->WonderCommonlib.OptionSt.toNullable,
//     getChannelRoughnessMetallicMap: material =>
//       PBRMaterialApService.getChannelRoughnessMetallicMap(
//         material,
//       )->WonderCommonlib.OptionSt.toNullable,
//     getEmissionMap: material =>
//       PBRMaterialApService.getEmissionMap(material)->WonderCommonlib.OptionSt.toNullable,
//     getNormalMap: material =>
//       PBRMaterialApService.getNormalMap(material)->WonderCommonlib.OptionSt.toNullable,
//     getTransmissionMap: material =>
//       PBRMaterialApService.getTransmissionMap(material)->WonderCommonlib.OptionSt.toNullable,
//     getSpecularMap: material =>
//       PBRMaterialApService.getSpecularMap(material)->WonderCommonlib.OptionSt.toNullable,
//   },
//   directionLightRepo: {
//     toComponent: DirectionLightApService.toComponent,
//     getColor: light => DirectionLightApService.getColor(light),
//     getIntensity: light => DirectionLightApService.getIntensity(light),
//     getDirection: light =>
//       DirectionLightApService.getDirection(light)->WonderCommonlib.OptionSt.toNullable,
//   },
// }
