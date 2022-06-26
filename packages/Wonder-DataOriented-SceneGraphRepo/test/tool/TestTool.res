let preparePO = () => {
  ContainerManager.setPO(CreatePO.create())

  // DirectorForJs._createAndSetAllComponentPOs()->WonderCommonlib.Result.handleFail(err => err->WonderCommonlib.Exceptionmonlib.Exception.throwErr)
}

let init = (
  ~sandbox,
  ~isDebug=true,
  ~transformCount=10,
  ~geometryCount=10,
  ~geometryPointCount=10,
  ~pbrMaterialCount=10,
  ~directionLightCount=2,
  ~float9Array1=Matrix3.createIdentityMatrix3(),
  ~float32Array1=Matrix4.createIdentityMatrix4(),
  (),
) => {
  ContainerManager.setPO(CreatePO.create())

  DirectorTool.init(
    ~transformCount,
    ~geometryCount,
    ~geometryPointCount,
    ~pbrMaterialCount,
    ~directionLightCount,
    ~float9Array1,
    ~float32Array1,
    (),
  )
}
