// let _updateTransform = cameraController => {
//   WonderCommonlib.Tuple5.collectOption(
//     GameObjectArcballCameraControllerDoService.getGameObject(cameraController)->WonderCommonlib.OptionSt.bind(
//       GetComponentGameObjectDoService.getTransform,
//     ),
//     OperateArcballCameraContrllerDoService.getDistance(cameraController)->WonderCommonlib.OptionSt.map(
//       DistanceVO.value,
//     ),
//     OperateArcballCameraContrllerDoService.getPhi(cameraController)->WonderCommonlib.OptionSt.map(PhiVO.value),
//     OperateArcballCameraContrllerDoService.getTheta(cameraController)->WonderCommonlib.OptionSt.map(ThetaVO.value),
//     OperateArcballCameraContrllerDoService.getTarget(cameraController)->WonderCommonlib.OptionSt.map(
//       TargetVO.value,
//     ),
//   )->WonderCommonlib.Result.bind(((transform, distance, phi, theta, (x, y, z) as target)) => {
//     ModelMatrixTransformDoService.setLocalPosition(
//       transform,
//       (
//         distance *. Js.Math.cos(phi) *. Js.Math.sin(theta) +. x,
//         distance *. Js.Math.cos(theta) +. y,
//         distance *. Js.Math.sin(phi) *. Js.Math.sin(theta) +. z,
//       )->PositionVO.create,
//     )->WonderCommonlib.Result.bind(() => {
//       LookAtTransformDoService.lookAt(~transform, ~target=target->TargetVO.create, ())
//     })
//   })
// }

// let update = () =>
//   DirtyArcballCameraControllerDoService.getUniqueDirtyList()
//   ->WonderCommonlib.ListSt.traverseResultM(cameraController => _updateTransform(cameraController))
//   ->WonderCommonlib.Result.mapSuccess(_ => {
//     ArcballCameraControllerRepo.clearDirtyList()
//   })
