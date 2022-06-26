'use strict';

var OptionSt$WonderCommonlib = require("wonder-commonlib/lib/js/src/structure/OptionSt.bs.js");

function _createPOContainer(param) {
  return {
          po: undefined
        };
}

var poContainer = {
  po: undefined
};

function setState(state) {
  poContainer.po = state;
  
}

function unsafeGetState(param) {
  return OptionSt$WonderCommonlib.getExn(poContainer.po);
}

exports._createPOContainer = _createPOContainer;
exports.poContainer = poContainer;
exports.setState = setState;
exports.unsafeGetState = unsafeGetState;
/* No side effect */
