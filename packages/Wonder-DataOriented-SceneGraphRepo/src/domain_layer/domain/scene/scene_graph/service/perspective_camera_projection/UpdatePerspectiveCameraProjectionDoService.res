let updateCameraProjection = cameraProjection =>
  switch FrustumPerspectiveCameraProjectionDoService.getAspect(cameraProjection) {
  | None =>
    CanvasEntity.getCanvas()
    ->WonderCommonlib.OptionSt.get
    ->WonderCommonlib.Result.mapSuccess(({width, height}: CanvasEntity.t) =>
      (width, height)->FrustumPerspectiveCameraProjectionDoService.computeAspect
    )
  | Some(aspect) => aspect->WonderCommonlib.Result.succeed
  }->WonderCommonlib.Result.bind(aspect =>
    switch (
      FrustumPerspectiveCameraProjectionDoService.getFovy(cameraProjection),
      FrustumPerspectiveCameraProjectionDoService.getNear(cameraProjection),
      FrustumPerspectiveCameraProjectionDoService.getFar(cameraProjection),
    ) {
    | (Some(fovy), Some(near), Some(far)) =>
      Matrix4.createIdentityMatrix4()
      ->Matrix4.buildPerspective((
        fovy->FovyVO.value,
        aspect->AspectVO.value,
        near->NearVO.value,
        far->FarVO.value,
      ))
      ->WonderCommonlib.Result.mapSuccess(pMatrix =>
        pMatrix
        ->ProjectionMatrixVO.create
        ->PMatrixPerspectiveCameraProjectionDoService.setPMatrix(cameraProjection, _)
      )
    | (_, _, _) =>
      WonderCommonlib.Log.buildFatalMessage(
        ~title="update",
        ~description=j`fovy,near,far should all exist`,
        ~reason="",
        ~solution=j``,
        ~params=j`cameraProjection: $cameraProjection`,
      )->WonderCommonlib.Result.failWith
    }
  )

let update = () =>
  DirtyPerspectiveCameraProjectionDoService.getUniqueDirtyList()
  ->WonderCommonlib.ListSt.traverseResultM(cameraProjection => updateCameraProjection(cameraProjection))
  ->WonderCommonlib.Result.mapSuccess(_ => {
    PerspectiveCameraProjectionRepo.clearDirtyList()
  })
