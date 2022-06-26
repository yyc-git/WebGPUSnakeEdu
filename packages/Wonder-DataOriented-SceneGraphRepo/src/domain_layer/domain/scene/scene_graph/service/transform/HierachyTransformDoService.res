let hasParent = transform => TransformRepo.hasParent(transform->TransformEntity.value)

let getParent = transform =>
  TransformRepo.getParent(transform->TransformEntity.value)->WonderCommonlib.OptionSt.map(TransformEntity.create)

let getChildren = transform =>
  TransformRepo.getChildren(transform->TransformEntity.value)->WonderCommonlib.OptionSt.map(children =>
    children->WonderCommonlib.ListSt.map(TransformEntity.create)
  )

let _addToParent = (parent, child) =>
  WonderCommonlib.Contract.requireCheck(() => {
    open WonderCommonlib.Contract
    open Operators

    test(WonderCommonlib.Log.buildAssertMessage(~expect=j`child not has parent`, ~actual=j`has`), () =>
      getParent(child)->assertNotExist
    )
    test(WonderCommonlib.Log.buildAssertMessage(~expect=j`parent not already has the child`, ~actual=j`has`), () =>
      switch getChildren(parent) {
      | Some(children) => children->WonderCommonlib.ListSt.includes(child)->assertFalse
      | None => assertPass()
      }
    )
  }, ConfigRepo.getIsDebug())->WonderCommonlib.Result.mapSuccess(() => {
    TransformRepo.setParent(parent->TransformEntity.value, child->TransformEntity.value)
    TransformRepo.addChild(parent->TransformEntity.value, child->TransformEntity.value)
  })

let _removeParent = transform => TransformRepo.removeParent(transform->TransformEntity.value)

let _removeChild = (parent, child) =>
  TransformRepo.removeChild(parent->TransformEntity.value, child->TransformEntity.value)

let _removeFromParent = (currentParent, child) => {
  _removeParent(child)

  _removeChild(currentParent, child)
}

let removeParent = transform =>
  switch getParent(transform) {
  | None => ()
  | Some(currentParent) => _removeFromParent(currentParent, transform)
  }

let _setNewParent = (parent, child) =>
  switch getParent(child) {
  | None => _addToParent(parent, child)
  | Some(currentParent) =>
    !TransformEntity.isSame(currentParent, parent)
      ? {
          _removeFromParent(currentParent, child)
          _addToParent(parent, child)
        }
      : WonderCommonlib.Result.succeed()
  }

let rec markHierachyDirty = transform => {
  DirtyTransformDoService.mark(transform, true)

  switch getChildren(transform) {
  | None => ()
  | Some(children) => children->WonderCommonlib.ListSt.forEach(child => markHierachyDirty(child))
  }
}

let setParent = (parent, child) =>
  _setNewParent(parent, child)->WonderCommonlib.Result.mapSuccess(() => markHierachyDirty(child))
