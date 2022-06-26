'use strict';

var ImmutableHashMap$WonderCommonlib = require("wonder-commonlib/lib/js/src/structure/hash_map/ImmutableHashMap.bs.js");

function createState(param) {
  return {
          allRegisteredWorkPluginData: /* [] */0,
          sceneGraphRepo: undefined,
          states: ImmutableHashMap$WonderCommonlib.createEmpty(undefined, undefined)
        };
}

exports.createState = createState;
/* No side effect */
