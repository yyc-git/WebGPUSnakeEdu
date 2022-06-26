let getSceneGraphRepo = (state: POType.po) => {
  state.sceneGraphRepo
}

let setSceneGraphRepo = (state: POType.po, repo) => {
  ...state,
  sceneGraphRepo: Some(repo),
}
