type registeredWorkPluginData = (
  IWorkForJs.registeredWorkPlugin<
    RegisterWorkPluginType.state,
    RegisterWorkPluginType.states,
  >,
  RegisterWorkPluginType.jobOrders,
)

type po = {
  allRegisteredWorkPluginData: list<registeredWorkPluginData>,
  sceneGraphRepo: option<ISceneGraphRepoForJs.sceneGraphRepo>,
  states: RegisterWorkPluginType.states,
}