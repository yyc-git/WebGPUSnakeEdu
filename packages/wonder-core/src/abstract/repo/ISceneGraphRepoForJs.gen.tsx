/* TypeScript file generated from ISceneGraphRepoForJs.res by genType. */
/* eslint-disable import/first */


import type {Typed_array_Float32Array_t as Js_Typed_array_Float32Array_t} from '../../../src/shims/Js.shim';

// tslint:disable-next-line:max-classes-per-file 
// tslint:disable-next-line:class-name
export abstract class gameObject { protected opaque!: any }; /* simulate opaque types */

// tslint:disable-next-line:max-classes-per-file 
// tslint:disable-next-line:class-name
export abstract class scene { protected opaque!: any }; /* simulate opaque types */

// tslint:disable-next-line:max-classes-per-file 
// tslint:disable-next-line:class-name
export abstract class transform { protected opaque!: any }; /* simulate opaque types */

// tslint:disable-next-line:max-classes-per-file 
// tslint:disable-next-line:class-name
export abstract class context { protected opaque!: any }; /* simulate opaque types */

// tslint:disable-next-line:interface-over-type-literal
export type canvas = {
  readonly width: number; 
  readonly height: number; 
  readonly getContext: (_1:string) => context
};

// tslint:disable-next-line:interface-over-type-literal
export type configRepo = {
  readonly getIsDebug: () => boolean; 
  readonly setIsDebug: (_1:boolean) => void; 
  readonly getTransformCount: () => number; 
  readonly setTransformCount: (_1:number) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type position = [number, number, number];

// tslint:disable-next-line:interface-over-type-literal
export type rotation = [number, number, number, number];

// tslint:disable-next-line:interface-over-type-literal
export type scale = [number, number, number];

// tslint:disable-next-line:interface-over-type-literal
export type localToWorldMatrix = Js_Typed_array_Float32Array_t;

// tslint:disable-next-line:interface-over-type-literal
export type normalMatrix = Js_Typed_array_Float32Array_t;

// tslint:disable-next-line:interface-over-type-literal
export type eulerAngles = [number, number, number];

// tslint:disable-next-line:interface-over-type-literal
export type transformRepo = {
  readonly getIndex: (_1:transform) => number; 
  readonly toComponent: (_1:number) => transform; 
  readonly create: () => transform; 
  readonly getGameObject: (_1:transform) => (null | undefined | gameObject); 
  readonly getParent: (_1:transform) => (null | undefined | transform); 
  readonly hasParent: (_1:transform) => boolean; 
  readonly removeParent: (_1:transform) => void; 
  readonly getChildren: (_1:transform) => (null | undefined | transform[]); 
  readonly getLocalPosition: (_1:transform) => position; 
  readonly setLocalPosition: (_1:transform, _2:position) => void; 
  readonly getPosition: (_1:transform) => position; 
  readonly setPosition: (_1:transform, _2:position) => void; 
  readonly getLocalRotation: (_1:transform) => rotation; 
  readonly setLocalRotation: (_1:transform, _2:rotation) => void; 
  readonly getRotation: (_1:transform) => rotation; 
  readonly setRotation: (_1:transform, _2:rotation) => void; 
  readonly getLocalScale: (_1:transform) => scale; 
  readonly setLocalScale: (_1:transform, _2:scale) => void; 
  readonly getScale: (_1:transform) => scale; 
  readonly setScale: (_1:transform, _2:scale) => void; 
  readonly getLocalEulerAngles: (_1:transform) => eulerAngles; 
  readonly setLocalEulerAngles: (_1:transform, _2:eulerAngles) => void; 
  readonly getEulerAngles: (_1:transform) => eulerAngles; 
  readonly setEulerAngles: (_1:transform, _2:eulerAngles) => void; 
  readonly getLocalToWorldMatrix: (_1:transform) => localToWorldMatrix; 
  readonly getNormalMatrix: (_1:transform) => normalMatrix; 
  readonly getAllTransforms: () => transform[]; 
  readonly updateTransform: (_1:transform) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type gameObjectRepo = {
  readonly create: () => gameObject; 
  readonly getTransform: (_1:gameObject) => (null | undefined | transform); 
  readonly addTransform: (_1:gameObject, _2:transform) => gameObject; 
  readonly hasTransform: (_1:gameObject) => boolean
};

// tslint:disable-next-line:interface-over-type-literal
export type sceneRepo = {
  readonly create: () => scene; 
  readonly add: (_1:scene, _2:gameObject) => void; 
  readonly getScene: () => (null | undefined | scene); 
  readonly setScene: (_1:scene) => void; 
  readonly getAllGameObjects: (_1:scene) => gameObject[]
};

// tslint:disable-next-line:interface-over-type-literal
export type componentCountData = { readonly transformCount: number };

// tslint:disable-next-line:interface-over-type-literal
export type globalTempData = { readonly float9Array1: Js_Typed_array_Float32Array_t; readonly float32Array1: Js_Typed_array_Float32Array_t };

// tslint:disable-next-line:interface-over-type-literal
export type sceneGraphRepo = {
  readonly configRepo: configRepo; 
  readonly sceneRepo: sceneRepo; 
  readonly gameObjectRepo: gameObjectRepo; 
  readonly transformRepo: transformRepo; 
  readonly getCanvas: () => (null | undefined | canvas); 
  readonly setCanvas: (_1:canvas) => void; 
  readonly setIsDebug: (_1:boolean) => void; 
  readonly setComponentCount: (_1:componentCountData) => void; 
  readonly setGlobalTempData: (_1:globalTempData) => void; 
  readonly createAndSetAllComponentPOs: () => void
};
