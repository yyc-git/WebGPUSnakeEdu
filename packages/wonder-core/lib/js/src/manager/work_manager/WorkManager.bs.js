'use strict';

var Most = require("most");
var Curry = require("rescript/lib/js/curry.js");
var Caml_array = require("rescript/lib/js/caml_array.js");
var Log$WonderCommonlib = require("wonder-commonlib/lib/js/src/log/Log.bs.js");
var TreeNode$WonderCore = require("./TreeNode.bs.js");
var IterateTree$WonderCore = require("./IterateTree.bs.js");
var ListSt$WonderCommonlib = require("wonder-commonlib/lib/js/src/structure/ListSt.bs.js");
var OperateTree$WonderCore = require("./OperateTree.bs.js");
var POContainer$WonderCore = require("../../data/POContainer.bs.js");
var Result$WonderCommonlib = require("wonder-commonlib/lib/js/src/structure/Result.bs.js");
var Tuple2$WonderCommonlib = require("wonder-commonlib/lib/js/src/structure/tuple/Tuple2.bs.js");
var ArraySt$WonderCommonlib = require("wonder-commonlib/lib/js/src/structure/ArraySt.bs.js");
var OptionSt$WonderCommonlib = require("wonder-commonlib/lib/js/src/structure/OptionSt.bs.js");
var Exception$WonderCommonlib = require("wonder-commonlib/lib/js/src/structure/Exception.bs.js");
var MostUtils$WonderCommonlib = require("wonder-commonlib/lib/js/src/MostUtils.bs.js");
var ImmutableHashMap$WonderCommonlib = require("wonder-commonlib/lib/js/src/structure/hash_map/ImmutableHashMap.bs.js");
var SceneGraphRepoManager$WonderCore = require("../scene_graph_repo_manager/SceneGraphRepoManager.bs.js");

function _getStates(param) {
  return POContainer$WonderCore.unsafeGetState(undefined).states;
}

function _setStates(states) {
  var init = POContainer$WonderCore.unsafeGetState(undefined);
  return POContainer$WonderCore.setState({
              allRegisteredWorkPluginData: init.allRegisteredWorkPluginData,
              sceneGraphRepo: init.sceneGraphRepo,
              states: states
            });
}

function _findGroup(groupName, groups) {
  var group = ListSt$WonderCommonlib.getBy(ListSt$WonderCommonlib.fromArray(groups), (function (param) {
          return param.name === groupName;
        }));
  if (group !== undefined) {
    return group;
  } else {
    return Exception$WonderCommonlib.throwErr(Exception$WonderCommonlib.buildErr("groupName:" + groupName + " not in groups"));
  }
}

function _buildJobStream(execFunc, repo) {
  var __x = Most.just(execFunc);
  return Most.map(_setStates, Most.flatMap((function (func) {
                    return Curry._2(func, POContainer$WonderCore.unsafeGetState(undefined).states, repo);
                  }), __x));
}

function _getExecFunc(_getExecFuncs, pipelineName, jobName) {
  while(true) {
    var getExecFuncs = _getExecFuncs;
    if (ListSt$WonderCommonlib.length(getExecFuncs) === 0) {
      return Exception$WonderCommonlib.throwErr(Exception$WonderCommonlib.buildErr("can't get execFunc with pipelineName:" + pipelineName + ", jobName:" + jobName));
    }
    if (getExecFuncs) {
      var result = Curry._2(getExecFuncs.hd, pipelineName, jobName);
      if (!(result == null)) {
        return OptionSt$WonderCommonlib.getExn(OptionSt$WonderCommonlib.fromNullable(result));
      }
      _getExecFuncs = getExecFuncs.tl;
      continue ;
    }
    throw {
          RE_EXN_ID: "Match_failure",
          _1: [
            "WorkManager.res",
            45,
            14
          ],
          Error: new Error()
        };
  };
}

function _buildJobStreams(param, repo, param$1, groups) {
  var pipelineName = param$1[0];
  var getExecFuncs = param[1];
  var buildPipelineStreamFunc = param[0];
  return ListSt$WonderCommonlib.reduce(ListSt$WonderCommonlib.fromArray(param$1[1]), /* [] */0, (function (streams, param) {
                var name = param.name;
                if (param.type_ === "group") {
                  var group = _findGroup(name, groups);
                  var stream = Curry._5(buildPipelineStreamFunc, getExecFuncs, repo, pipelineName, group, groups);
                  return ListSt$WonderCommonlib.push(streams, stream);
                }
                var execFunc = _getExecFunc(getExecFuncs, pipelineName, name);
                return ListSt$WonderCommonlib.push(streams, _buildJobStream(execFunc, repo));
              }));
}

function _buildPipelineStream(getExecFuncs, repo, pipelineName, param, groups) {
  var streams = _buildJobStreams([
        _buildPipelineStream,
        getExecFuncs
      ], repo, [
        pipelineName,
        param.elements
      ], groups);
  return (
            param.link === "merge" ? (function (prim) {
                  return Most.mergeArray(prim);
                }) : MostUtils$WonderCommonlib.concatArray
          )(ListSt$WonderCommonlib.toArray(streams));
}

function parse(state, getExecFuncs, repo, param) {
  var groups = param.groups;
  var group = _findGroup(param.first_group, groups);
  POContainer$WonderCore.setState(state);
  var __x = _buildPipelineStream(getExecFuncs, repo, param.name, group, groups);
  return Most.map((function (param) {
                return POContainer$WonderCore.unsafeGetState(undefined);
              }), __x);
}

var ParsePipelineData = {
  _getStates: _getStates,
  _setStates: _setStates,
  _findGroup: _findGroup,
  _buildJobStream: _buildJobStream,
  _getExecFunc: _getExecFunc,
  _buildJobStreams: _buildJobStreams,
  _buildPipelineStream: _buildPipelineStream,
  parse: parse
};

function registerPlugin(state, data, jobOrders) {
  return {
          allRegisteredWorkPluginData: ListSt$WonderCommonlib.push(state.allRegisteredWorkPluginData, [
                data,
                jobOrders
              ]),
          sceneGraphRepo: state.sceneGraphRepo,
          states: state.states
        };
}

function unregisterPlugin(state, targetPluginName) {
  return {
          allRegisteredWorkPluginData: ListSt$WonderCommonlib.filter(state.allRegisteredWorkPluginData, (function (param) {
                  return param[0].pluginName !== targetPluginName;
                })),
          sceneGraphRepo: state.sceneGraphRepo,
          states: state.states
        };
}

function init(state) {
  var allRegisteredWorkPluginData = state.allRegisteredWorkPluginData;
  return ListSt$WonderCommonlib.reduce(allRegisteredWorkPluginData, {
              allRegisteredWorkPluginData: state.allRegisteredWorkPluginData,
              sceneGraphRepo: state.sceneGraphRepo,
              states: ListSt$WonderCommonlib.reduce(allRegisteredWorkPluginData, ImmutableHashMap$WonderCommonlib.createEmpty(undefined, undefined), (function (states, param) {
                      var match = param[0];
                      return ImmutableHashMap$WonderCommonlib.set(states, match.pluginName, Curry._1(match.createStateFunc, undefined));
                    }))
            }, (function (state, param) {
                var match = param[0];
                POContainer$WonderCore.setState(state);
                Curry._1(match.initFunc, OptionSt$WonderCommonlib.unsafeGet(ImmutableHashMap$WonderCommonlib.get(state.states, match.pluginName)));
                return POContainer$WonderCore.unsafeGetState(undefined);
              }));
}

function _findInsertPluginName(insertElementName, allRegisteredWorkPluginData) {
  return OptionSt$WonderCommonlib.get(OptionSt$WonderCommonlib.map(ListSt$WonderCommonlib.find(allRegisteredWorkPluginData, (function (param) {
                        var match = Caml_array.get(param[0].allPipelineData, 0);
                        return ArraySt$WonderCommonlib.includesByFunc(match.groups, (function (param) {
                                      return ArraySt$WonderCommonlib.includesByFunc(param.elements, (function (param) {
                                                    return param.name === insertElementName;
                                                  }));
                                    }));
                      })), (function (param) {
                    return param[0].pluginName;
                  })));
}

function _check(registeredWorkPluginData) {
  if (ArraySt$WonderCommonlib.length(registeredWorkPluginData[0].allPipelineData) <= 1 && ArraySt$WonderCommonlib.length(registeredWorkPluginData[1]) <= 1) {
    return Result$WonderCommonlib.succeed(registeredWorkPluginData);
  } else {
    return Result$WonderCommonlib.failWith(Log$WonderCommonlib.buildErrorMessage("allPipelineData or jobOrders should has the same pipeline <= 1", "", "", "", ""));
  }
}

function _findAllSpecificPipelineRelatedData(allRegisteredWorkPluginData, targetPipelineName) {
  return Result$WonderCommonlib.bind(ListSt$WonderCommonlib.traverseResultM(allRegisteredWorkPluginData, (function (param) {
                    var registeredWorkPlugin = param[0];
                    return _check([
                                {
                                  pluginName: registeredWorkPlugin.pluginName,
                                  createStateFunc: registeredWorkPlugin.createStateFunc,
                                  initFunc: registeredWorkPlugin.initFunc,
                                  getExecFunc: registeredWorkPlugin.getExecFunc,
                                  allPipelineData: ArraySt$WonderCommonlib.filter(registeredWorkPlugin.allPipelineData, (function (param) {
                                          return param.name === targetPipelineName;
                                        }))
                                },
                                ArraySt$WonderCommonlib.filter(param[1], (function (param) {
                                        return param.pipelineName === targetPipelineName;
                                      }))
                              ]);
                  })), (function (allRegisteredWorkPluginData) {
                return ListSt$WonderCommonlib.traverseResultM(ListSt$WonderCommonlib.map(ListSt$WonderCommonlib.filter(allRegisteredWorkPluginData, (function (param) {
                                      return ArraySt$WonderCommonlib.length(param[0].allPipelineData) === 1;
                                    })), (function (param) {
                                  var registeredWorkPluginData = param[0];
                                  return [
                                          registeredWorkPluginData.pluginName,
                                          registeredWorkPluginData.getExecFunc,
                                          Caml_array.get(registeredWorkPluginData.allPipelineData, 0),
                                          ArraySt$WonderCommonlib.getFirst(param[1])
                                        ];
                                })), (function (param) {
                              var pipelineData = param[2];
                              var getExecFunc = param[1];
                              var pluginName = param[0];
                              return Result$WonderCommonlib.mapSuccess(OptionSt$WonderCommonlib.sequenceResultM(OptionSt$WonderCommonlib.map(param[3], (function (param) {
                                                    var insertAction = param.insertAction;
                                                    var insertElementName = param.insertElementName;
                                                    return Result$WonderCommonlib.mapSuccess(_findInsertPluginName(insertElementName, allRegisteredWorkPluginData), (function (insertPluginName) {
                                                                  return {
                                                                          insertPluginName: insertPluginName,
                                                                          insertElementName: insertElementName,
                                                                          insertAction: insertAction
                                                                        };
                                                                }));
                                                  }))), (function (jobOrderOpt) {
                                            return {
                                                    pluginName: pluginName,
                                                    getExecFunc: getExecFunc,
                                                    pipelineData: pipelineData,
                                                    jobOrder: jobOrderOpt
                                                  };
                                          }));
                            }));
              }));
}

function _handleInsertedAsRootNode(treeDataList, param) {
  var nodeInsertPluginNameOpt = param[4];
  var nodeJobOrderOpt = param[3];
  var pipelineData = param[2];
  var getExecFunc = param[1];
  var pluginName = param[0];
  return ListSt$WonderCommonlib.reduce(treeDataList, [
              /* [] */0,
              undefined
            ], (function (param, treeData) {
                var insertPluginNameOpt = treeData[1];
                var insertedTreeOpt = param[1];
                var newTreeDataList = param[0];
                if (insertPluginNameOpt === undefined) {
                  return [
                          ListSt$WonderCommonlib.addInReduce(newTreeDataList, treeData),
                          insertedTreeOpt
                        ];
                }
                if (insertPluginNameOpt !== pluginName) {
                  return [
                          ListSt$WonderCommonlib.addInReduce(newTreeDataList, treeData),
                          insertedTreeOpt
                        ];
                }
                var insertedTree = TreeNode$WonderCore.buildNode(pluginName, [
                      getExecFunc,
                      pipelineData,
                      nodeJobOrderOpt
                    ], treeData[0]);
                return [
                        ListSt$WonderCommonlib.addInReduce(newTreeDataList, [
                              {
                                hd: insertedTree,
                                tl: /* [] */0
                              },
                              nodeInsertPluginNameOpt
                            ]),
                        insertedTree
                      ];
              }));
}

function _add(treeDataList, node, insertPluginNameOpt) {
  return {
          hd: [
            {
              hd: node,
              tl: /* [] */0
            },
            insertPluginNameOpt
          ],
          tl: treeDataList
        };
}

function _insertToAsChildNodeOrSameLevelTree(treeDataList, nodeInsertPluginName, node) {
  return ListSt$WonderCommonlib.reduce(treeDataList, [
              /* [] */0,
              false
            ], (function (param, param$1) {
                var insertPluginNameOpt = param$1[1];
                var sameLevelTreeList = param$1[0];
                var newTreeDataList = param[0];
                if (insertPluginNameOpt !== undefined && insertPluginNameOpt === nodeInsertPluginName) {
                  return [
                          ListSt$WonderCommonlib.addInReduce(newTreeDataList, [
                                ListSt$WonderCommonlib.push(sameLevelTreeList, node),
                                insertPluginNameOpt
                              ]),
                          true
                        ];
                }
                var match = ListSt$WonderCommonlib.reduce(sameLevelTreeList, [
                      /* [] */0,
                      false
                    ], (function (param, tree) {
                        var match = OperateTree$WonderCore.insertNode(tree, nodeInsertPluginName, node);
                        return [
                                ListSt$WonderCommonlib.addInReduce(param[0], match[0]),
                                match[1]
                              ];
                      }));
                return [
                        ListSt$WonderCommonlib.addInReduce(newTreeDataList, [
                              match[0],
                              insertPluginNameOpt
                            ]),
                        match[1]
                      ];
              }));
}

function _removeInsertedTree(treeDataList, insertedTree) {
  return ListSt$WonderCommonlib.filter(ListSt$WonderCommonlib.map(treeDataList, (function (param) {
                    return [
                            ListSt$WonderCommonlib.filter(param[0], (function (sameLevelTree) {
                                    return !TreeNode$WonderCore.isEqual(sameLevelTree, insertedTree);
                                  })),
                            param[1]
                          ];
                  })), (function (param) {
                return ListSt$WonderCommonlib.length(param[0]) > 0;
              }));
}

function _getTree(treeDataList) {
  if (ListSt$WonderCommonlib.length(treeDataList) !== 1) {
    return Result$WonderCommonlib.failWith(Log$WonderCommonlib.buildErrorMessage("treeDataList.length should be 1", "", "", "", ""));
  } else {
    return Result$WonderCommonlib.bind(OptionSt$WonderCommonlib.get(ListSt$WonderCommonlib.head(treeDataList)), (function (param) {
                  var sameLevelTreeList = param[0];
                  if (ListSt$WonderCommonlib.length(sameLevelTreeList) !== 1) {
                    return Result$WonderCommonlib.failWith(Log$WonderCommonlib.buildErrorMessage("sameLevelTreeList.length should be 1", "", "", "", ""));
                  } else {
                    return OptionSt$WonderCommonlib.get(ListSt$WonderCommonlib.head(sameLevelTreeList));
                  }
                }));
  }
}

function _buildTree(allSpecificPipelineRelatedData) {
  return _getTree(ListSt$WonderCommonlib.reduce(allSpecificPipelineRelatedData, /* [] */0, (function (treeDataList, param) {
                    var jobOrder = param.jobOrder;
                    var pipelineData = param.pipelineData;
                    var getExecFunc = param.getExecFunc;
                    var pluginName = param.pluginName;
                    if (jobOrder !== undefined) {
                      var insertPluginName = jobOrder.insertPluginName;
                      var nodeJobOrderOpt = {
                        insertElementName: jobOrder.insertElementName,
                        insertAction: jobOrder.insertAction
                      };
                      var match = _handleInsertedAsRootNode(treeDataList, [
                            pluginName,
                            getExecFunc,
                            pipelineData,
                            nodeJobOrderOpt,
                            insertPluginName
                          ]);
                      var insertedTreeOpt = match[1];
                      var treeDataList$1 = match[0];
                      if (insertedTreeOpt !== undefined) {
                        var match$1 = _insertToAsChildNodeOrSameLevelTree(treeDataList$1, insertPluginName, insertedTreeOpt);
                        var treeDataList$2 = match$1[0];
                        if (match$1[1]) {
                          return _removeInsertedTree(treeDataList$2, insertedTreeOpt);
                        } else {
                          return treeDataList$2;
                        }
                      }
                      var node = TreeNode$WonderCore.buildNode(pluginName, [
                            getExecFunc,
                            pipelineData,
                            nodeJobOrderOpt
                          ], /* [] */0);
                      var match$2 = _insertToAsChildNodeOrSameLevelTree(treeDataList$1, insertPluginName, node);
                      var treeDataList$3 = match$2[0];
                      if (match$2[1]) {
                        return treeDataList$3;
                      } else {
                        return _add(treeDataList$3, node, insertPluginName);
                      }
                    }
                    var match$3 = _handleInsertedAsRootNode(treeDataList, [
                          pluginName,
                          getExecFunc,
                          pipelineData,
                          undefined,
                          undefined
                        ]);
                    var treeDataList$4 = match$3[0];
                    if (OptionSt$WonderCommonlib.isSome(match$3[1])) {
                      return treeDataList$4;
                    } else {
                      return _add(treeDataList$4, TreeNode$WonderCore.buildNode(pluginName, [
                                      getExecFunc,
                                      pipelineData,
                                      undefined
                                    ], /* [] */0), undefined);
                    }
                  })));
}

function _buildFirstGroupElement(groups, first_group) {
  return OptionSt$WonderCommonlib.get(OptionSt$WonderCommonlib.map(ArraySt$WonderCommonlib.find(groups, (function (param) {
                        return param.name === first_group;
                      })), (function (param) {
                    return {
                            name: param.name,
                            type_: "group"
                          };
                  })));
}

function _insertElement(groups, insertAction, insertElementName, insertElement) {
  return ArraySt$WonderCommonlib.map(groups, (function (group) {
                return {
                        name: group.name,
                        link: group.link,
                        elements: ArraySt$WonderCommonlib.reduceOneParam(group.elements, (function (result, element) {
                                if (element.name === insertElementName) {
                                  if (insertAction) {
                                    return ArraySt$WonderCommonlib.push(ArraySt$WonderCommonlib.push(result, element), insertElement);
                                  } else {
                                    return ArraySt$WonderCommonlib.push(ArraySt$WonderCommonlib.push(result, insertElement), element);
                                  }
                                } else {
                                  return ArraySt$WonderCommonlib.push(result, element);
                                }
                              }), [])
                      };
              }));
}

function _mergeGroups(groups, insertGroups) {
  return insertGroups.concat(groups);
}

var _mergeGetExecFuncs = ListSt$WonderCommonlib.concat;

function _mergeToRootNode(tree) {
  return Result$WonderCommonlib.mapSuccess(IterateTree$WonderCore.postOrderCataWithParentNode((function (parentNodeOpt, pluginName, nodeData) {
                    var getExecFuncs = nodeData.getExecFuncs;
                    var pipelineData = nodeData.pipelineData;
                    var jobOrder = nodeData.jobOrder;
                    return function (children) {
                      var node = TreeNode$WonderCore.buildNodeByNodeData(pluginName, nodeData, children);
                      if (parentNodeOpt === undefined) {
                        return Result$WonderCommonlib.succeed(node);
                      }
                      var parentNodeData = TreeNode$WonderCore.getNodeData(parentNodeOpt);
                      return Result$WonderCommonlib.bind(OptionSt$WonderCommonlib.get(jobOrder), (function (param) {
                                    var insertAction = param.insertAction;
                                    var insertElementName = param.insertElementName;
                                    return Result$WonderCommonlib.mapSuccess(_buildFirstGroupElement(pipelineData.groups, pipelineData.first_group), (function (insertElement) {
                                                  var init = parentNodeData.pipelineData;
                                                  parentNodeData.pipelineData = {
                                                    name: init.name,
                                                    groups: pipelineData.groups.concat(_insertElement(parentNodeData.pipelineData.groups, insertAction, insertElementName, insertElement)),
                                                    first_group: init.first_group
                                                  };
                                                  parentNodeData.getExecFuncs = ListSt$WonderCommonlib.concat(parentNodeData.getExecFuncs, getExecFuncs);
                                                  return node;
                                                }));
                                  }));
                    };
                  }), tree, undefined, undefined), (function (tree) {
                var match = TreeNode$WonderCore.getNodeData(tree);
                var getExecFuncs = match.getExecFuncs;
                var pipelineData = match.pipelineData;
                return [
                        getExecFuncs,
                        pipelineData
                      ];
              }));
}

function merge(allRegisteredWorkPluginData, pipelineName) {
  return Result$WonderCommonlib.bind(Result$WonderCommonlib.bind(_findAllSpecificPipelineRelatedData(allRegisteredWorkPluginData, pipelineName), _buildTree), _mergeToRootNode);
}

var MergePipelineData = {
  _findInsertPluginName: _findInsertPluginName,
  _check: _check,
  _findAllSpecificPipelineRelatedData: _findAllSpecificPipelineRelatedData,
  _handleInsertedAsRootNode: _handleInsertedAsRootNode,
  _isInserted: OptionSt$WonderCommonlib.isSome,
  _add: _add,
  _insertToAsChildNodeOrSameLevelTree: _insertToAsChildNodeOrSameLevelTree,
  _removeInsertedTree: _removeInsertedTree,
  _getTree: _getTree,
  _buildTree: _buildTree,
  _buildFirstGroupElement: _buildFirstGroupElement,
  _insertElement: _insertElement,
  _mergeGroups: _mergeGroups,
  _mergeGetExecFuncs: _mergeGetExecFuncs,
  _mergeToRootNode: _mergeToRootNode,
  merge: merge
};

function runPipeline(state, pipelineName) {
  return Result$WonderCommonlib.mapSuccess(Tuple2$WonderCommonlib.collectResult(merge(state.allRegisteredWorkPluginData, pipelineName), OptionSt$WonderCommonlib.get(OptionSt$WonderCommonlib.map(SceneGraphRepoManager$WonderCore.getSceneGraphRepo(state), (function (sceneGraphRepo) {
                            return {
                                    sceneGraphRepo: sceneGraphRepo
                                  };
                          })))), (function (param) {
                var match = param[0];
                return parse(state, match[0], param[1], match[1]);
              }));
}

exports.ParsePipelineData = ParsePipelineData;
exports.registerPlugin = registerPlugin;
exports.unregisterPlugin = unregisterPlugin;
exports.init = init;
exports.MergePipelineData = MergePipelineData;
exports.runPipeline = runPipeline;
/* most Not a pure module */