type sharedArrayBufferData

type gameObject

type scene

type transform

type geometry

type pbrMaterial

type directionLight

type basicCameraView

type perspectiveCameraProjection

type arcballCameraController

type context

type canvas = {
  width: int,
  height: int,
  getContext: string => context,
}

type color = (float, float, float)

type configRepo = {
  getIsDebug: unit => bool,
  setIsDebug: bool => unit,
  getTransformCount: unit => int,
  setTransformCount: int => unit,
  // getGeometryCount: unit => int,
  // setGeometryCount: int => unit,
  // getGeometryPointCount: unit => int,
  // setGeometryPointCount: int => unit,
  // getDirectionLightCount: unit => int,
  // setDirectionLightCount: int => unit,
  // getPBRMaterialCount: unit => int,
  // setPBRMaterialCount: int => unit,
}

type position = (float, float, float)

type rotation = (float, float, float, float)

type scale = (float, float, float)

type localToWorldMatrix = Js.Typed_array.Float32Array.t

type normalMatrix = Js.Typed_array.Float32Array.t

type eulerAngles = (float, float, float)

type angle = float

// type axis = (float, float, float)

// type target = (float, float, float)

type transformRepo = {
  getIndex: transform => int,
  toComponent: int => transform,
  create: unit => transform,
  getGameObject: transform => Js.Nullable.t<gameObject>,
  getParent: transform => Js.Nullable.t<transform>,
  hasParent: transform => bool,
  removeParent: transform => unit,
  getChildren: transform => Js.Nullable.t<array<transform>>,
  getLocalPosition: transform => position,
  setLocalPosition: (transform, position) => unit,
  getPosition: transform => position,
  setPosition: (transform, position) => unit,
  getLocalRotation: transform => rotation,
  setLocalRotation: (transform, rotation) => unit,
  getRotation: transform => rotation,
  setRotation: (transform, rotation) => unit,
  getLocalScale: transform => scale,
  setLocalScale: (transform, scale) => unit,
  getScale: transform => scale,
  setScale: (transform, scale) => unit,
  getLocalEulerAngles: transform => eulerAngles,
  setLocalEulerAngles: (transform, eulerAngles) => unit,
  getEulerAngles: transform => eulerAngles,
  setEulerAngles: (transform, eulerAngles) => unit,
  // rotateLocalOnAxis: (transform, (angle, axis)) => unit,
  // rotateWorldOnAxis: (transform, (angle, axis)) => unit,
  getLocalToWorldMatrix: transform => localToWorldMatrix,
  getNormalMatrix: transform => normalMatrix,
  getAllTransforms: unit => array<transform>,
  updateTransform: transform => unit,
  // lookAt: (transform, target) => unit,
  // update: unit => unit,
}

// type geometryRepo = {
//   getIndex: geometry => int,
//   toComponent: int => geometry,
//   create: unit => geometry,
//   getGameObjects: geometry => Js.Nullable.t<array<gameObject>>,
//   createTriangleGeometry: unit => geometry,
//   createSphereGeometry: (float, int) => geometry,
//   createPlaneGeometry: (int, int, int, int) => geometry,
//   getVertices: geometry => Js.Nullable.t<Js.Typed_array.Float32Array.t>,
//   setVertices: (geometry, Js.Typed_array.Float32Array.t) => unit,
//   hasVertices: geometry => bool,
//   getNormals: geometry => Js.Nullable.t<Js.Typed_array.Float32Array.t>,
//   setNormals: (geometry, Js.Typed_array.Float32Array.t) => unit,
//   hasNormals: geometry => bool,
//   getTexCoords: geometry => Js.Nullable.t<Js.Typed_array.Float32Array.t>,
//   setTexCoords: (geometry, Js.Typed_array.Float32Array.t) => unit,
//   hasTexCoords: geometry => bool,
//   getTangents: geometry => Js.Nullable.t<Js.Typed_array.Float32Array.t>,
//   setTangents: (geometry, Js.Typed_array.Float32Array.t) => unit,
//   hasTangents: geometry => bool,
//   getIndices: geometry => Js.Nullable.t<Js.Typed_array.Uint32Array.t>,
//   setIndices: (geometry, Js.Typed_array.Uint32Array.t) => unit,
//   hasIndices: geometry => bool,
//   getIndicesCount: geometry => Js.Nullable.t<int>,
//   computeTangents: (
//     Js.Typed_array.Float32Array.t,
//     Js.Typed_array.Float32Array.t,
//     Js.Typed_array.Float32Array.t,
//     Js.Typed_array.Uint32Array.t,
//   ) => Js.Typed_array.Float32Array.t,
// }

type diffuseMap

type normalMap

type channelRoughnessMetallicMap

type emissionMap

type transmissionMap

type specularMap

// type pbrMaterialRepo = {
//   getIndex: pbrMaterial => int,
//   toComponent: int => pbrMaterial,
//   create: unit => pbrMaterial,
//   getGameObjects: pbrMaterial => Js.Nullable.t<array<gameObject>>,
//   getDiffuseColor: pbrMaterial => color,
//   setDiffuseColor: (pbrMaterial, color) => unit,
//   getSpecularColor: pbrMaterial => color,
//   setSpecularColor: (pbrMaterial, color) => unit,
//   getSpecular: pbrMaterial => float,
//   setSpecular: (pbrMaterial, float) => unit,
//   getRoughness: pbrMaterial => float,
//   setRoughness: (pbrMaterial, float) => unit,
//   getMetalness: pbrMaterial => float,
//   setMetalness: (pbrMaterial, float) => unit,
//   getTransmission: pbrMaterial => float,
//   setTransmission: (pbrMaterial, float) => unit,
//   getIOR: pbrMaterial => float,
//   setIOR: (pbrMaterial, float) => unit,
//   getDiffuseMap: pbrMaterial => Js.Nullable.t<diffuseMap>,
//   setDiffuseMap: (pbrMaterial, diffuseMap) => unit,
//   getChannelRoughnessMetallicMap: pbrMaterial => Js.Nullable.t<channelRoughnessMetallicMap>,
//   setChannelRoughnessMetallicMap: (pbrMaterial, channelRoughnessMetallicMap) => unit,
//   getEmissionMap: pbrMaterial => Js.Nullable.t<emissionMap>,
//   setEmissionMap: (pbrMaterial, emissionMap) => unit,
//   getNormalMap: pbrMaterial => Js.Nullable.t<normalMap>,
//   setNormalMap: (pbrMaterial, normalMap) => unit,
//   getTransmissionMap: pbrMaterial => Js.Nullable.t<transmissionMap>,
//   setTransmissionMap: (pbrMaterial, transmissionMap) => unit,
//   getSpecularMap: pbrMaterial => Js.Nullable.t<specularMap>,
//   setSpecularMap: (pbrMaterial, specularMap) => unit,
// }

// type directionLightRepo = {
//   getIndex: directionLight => int,
//   toComponent: int => directionLight,
//   create: unit => directionLight,
//   getGameObject: directionLight => Js.Nullable.t<gameObject>,
//   getColor: directionLight => color,
//   setColor: (directionLight, color) => unit,
//   getIntensity: directionLight => float,
//   setIntensity: (directionLight, float) => unit,
//   getAllLights: unit => array<directionLight>,
//   getDirection: directionLight => Js.Nullable.t<(float, float, float)>,
//   getLightCount: unit => int,
// }

// type basicCameraViewRepo = {
//   getIndex: basicCameraView => int,
//   toComponent: int => basicCameraView,
//   create: unit => basicCameraView,
//   getGameObject: basicCameraView => Js.Nullable.t<gameObject>,
//   getViewWorldToCameraMatrix: basicCameraView => Js.Nullable.t<Js.Typed_array.Float32Array.t>,
//   isActive: basicCameraView => bool,
//   active: basicCameraView => unit,
//   unactive: basicCameraView => unit,
//   setActive: (basicCameraView, bool) => unit,
//   getActiveBasicCameraView: unit => Js.Nullable.t<basicCameraView>,
// }

// type perspectiveCameraProjectionRepo = {
//   getIndex: perspectiveCameraProjection => int,
//   toComponent: int => perspectiveCameraProjection,
//   create: unit => perspectiveCameraProjection,
//   getGameObject: perspectiveCameraProjection => Js.Nullable.t<gameObject>,
//   getPMatrix: perspectiveCameraProjection => Js.Nullable.t<Js.Typed_array.Float32Array.t>,
//   getFovy: perspectiveCameraProjection => Js.Nullable.t<float>,
//   setFovy: (perspectiveCameraProjection, float) => unit,
//   getAspect: perspectiveCameraProjection => Js.Nullable.t<float>,
//   setAspect: (perspectiveCameraProjection, float) => unit,
//   getNear: perspectiveCameraProjection => Js.Nullable.t<float>,
//   setNear: (perspectiveCameraProjection, float) => unit,
//   getFar: perspectiveCameraProjection => Js.Nullable.t<float>,
//   setFar: (perspectiveCameraProjection, float) => unit,
//   markDirty: perspectiveCameraProjection => unit,
//   markNotDirty: perspectiveCameraProjection => unit,
//   update: unit => unit,
// }

// type arcballCameraControllerRepo = {
//   getIndex: arcballCameraController => int,
//   toComponent: int => arcballCameraController,
//   create: unit => arcballCameraController,
//   getGameObject: arcballCameraController => Js.Nullable.t<gameObject>,
//   getDistance: arcballCameraController => Js.Nullable.t<float>,
//   setDistance: (arcballCameraController, float) => unit,
//   getMinDistance: arcballCameraController => Js.Nullable.t<float>,
//   setMinDistance: (arcballCameraController, float) => unit,
//   getWheelSpeed: arcballCameraController => Js.Nullable.t<float>,
//   setWheelSpeed: (arcballCameraController, float) => unit,
//   getPhi: arcballCameraController => Js.Nullable.t<float>,
//   setPhi: (arcballCameraController, float) => unit,
//   getTheta: arcballCameraController => Js.Nullable.t<float>,
//   setTheta: (arcballCameraController, float) => unit,
//   getThetaMargin: arcballCameraController => Js.Nullable.t<float>,
//   setThetaMargin: (arcballCameraController, float) => unit,
//   getTarget: arcballCameraController => Js.Nullable.t<target>,
//   setTarget: (arcballCameraController, target) => unit,
//   getMoveSpeedX: arcballCameraController => Js.Nullable.t<float>,
//   setMoveSpeedX: (arcballCameraController, float) => unit,
//   getMoveSpeedY: arcballCameraController => Js.Nullable.t<float>,
//   setMoveSpeedY: (arcballCameraController, float) => unit,
//   getRotateSpeed: arcballCameraController => Js.Nullable.t<float>,
//   setRotateSpeed: (arcballCameraController, float) => unit,
//   update: unit => unit,
// }

type gameObjectRepo = {
  create: unit => gameObject,
  getTransform: gameObject => Js.Nullable.t<transform>,
  addTransform: (gameObject, transform) => gameObject,
  hasTransform: gameObject => bool,
  // getGeometry: gameObject => Js.Nullable.t<geometry>,
  // addGeometry: (gameObject, geometry) => gameObject,
  // hasGeometry: gameObject => bool,
  // getPBRMaterial: gameObject => Js.Nullable.t<pbrMaterial>,
  // addPBRMaterial: (gameObject, pbrMaterial) => gameObject,
  // hasPBRMaterial: gameObject => bool,
  // getDirectionLight: gameObject => Js.Nullable.t<directionLight>,
  // addDirectionLight: (gameObject, directionLight) => gameObject,
  // hasDirectionLight: gameObject => bool,
  // getBasicCameraView: gameObject => Js.Nullable.t<basicCameraView>,
  // addBasicCameraView: (gameObject, basicCameraView) => gameObject,
  // hasBasicCameraView: gameObject => bool,
  // getPerspectiveCameraProjection: gameObject => Js.Nullable.t<perspectiveCameraProjection>,
  // addPerspectiveCameraProjection: (gameObject, perspectiveCameraProjection) => gameObject,
  // hasPerspectiveCameraProjection: gameObject => bool,
  // getArcballCameraController: gameObject => Js.Nullable.t<arcballCameraController>,
  // addArcballCameraController: (gameObject, arcballCameraController) => gameObject,
  // hasArcballCameraController: gameObject => bool,
}

type sceneRepo = {
  create: unit => scene,
  add: (scene, gameObject) => unit,
  getScene: unit => Js.Nullable.t<scene>,
  setScene: scene => unit,
  getAllGameObjects: scene => array<gameObject>,
  // getAllRenderGameObjects: scene => array<gameObject>,
  // getAllGeometries: scene => array<geometry>,
  // getAllPBRMaterials: scene => array<pbrMaterial>,
}

type componentCountData = {
  transformCount: int,
  // geometryCount: int,
  // geometryPointCount: int,
  // pbrMaterialCount: int,
  // directionLightCount: int,
}

type globalTempData = {
  float9Array1: Js.Typed_array.Float32Array.t,
  float32Array1: Js.Typed_array.Float32Array.t,
}

// @genType
// type sceneGraphRepoForAPI = {
//   configRepo: configRepo,
//   sceneRepo: sceneRepo,
//   gameObjectRepo: gameObjectRepo,
//   transformRepo: transformRepo,
//   // geometryRepo: geometryRepo,
//   // pbrMaterialRepo: pbrMaterialRepo,
//   // directionLightRepo: directionLightRepo,
//   // basicCameraViewRepo: basicCameraViewRepo,
//   // perspectiveCameraProjectionRepo: perspectiveCameraProjectionRepo,
//   // arcballCameraControllerRepo: arcballCameraControllerRepo,
//   getCanvas: unit => Js.Nullable.t<canvas>,
// }

@genType
type sceneGraphRepo = {
  configRepo: configRepo,
  sceneRepo: sceneRepo,
  gameObjectRepo: gameObjectRepo,
  transformRepo: transformRepo,
  // geometryRepo: geometryRepo,
  // pbrMaterialRepo: pbrMaterialRepo,
  // directionLightRepo: directionLightRepo,
  // basicCameraViewRepo: basicCameraViewRepo,
  // perspectiveCameraProjectionRepo: perspectiveCameraProjectionRepo,
  // arcballCameraControllerRepo: arcballCameraControllerRepo,
  // init: (canvas, configData, globalTempData) => unit,
  getCanvas: unit => Js.Nullable.t<canvas>,
  setCanvas: canvas => unit,
  setIsDebug: bool => unit,
  setComponentCount: componentCountData => unit,
  setGlobalTempData: globalTempData => unit,
  createAndSetAllComponentPOs: unit => unit,
  // createAndSetAllComponentPOsWithSharedArrayBufferData: sharedArrayBufferData => unit,
  // getSharedArrayBufferData: unit => sharedArrayBufferData,
}

// type sharedArrayBufferData

// @genType
// type sceneGraphRepoForMainWorker = {
//   configRepo: configRepo,
//   sceneRepo: sceneRepo,
//   gameObjectRepo: gameObjectRepo,
//   transformRepo: transformRepo,
//   geometryRepo: geometryRepo,
//   pbrMaterialRepo: pbrMaterialRepo,
//   directionLightRepo: directionLightRepo,
//   basicCameraViewRepo: basicCameraViewRepo,
//   perspectiveCameraProjectionRepo: perspectiveCameraProjectionRepo,
//   arcballCameraControllerRepo: arcballCameraControllerRepo,
//   init: (canvas, configData, globalTempData) => unit,
//   getCanvas: unit => Js.Nullable.t<canvas>,
//   getSharedArrayBufferData: unit => sharedArrayBufferData,
// }

// module Worker = {
//   type configRepo = {getIsDebug: unit => bool}

//   type transformRepo = {
//     toComponent: int => transform,
//     getLocalPosition: transform => position,
//     getPosition: transform => position,
//     getLocalRotation: transform => rotation,
//     getRotation: transform => rotation,
//     getLocalScale: transform => scale,
//     getScale: transform => scale,
//     getLocalEulerAngles: transform => eulerAngles,
//     getEulerAngles: transform => eulerAngles,
//     getLocalToWorldMatrix: transform => localToWorldMatrix,
//     getNormalMatrix: transform => normalMatrix,
//   }

//   type geometryRepo = {
//     toComponent: int => geometry,
//     getVertices: geometry => Js.Nullable.t<Js.Typed_array.Float32Array.t>,
//     hasVertices: geometry => bool,
//     getNormals: geometry => Js.Nullable.t<Js.Typed_array.Float32Array.t>,
//     hasNormals: geometry => bool,
//     getTexCoords: geometry => Js.Nullable.t<Js.Typed_array.Float32Array.t>,
//     hasTexCoords: geometry => bool,
//     getTangents: geometry => Js.Nullable.t<Js.Typed_array.Float32Array.t>,
//     hasTangents: geometry => bool,
//     getIndices: geometry => Js.Nullable.t<Js.Typed_array.Uint32Array.t>,
//     hasIndices: geometry => bool,
//     getIndicesCount: geometry => Js.Nullable.t<int>,
//     computeTangents: (
//       Js.Typed_array.Float32Array.t,
//       Js.Typed_array.Float32Array.t,
//       Js.Typed_array.Float32Array.t,
//       Js.Typed_array.Uint32Array.t,
//     ) => Js.Typed_array.Float32Array.t,
//   }

//   type pbrMaterialRepo = {
//     toComponent: int => pbrMaterial,
//     getDiffuseColor: pbrMaterial => color,
//     getSpecularColor: pbrMaterial => color,
//     getSpecular: pbrMaterial => float,
//     getRoughness: pbrMaterial => float,
//     getMetalness: pbrMaterial => float,
//     getTransmission: pbrMaterial => float,
//     getIOR: pbrMaterial => float,
//     getDiffuseMap: pbrMaterial => Js.Nullable.t<diffuseMap>,
//     getChannelRoughnessMetallicMap: pbrMaterial => Js.Nullable.t<channelRoughnessMetallicMap>,
//     getEmissionMap: pbrMaterial => Js.Nullable.t<emissionMap>,
//     getNormalMap: pbrMaterial => Js.Nullable.t<normalMap>,
//     getTransmissionMap: pbrMaterial => Js.Nullable.t<transmissionMap>,
//     getSpecularMap: pbrMaterial => Js.Nullable.t<specularMap>,
//   }

//   type directionLightRepo = {
//     toComponent: int => directionLight,
//     getColor: directionLight => color,
//     getIntensity: directionLight => float,
//     getDirection: directionLight => Js.Nullable.t<(float, float, float)>,
//   }
// }

// @genType
// type sceneGraphRepoForRenderWorker = {
//   configRepo: Worker.configRepo,
//   transformRepo: Worker.transformRepo,
//   geometryRepo: Worker.geometryRepo,
//   pbrMaterialRepo: Worker.pbrMaterialRepo,
//   directionLightRepo: Worker.directionLightRepo,
//   init: (bool, sharedArrayBufferData) => unit,
// }
