type poContainer = {mutable po: option<POType.po>}

let _createPOContainer = (): poContainer => {po: None}

let poContainer = _createPOContainer()

let setState = (state: POType.po) => {
  poContainer.po = state->Some

  ()
}

let unsafeGetState = () => {
  poContainer.po->WonderCommonlib.OptionSt.getExn
}
