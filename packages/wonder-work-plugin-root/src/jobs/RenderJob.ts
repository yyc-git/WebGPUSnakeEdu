import { execFunc } from "../Type"
import { callFunc } from "wonder-facade/src/MostAPI"

export let exec: execFunc = (states) => {
    return callFunc(() => {
        console.log("render root job exec")

        return states
    })
}

