'use strict';

<<<<<<< HEAD
var Belt_List = require("rescript/lib/js/belt_List.js");
=======
var ListSt$WonderCommonlib = require("../structure/ListSt.bs.js");
>>>>>>> 3fe27b0fb1e47f3ed2b3f28029190c71ef49a9dc

function printForDebug(value) {
  console.log(JSON.stringify(value));
  return value;
}

function printListForDebug(list) {
<<<<<<< HEAD
  console.log(Belt_List.toArray(list));
=======
  console.log(ListSt$WonderCommonlib.toArray(list));
>>>>>>> 3fe27b0fb1e47f3ed2b3f28029190c71ef49a9dc
  return list;
}

function logForDebug(value) {
  console.log(value);
  console.trace();
  
}

function log(value) {
  console.log(JSON.stringify(value));
  
}

function getJsonStr(json) {
  return JSON.stringify(json);
}

function buildDebugMessage(description, params, param) {
  return "\n  Debug:\n\n  description\n  " + description + "\n\n  params\n  " + params + "\n\n  ";
}

function buildDebugJsonMessage(description, $$var, param) {
  var varStr = JSON.stringify($$var);
  return "\n  DebugJson:\n\n  description\n  " + description + "\n\n  variable value\n  " + varStr + "\n  ";
}

function buildFatalMessage(title, description, reason, solution, params) {
  return "\n  Fatal:\n\n  title\n  " + title + "\n\n  description\n  " + description + "\n\n  reason\n  " + reason + "\n\n  solution\n  " + solution + "\n\n  params\n  " + params + "\n\n   ";
}

function buildErrorMessage(title, description, reason, solution, params) {
  return "\n  Error:\n\n  title\n  " + title + "\n\n  description\n  " + description + "\n\n  reason\n  " + reason + "\n\n  solution\n  " + solution + "\n\n  params\n  " + params + "\n\n   ";
}

function buildAssertMessage(expect, actual) {
  return "expect " + expect + ", but actual " + actual;
}

exports.printForDebug = printForDebug;
exports.printListForDebug = printListForDebug;
exports.logForDebug = logForDebug;
exports.log = log;
exports.getJsonStr = getJsonStr;
exports.buildDebugMessage = buildDebugMessage;
exports.buildDebugJsonMessage = buildDebugJsonMessage;
exports.buildFatalMessage = buildFatalMessage;
exports.buildErrorMessage = buildErrorMessage;
exports.buildAssertMessage = buildAssertMessage;
/* No side effect */