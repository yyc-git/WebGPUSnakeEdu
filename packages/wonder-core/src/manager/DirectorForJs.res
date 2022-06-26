let registerWorkPlugin = (~data, ~jobOrders=[], ()) => {
  POContainer.unsafeGetState()->WorkManager.registerPlugin(data, jobOrders)->POContainer.setState
}

let unregisterWorkPlugin = targetPluginName => {
  POContainer.unsafeGetState()->WorkManager.unregisterPlugin(targetPluginName)->POContainer.setState
}

let prepare = () => {
  let state = CreatePO.createState()

  POContainer.setState(state)
}

let unsafeGetSceneGraphRepo = () => {
  POContainer.unsafeGetState()
  ->SceneGraphRepoManager.getSceneGraphRepo
  ->WonderCommonlib.OptionSt.getExn
}

let setSceneGraphRepo = repo => {
  POContainer.unsafeGetState()->SceneGraphRepoManager.setSceneGraphRepo(repo)->POContainer.setState
}

let init = () => {
  POContainer.unsafeGetState()->WorkManager.init->POContainer.setState
}

let runPipeline = (pipelineName: PipelineType.pipelineName) => {
  POContainer.unsafeGetState()
  ->WorkManager.runPipeline(pipelineName)
  ->WonderCommonlib.Result.mapSuccess(WonderBsMost.Most.tap(POContainer.setState, _))
  ->WonderCommonlib.Result.handleFail(WonderCommonlib.Exception.throwErr)
}
