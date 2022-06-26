type jobName = string

type execFunc<'states> = ('states, PipelineType.repo) => WonderBsMost.Most.stream<'states>

@genType
type getExecFunc<'states> = (PipelineType.pipelineName, jobName) => Js.Nullable.t<execFunc<'states>>

@genType
type pipelineData = PipelineType.pipelineData

@genType
type createStateFunc<'state> = unit => 'state

@genType
type initFunc<'state> = 'state => unit

type pluginName = string

type allPipelineData = array<pipelineData>

type registeredWorkPlugin<'state, 'states> = {
  pluginName: pluginName,
  createStateFunc: createStateFunc<'state>,
  initFunc: initFunc<'state>,
  getExecFunc: getExecFunc<'states>,
  allPipelineData: allPipelineData,
}

@genType
type getRegisteredWorkPluginData<'state, 'states> = unit => registeredWorkPlugin<'state, 'states>
