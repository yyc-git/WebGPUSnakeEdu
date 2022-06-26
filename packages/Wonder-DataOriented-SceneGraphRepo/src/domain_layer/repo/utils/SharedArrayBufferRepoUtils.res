let _isSupportSharedArrayBuffer = %bs.raw(`
    function(param){
        return typeof SharedArrayBuffer !== "undefined"
    }
    `)

@bs.new
external _newSharedArrayBuffer: int => SharedArrayBufferPOType.sharedArrayBuffer =
  "SharedArrayBuffer"

let newSharedArrayBuffer = totalByteLength => WonderCommonlib.Contract.requireCheck(() => {
    open WonderCommonlib.Contract
    open Operators
    test(WonderCommonlib.Log.buildAssertMessage(~expect=j`support sharedArrayBuffer`, ~actual=j`not`), () =>
      _isSupportSharedArrayBuffer()->assertTrue
    )
  }, ConfigRepo.getIsDebug())->WonderCommonlib.Result.mapSuccess(() => _newSharedArrayBuffer(totalByteLength))
