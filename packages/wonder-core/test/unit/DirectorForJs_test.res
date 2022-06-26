open Wonder_jest

open PipelineType
open Js.Promise

let _ = describe("DirectorForJs", () => {
  open Expect
  open Expect.Operators
  open Sinon

  let sandbox = getSandboxDefaultVal()

  let _buildRegisteredWorkPluginData = (
    ~pluginName="pluginA",
    ~createStateFunc=() => Obj.magic(1),
    ~initFunc=state => (),
    ~getExecFunc=(_, _) => Js.Nullable.null,
    ~allPipelineData=[],
    (),
  ): WorkManagerType.registeredWorkPlugin => {
    pluginName: pluginName,
    createStateFunc: createStateFunc,
    initFunc: initFunc,
    getExecFunc: getExecFunc,
    allPipelineData: allPipelineData,
  }

  let _buildJobOrder = (
    ~insertElementName,
    ~pipelineName="pipeline",
    ~insertAction=RegisterWorkPluginType.After,
    (),
  ): RegisterWorkPluginType.jobOrder => {
    pipelineName: pipelineName,
    insertElementName: insertElementName,
    insertAction: insertAction,
  }

  let _getAllRegisteredWorkPluginData = () => {
    POContainer.unsafeGetState().allRegisteredWorkPluginData
  }

  let _getStates = () => {
    POContainer.unsafeGetState().states
  }

  let _createState1 = (~d1=0, ()) => {
    {
      "d1": d1,
    }->Obj.magic
  }

  let _createState2 = (~d2="aaa", ~dd2=1, ()) => {
    {
      "d2": d2,
      "dd2": dd2,
    }->Obj.magic
  }

  beforeEach(() => {
    sandbox := createSandbox()

    CreatePO.createState()->POContainer.setState
  })
  afterEach(() => restoreSandbox(refJsObjToSandbox(sandbox.contents)))

  describe("unsafeGetSceneGraphRepo", () => {
    test("if not set before, error", () => {
      expect(() => {
        DirectorForJs.unsafeGetSceneGraphRepo()
      })->toThrow
    })
    test("else, get it", () => {
      let repo = Obj.magic(1)

      DirectorForJs.setSceneGraphRepo(repo)

      DirectorForJs.unsafeGetSceneGraphRepo()->expect == repo
    })
  })

  describe("prepare", () => {
    test("create state and set to po container", () => {
      let state = Obj.magic(1)
      POContainer.setState(state)

      DirectorForJs.prepare()

      POContainer.unsafeGetState()->expect !== state
    })
  })

  describe("registerWorkPlugin", () => {
    describe("should add plugin data to state.allRegisteredWorkPluginData", () => {
      test("test register one plugin with no jobOrders", () => {
        let data = _buildRegisteredWorkPluginData()

        DirectorForJs.registerWorkPlugin(~data, ())

        _getAllRegisteredWorkPluginData()->expect == list{(data, [])}
      })
      test("test register two plugins with jobOrders", () => {
        let data1 = _buildRegisteredWorkPluginData(~pluginName="a1", ())
        let data2 = _buildRegisteredWorkPluginData(~pluginName="a2", ())
        let jobOrders2 = [_buildJobOrder(~insertElementName="", ())]

        DirectorForJs.registerWorkPlugin(~data=data1, ())
        DirectorForJs.registerWorkPlugin(~data=data2, ~jobOrders=jobOrders2, ())

        _getAllRegisteredWorkPluginData()->expect == list{(data1, []), (data2, jobOrders2)}
      })
    })
  })

  describe("unregisterWorkPlugin", () => {
    describe("should remove plugin data from state.allRegisteredWorkPluginData", () => {
      test("test register one plugin and unregister it", () => {
        let data = _buildRegisteredWorkPluginData(~pluginName="a", ())

        DirectorForJs.registerWorkPlugin(~data, ())
        DirectorForJs.unregisterWorkPlugin("a")

        _getAllRegisteredWorkPluginData()->expect == list{}
      })
      test("test register two plugins and unregister the first one", () => {
        let data1 = _buildRegisteredWorkPluginData(~pluginName="a1", ())
        let data2 = _buildRegisteredWorkPluginData(~pluginName="a2", ())

        DirectorForJs.registerWorkPlugin(~data=data1, ())
        DirectorForJs.registerWorkPlugin(~data=data2, ())
        DirectorForJs.unregisterWorkPlugin("a1")

        _getAllRegisteredWorkPluginData()->expect == list{(data2, [])}
      })
    })
  })

  describe("init", () => {
    test("invoke all registered plugins' createStateFunc and store to states", () => {
      let state1 = _createState1()
      let data1 = _buildRegisteredWorkPluginData(
        ~pluginName="a1",
        ~createStateFunc=() => state1,
        (),
      )
      let state2 = _createState2()
      let data2 = _buildRegisteredWorkPluginData(
        ~pluginName="a2",
        ~createStateFunc=() => state2,
        (),
      )

      DirectorForJs.registerWorkPlugin(~data=data1, ())
      DirectorForJs.registerWorkPlugin(~data=data2, ())
      DirectorForJs.init()

      let states = _getStates()
      (
        states->WonderCommonlib.ImmutableHashMap.get("a1"),
        states->WonderCommonlib.ImmutableHashMap.get("a2"),
      )->expect == (Some(state1), Some(state2))
    })
    test("invoke all registered plugins' initFunc", () => {
      let state1 = _createState1()
      let stub1 = createEmptyStubWithJsObjSandbox(sandbox)
      let data1 = _buildRegisteredWorkPluginData(
        ~pluginName="a1",
        ~createStateFunc=() => state1,
        ~initFunc=state1 => {
          stub1(state1)
        },
        (),
      )
      let state2 = _createState2()
      let stub2 = createEmptyStubWithJsObjSandbox(sandbox)
      let data2 = _buildRegisteredWorkPluginData(
        ~pluginName="a2",
        ~createStateFunc=() => state2,
        ~initFunc=state2 => {
          stub2()
        },
        (),
      )

      DirectorForJs.registerWorkPlugin(~data=data1, ())
      DirectorForJs.registerWorkPlugin(~data=data2, ())
      DirectorForJs.init()

      let states = _getStates()

      (
        states->WonderCommonlib.ImmutableHashMap.get("a1"),
        states->WonderCommonlib.ImmutableHashMap.get("a2"),
        stub1->getCallCount,
        stub1->SinonTool.calledWith(state1),
        stub2->getCallCount,
      )->expect == (Some(state1), Some(state2), 1, true, 1)
    })
  })

  describe("runPipeline", () => {
    describe("run pipeline's all jobs", () => {
      let _prepareData1 = (
        ~changedState1=_createState1(~d1=10, ()),
        ~rootJob=(states, repo) => {
          states->WonderCommonlib.ImmutableHashMap.set("a1", changedState1)->WonderBsMost.Most.just
        },
        ~state1=_createState1(),
        ~initFunc=state => (),
        (),
      ) => {
        let rootJobName = "root_a1"

        (
          rootJobName,
          _buildRegisteredWorkPluginData(
            ~pluginName="a1",
            ~createStateFunc=() => state1,
            ~initFunc,
            ~allPipelineData=[
              {
                name: "init",
                groups: [
                  {
                    name: "first_a1",
                    link: #concat,
                    elements: [
                      {
                        name: rootJobName,
                        type_: #job,
                      },
                    ],
                  },
                ],
                first_group: "first_a1",
              },
            ],
            ~getExecFunc=(_, jobName) => {
              switch jobName {
              | jobName if EqualTool.isEqual(jobName, rootJobName) => rootJob->Js.Nullable.return
              | _ => Js.Nullable.null
              }
            },
            (),
          ),
          changedState1,
        )
      }

      beforeEach(() => {
        DirectorForJs.setSceneGraphRepo(Obj.magic(1))
      })

      describe("test register one plugin", () => {
        testPromise("test change state without repo", () => {
          let (_, data1, changedState1) = _prepareData1()

          DirectorForJs.registerWorkPlugin(~data=data1, ())
          DirectorForJs.init()
          DirectorForJs.runPipeline("init")->WonderBsMost.Most.drain->then_(() => {
            (_getStates()->WonderCommonlib.ImmutableHashMap.get("a1")->expect ==
              Some(changedState1))->resolve
          }, _)
        })
        testPromise("test change state with repo", () => {
          let repo = {
            "buildNumber": () => 100,
          }->Obj.magic
          DirectorForJs.setSceneGraphRepo(repo)
          let rootJob = (states, {sceneGraphRepo}) => {
            states
            ->WonderCommonlib.ImmutableHashMap.set(
              "a1",
              _createState1(~d1=JsObjTool.invokeObjMethod(sceneGraphRepo, "buildNumber", []), ()),
            )
            ->WonderBsMost.Most.just
          }
          let (_, data1, changedState1) = _prepareData1(~rootJob, ())

          DirectorForJs.registerWorkPlugin(~data=data1, ())
          DirectorForJs.init()
          DirectorForJs.runPipeline("init")->WonderBsMost.Most.drain->then_(() => {
            (_getStates()->WonderCommonlib.ImmutableHashMap.get("a1")->expect ==
              Some(_createState1(~d1=100, ())))->resolve
          }, _)
        })
      })

      describe("test more plugins", () => {
        let _prepareData2 = () => {
          let job1Name_a2 = "job1_a2"
          let state2 = _createState2()
          let job1 = (states, repo) => {
            states
            ->WonderCommonlib.ImmutableHashMap.set("a2", _createState2(~d2="c", ~dd2=100, ()))
            ->WonderBsMost.Most.just
          }
          let job2 = (states, repo) => {
            states
            ->WonderCommonlib.ImmutableHashMap.set(
              "a2",
              _createState2(
                ~d2="d",
                ~dd2=states
                ->WonderCommonlib.ImmutableHashMap.get("a2")
                ->WonderCommonlib.OptionSt.getExn
                ->JsObjTool.getObjValue("dd2"),
                (),
              ),
            )
            ->WonderBsMost.Most.just
          }
          let data2 = _buildRegisteredWorkPluginData(
            ~pluginName="a2",
            ~createStateFunc=() => state2,
            ~allPipelineData=[
              {
                name: "init",
                groups: [
                  {
                    name: "first_a2",
                    link: #concat,
                    elements: [
                      {
                        name: job1Name_a2,
                        type_: #job,
                      },
                      {
                        name: "job2_a2",
                        type_: #job,
                      },
                    ],
                  },
                ],
                first_group: "first_a2",
              },
            ],
            ~getExecFunc=(_, jobName) => {
              switch jobName {
              | jobName if EqualTool.isEqual(jobName, job1Name_a2) => job1->Js.Nullable.return
              | "job2_a2" => job2->Js.Nullable.return
              | _ => Js.Nullable.null
              }
            },
            (),
          )

          (job1Name_a2, data2, _createState2(~d2="d", ~dd2=100, ()))
        }

        describe("test register two plugins", () => {
          testPromise("test plugin has one job", () => {
            let (rootJobName, data1, changedState1) = _prepareData1()
            let state2 = _createState2()
            let changedState2 = _createState2(~d2="c", ())
            let job1 = (states, repo) => {
              states
              ->WonderCommonlib.ImmutableHashMap.set("a2", changedState2)
              ->WonderBsMost.Most.just
            }
            let data2 = _buildRegisteredWorkPluginData(
              ~pluginName="a2",
              ~createStateFunc=() => state2,
              ~allPipelineData=[
                {
                  name: "init",
                  groups: [
                    {
                      name: "first_a2",
                      link: #concat,
                      elements: [
                        {
                          name: "job1_a2",
                          type_: #job,
                        },
                      ],
                    },
                  ],
                  first_group: "first_a2",
                },
              ],
              ~getExecFunc=(_, jobName) => {
                switch jobName {
                | "job1_a2" => job1->Js.Nullable.return
                | _ => Js.Nullable.null
                }
              },
              (),
            )

            DirectorForJs.registerWorkPlugin(~data=data1, ())
            DirectorForJs.registerWorkPlugin(
              ~data=data2,
              ~jobOrders=[
                _buildJobOrder(
                  ~pipelineName="init",
                  ~insertElementName=rootJobName,
                  ~insertAction=RegisterWorkPluginType.After,
                  (),
                ),
              ],
              (),
            )
            DirectorForJs.init()
            DirectorForJs.runPipeline("init")->WonderBsMost.Most.drain->then_(() => {
              let states = _getStates()

              ((
                states->WonderCommonlib.ImmutableHashMap.get("a1"),
                states->WonderCommonlib.ImmutableHashMap.get("a2"),
              )->expect == (Some(changedState1), Some(changedState2)))->resolve
            }, _)
          })
          testPromise("test plugin has two jobs", () => {
            let (rootJobName, data1, changedState1) = _prepareData1()
            let (job1Name_a2, data2, changedState2) = _prepareData2()

            DirectorForJs.registerWorkPlugin(~data=data1, ())
            DirectorForJs.registerWorkPlugin(
              ~data=data2,
              ~jobOrders=[
                _buildJobOrder(
                  ~pipelineName="init",
                  ~insertElementName=rootJobName,
                  ~insertAction=RegisterWorkPluginType.After,
                  (),
                ),
              ],
              (),
            )
            DirectorForJs.init()
            DirectorForJs.runPipeline("init")->WonderBsMost.Most.drain->then_(() => {
              let states = _getStates()

              ((
                states->WonderCommonlib.ImmutableHashMap.get("a1"),
                states->WonderCommonlib.ImmutableHashMap.get("a2"),
              )->expect == (Some(changedState1), Some(changedState2)))->resolve
            }, _)
          })
        })

        describe("test register three plugins", () => {
          let _createState3 = (~d3=222, ()) => {
            {
              "d3": d3,
            }->Obj.magic
          }

          let _prepare = () => {
            let (rootJobName, data1, changedState1) = _prepareData1()
            let (job1Name_a2, data2, changedState2) = _prepareData2()
            let state3 = _createState3()
            let changedState3 = _createState3(~d3=2, ())
            let job1 = (states, repo) => {
              states
              ->WonderCommonlib.ImmutableHashMap.set("a3", changedState3)
              ->WonderBsMost.Most.just
            }
            let data3 = _buildRegisteredWorkPluginData(
              ~pluginName="a3",
              ~createStateFunc=() => state3,
              ~allPipelineData=[
                {
                  name: "init",
                  groups: [
                    {
                      name: "first_a3",
                      link: #concat,
                      elements: [
                        {
                          name: "job1_a3",
                          type_: #job,
                        },
                      ],
                    },
                  ],
                  first_group: "first_a3",
                },
              ],
              ~getExecFunc=(_, jobName) => {
                switch jobName {
                | "job1_a3" => job1->Js.Nullable.return
                | _ => Js.Nullable.null
                }
              },
              (),
            )

            (
              (rootJobName, data1, changedState1),
              (job1Name_a2, data2, changedState2),
              (data3, changedState3),
            )
          }

          testPromise("test1", () => {
            let (
              (rootJobName, data1, changedState1),
              (job1Name_a2, data2, changedState2),
              (data3, changedState3),
            ) = _prepare()

            DirectorForJs.registerWorkPlugin(
              ~data=data3,
              ~jobOrders=[
                _buildJobOrder(
                  ~pipelineName="init",
                  ~insertElementName=job1Name_a2,
                  ~insertAction=RegisterWorkPluginType.Before,
                  (),
                ),
              ],
              (),
            )
            DirectorForJs.registerWorkPlugin(~data=data1, ())
            DirectorForJs.registerWorkPlugin(
              ~data=data2,
              ~jobOrders=[
                _buildJobOrder(
                  ~pipelineName="init",
                  ~insertElementName=rootJobName,
                  ~insertAction=RegisterWorkPluginType.After,
                  (),
                ),
              ],
              (),
            )
            DirectorForJs.init()
            DirectorForJs.runPipeline("init")->WonderBsMost.Most.drain->then_(() => {
              let states = _getStates()

              ((
                states->WonderCommonlib.ImmutableHashMap.get("a1"),
                states->WonderCommonlib.ImmutableHashMap.get("a2"),
                states->WonderCommonlib.ImmutableHashMap.get("a3"),
              )->expect == (Some(changedState1), Some(changedState2), Some(changedState3)))->resolve
            }, _)
          })
          testPromise("test2", () => {
            let (
              (rootJobName, data1, changedState1),
              (job1Name_a2, data2, changedState2),
              (data3, changedState3),
            ) = _prepare()

            DirectorForJs.registerWorkPlugin(
              ~data=data3,
              ~jobOrders=[
                _buildJobOrder(
                  ~pipelineName="init",
                  ~insertElementName=rootJobName,
                  ~insertAction=RegisterWorkPluginType.Before,
                  (),
                ),
              ],
              (),
            )
            DirectorForJs.registerWorkPlugin(
              ~data=data2,
              ~jobOrders=[
                _buildJobOrder(
                  ~pipelineName="init",
                  ~insertElementName=rootJobName,
                  ~insertAction=RegisterWorkPluginType.After,
                  (),
                ),
              ],
              (),
            )
            DirectorForJs.registerWorkPlugin(~data=data1, ())
            DirectorForJs.init()
            DirectorForJs.runPipeline("init")->WonderBsMost.Most.drain->then_(() => {
              let states = _getStates()

              ((
                states->WonderCommonlib.ImmutableHashMap.get("a1"),
                states->WonderCommonlib.ImmutableHashMap.get("a2"),
                states->WonderCommonlib.ImmutableHashMap.get("a3"),
              )->expect == (Some(changedState1), Some(changedState2), Some(changedState3)))->resolve
            }, _)
          })
        })

        describe("test register four plugins", () => {
          let _createState3 = (~d3=222, ()) => {
            {
              "d3": d3,
            }->Obj.magic
          }

          let _createState4 = (~d4=56, ()) => {
            {
              "d4": d4,
            }->Obj.magic
          }

          testPromise("test1", () => {
            let (rootJobName, data1, changedState1) = _prepareData1()
            let (job1Name_a2, data2, changedState2) = _prepareData2()
            let state3 = _createState3()
            let stubJob1_3 = createEmptyStubWithJsObjSandbox(sandbox)
            let changedState3 = _createState3(~d3=2, ())
            let job1 = (states, repo) => {
              stubJob1_3()
              states
              ->WonderCommonlib.ImmutableHashMap.set("a3", changedState3)
              ->WonderBsMost.Most.just
            }
            let data3 = _buildRegisteredWorkPluginData(
              ~pluginName="a3",
              ~createStateFunc=() => state3,
              ~allPipelineData=[
                {
                  name: "init",
                  groups: [
                    {
                      name: "first_a3",
                      link: #concat,
                      elements: [
                        {
                          name: "job1_a3",
                          type_: #job,
                        },
                      ],
                    },
                  ],
                  first_group: "first_a3",
                },
              ],
              ~getExecFunc=(_, jobName) => {
                switch jobName {
                | "job1_a3" => job1->Js.Nullable.return
                | _ => Js.Nullable.null
                }
              },
              (),
            )
            let state4 = _createState4()
            let stubJob2_4 = createEmptyStubWithJsObjSandbox(sandbox)
            let changedState4 = _createState4(~d4=5, ())
            let job1 = (states, repo) => {
              states
              ->WonderCommonlib.ImmutableHashMap.set("a4", changedState4)
              ->WonderBsMost.Most.just
            }
            let job2 = (states, repo) => {
              stubJob2_4()
              states->WonderBsMost.Most.just
            }
            let data4 = _buildRegisteredWorkPluginData(
              ~pluginName="a4",
              ~createStateFunc=() => state4,
              ~allPipelineData=[
                {
                  name: "init",
                  groups: [
                    {
                      name: "first_a4",
                      link: #concat,
                      elements: [
                        {
                          name: "group1_a4",
                          type_: #group,
                        },
                        {
                          name: "job1_a4",
                          type_: #job,
                        },
                      ],
                    },
                    {
                      name: "group1_a4",
                      link: #concat,
                      elements: [
                        {
                          name: "job2_a4",
                          type_: #job,
                        },
                      ],
                    },
                  ],
                  first_group: "first_a4",
                },
              ],
              ~getExecFunc=(_, jobName) => {
                switch jobName {
                | "job1_a4" => job1->Js.Nullable.return
                | "job2_a4" => job2->Js.Nullable.return
                | _ => Js.Nullable.null
                }
              },
              (),
            )

            DirectorForJs.registerWorkPlugin(
              ~data=data3,
              ~jobOrders=[
                _buildJobOrder(
                  ~pipelineName="init",
                  ~insertElementName=job1Name_a2,
                  ~insertAction=RegisterWorkPluginType.Before,
                  (),
                ),
              ],
              (),
            )
            DirectorForJs.registerWorkPlugin(~data=data1, ())
            DirectorForJs.registerWorkPlugin(
              ~data=data4,
              ~jobOrders=[
                _buildJobOrder(
                  ~pipelineName="init",
                  ~insertElementName=job1Name_a2,
                  ~insertAction=RegisterWorkPluginType.Before,
                  (),
                ),
              ],
              (),
            )
            DirectorForJs.registerWorkPlugin(
              ~data=data2,
              ~jobOrders=[
                _buildJobOrder(
                  ~pipelineName="init",
                  ~insertElementName=rootJobName,
                  ~insertAction=RegisterWorkPluginType.After,
                  (),
                ),
              ],
              (),
            )
            DirectorForJs.init()
            DirectorForJs.runPipeline("init")->WonderBsMost.Most.drain->then_(() => {
              let states = _getStates()

              ((
                states->WonderCommonlib.ImmutableHashMap.get("a1"),
                states->WonderCommonlib.ImmutableHashMap.get("a2"),
                states->WonderCommonlib.ImmutableHashMap.get("a3"),
                states->WonderCommonlib.ImmutableHashMap.get("a4"),
                stubJob1_3->getCallCount,
                stubJob2_4->getCallCount,
                stubJob2_4->calledAfter(stubJob1_3),
              )->expect ==
                (
                  Some(changedState1),
                  Some(changedState2),
                  Some(changedState3),
                  Some(changedState4),
                  1,
                  1,
                  true,
                ))->resolve
            }, _)
          })
        })
      })

      describe("test register plugins in initFunc", () => {
        describe("test register two plugins", () => {
          testPromise("test plugin has one job", () => {
            let state2 = _createState2()
            let changedState2 = _createState2(~d2="c", ())
            let job1 = (states, repo) => {
              states
              ->WonderCommonlib.ImmutableHashMap.set("a2", changedState2)
              ->WonderBsMost.Most.just
            }
            let data2 = _buildRegisteredWorkPluginData(
              ~pluginName="a2",
              ~createStateFunc=() => state2,
              ~allPipelineData=[
                {
                  name: "init",
                  groups: [
                    {
                      name: "first_a2",
                      link: #concat,
                      elements: [
                        {
                          name: "job1_a2",
                          type_: #job,
                        },
                      ],
                    },
                  ],
                  first_group: "first_a2",
                },
              ],
              ~getExecFunc=(_, jobName) => {
                switch jobName {
                | "job1_a2" => job1->Js.Nullable.return
                | _ => Js.Nullable.null
                }
              },
              (),
            )
            let (rootJobName, data1, changedState1) = _prepareData1(~initFunc=state => {
              let rootJobName = "root_a1"

              DirectorForJs.registerWorkPlugin(
                ~data=data2,
                ~jobOrders=[
                  _buildJobOrder(
                    ~pipelineName="init",
                    ~insertElementName=rootJobName,
                    ~insertAction=RegisterWorkPluginType.After,
                    (),
                  ),
                ],
                (),
              )

              ()
            }, ())

            DirectorForJs.registerWorkPlugin(~data=data1, ())
            DirectorForJs.init()
            DirectorForJs.runPipeline("init")->WonderBsMost.Most.drain->then_(() => {
              let states = _getStates()

              ((
                states->WonderCommonlib.ImmutableHashMap.get("a1"),
                states->WonderCommonlib.ImmutableHashMap.get("a2"),
              )->expect == (Some(changedState1), Some(changedState2)))->resolve
            }, _)
          })
        })
      })

      describe("test sepecial case", () => {
        describe("test has init and update pipeline", () => {
          testPromise("aaa", () => {
            let stub1 = createEmptyStubWithJsObjSandbox(sandbox)
            let stub2 = createEmptyStubWithJsObjSandbox(sandbox)
            let rootJob1_init = (states, _) => {
              stub1()

              states->WonderBsMost.Most.just
            }
            let rootJob1_update = (states, _) => {
              stub2()

              states->WonderBsMost.Most.just
            }
            let data1 = _buildRegisteredWorkPluginData(
              ~pluginName="a1",
              ~allPipelineData=[
                {
                  name: "init",
                  groups: [
                    {
                      name: "first_a1",
                      link: #concat,
                      elements: [
                        {
                          name: "root_init_a1",
                          type_: #job,
                        },
                      ],
                    },
                  ],
                  first_group: "first_a1",
                },
                {
                  name: "update",
                  groups: [
                    {
                      name: "first_a1",
                      link: #concat,
                      elements: [
                        {
                          name: "root_update_a1",
                          type_: #job,
                        },
                      ],
                    },
                  ],
                  first_group: "first_a1",
                },
              ],
              ~getExecFunc=(_, jobName) => {
                switch jobName {
                | "root_init_a1" => rootJob1_init->Js.Nullable.return
                | "root_update_a1" => rootJob1_update->Js.Nullable.return
                | _ => Js.Nullable.null
                }
              },
              (),
            )

            DirectorForJs.registerWorkPlugin(~data=data1, ())
            DirectorForJs.init()
            DirectorForJs.runPipeline("update")->WonderBsMost.Most.drain->then_(() => {
              ((stub1->getCallCount, stub2->getCallCount)->expect == (0, 1))->resolve
            }, _)
          })
        })

        testPromise("if first_group not in groups, error", () => {
          let data1 = _buildRegisteredWorkPluginData(
            ~pluginName="a1",
            ~allPipelineData=[
              {
                name: "init",
                groups: [
                  {
                    name: "first_a1",
                    link: #concat,
                    elements: [
                      {
                        name: "root_init_a1",
                        type_: #job,
                      },
                    ],
                  },
                ],
                first_group: "aaa",
              },
            ],
            ~getExecFunc=(_, jobName) => {
              Js.Nullable.null
            },
            (),
          )

          DirectorForJs.registerWorkPlugin(~data=data1, ())
          DirectorForJs.init()

          expect(() => {
            DirectorForJs.runPipeline("init")
          })
          ->toThrowMessage("not in groups", _)
          ->resolve
        })
      })
    })
  })
})
