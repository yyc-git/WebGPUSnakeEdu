'use strict';

var Most = require("most");
var CreatePO$WonderCore = require("../data/CreatePO.bs.js");
var POContainer$WonderCore = require("../data/POContainer.bs.js");
var Result$WonderCommonlib = require("wonder-commonlib/lib/js/src/structure/Result.bs.js");
var WorkManager$WonderCore = require("./work_manager/WorkManager.bs.js");
var OptionSt$WonderCommonlib = require("wonder-commonlib/lib/js/src/structure/OptionSt.bs.js");
var Exception$WonderCommonlib = require("wonder-commonlib/lib/js/src/structure/Exception.bs.js");
var SceneGraphRepoManager$WonderCore = require("./scene_graph_repo_manager/SceneGraphRepoManager.bs.js");

function registerWorkPlugin(data, jobOrdersOpt, param) {
  var jobOrders = jobOrdersOpt !== undefined ? jobOrdersOpt : [];
  return POContainer$WonderCore.setState(WorkManager$WonderCore.registerPlugin(POContainer$WonderCore.unsafeGetState(undefined), data, jobOrders));
}

function unregisterWorkPlugin(targetPluginName) {
  return POContainer$WonderCore.setState(WorkManager$WonderCore.unregisterPlugin(POContainer$WonderCore.unsafeGetState(undefined), targetPluginName));
}

function prepare(param) {
  return POContainer$WonderCore.setState(CreatePO$WonderCore.createState(undefined));
}

function unsafeGetSceneGraphRepo(param) {
  return OptionSt$WonderCommonlib.getExn(SceneGraphRepoManager$WonderCore.getSceneGraphRepo(POContainer$WonderCore.unsafeGetState(undefined)));
}

function setSceneGraphRepo(repo) {
  return POContainer$WonderCore.setState(SceneGraphRepoManager$WonderCore.setSceneGraphRepo(POContainer$WonderCore.unsafeGetState(undefined), repo));
}

function init(param) {
  return POContainer$WonderCore.setState(WorkManager$WonderCore.init(POContainer$WonderCore.unsafeGetState(undefined)));
}

function runPipeline(pipelineName) {
  return Result$WonderCommonlib.handleFail(Result$WonderCommonlib.mapSuccess(WorkManager$WonderCore.runPipeline(POContainer$WonderCore.unsafeGetState(undefined), pipelineName), (function (__x) {
                    return Most.tap(POContainer$WonderCore.setState, __x);
                  })), Exception$WonderCommonlib.throwErr);
}

exports.registerWorkPlugin = registerWorkPlugin;
exports.unregisterWorkPlugin = unregisterWorkPlugin;
exports.prepare = prepare;
exports.unsafeGetSceneGraphRepo = unsafeGetSceneGraphRepo;
exports.setSceneGraphRepo = setSceneGraphRepo;
exports.init = init;
exports.runPipeline = runPipeline;
/* most Not a pure module */
