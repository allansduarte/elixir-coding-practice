import { combineReducers } from "redux";
import { connectRouter, RouterState } from "connected-react-router";

import { History } from "history";

import { RepositoryReducer } from "./repository/reducer";
import { RepositoryState } from "./repository/types";

export interface ApplicationState {
    repository: RepositoryState;
    router: RouterState;
}

export const createRootReducer = (history: History) =>
    combineReducers({
        repository: RepositoryReducer,
        router: connectRouter(history)
    });