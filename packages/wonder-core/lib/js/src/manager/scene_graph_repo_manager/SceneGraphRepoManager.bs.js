'use strict';


function getSceneGraphRepo(state) {
  return state.sceneGraphRepo;
}

function setSceneGraphRepo(state, repo) {
  return {
          allRegisteredWorkPluginData: state.allRegisteredWorkPluginData,
          sceneGraphRepo: repo,
          states: state.states
        };
}

exports.getSceneGraphRepo = getSceneGraphRepo;
exports.setSceneGraphRepo = setSceneGraphRepo;
/* No side effect */
