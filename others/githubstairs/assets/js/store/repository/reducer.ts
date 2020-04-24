import { Reducer } from "redux";
import { RepositoryActionTypes, RepositoryState } from "./types";
import unionBy from 'lodash/unionBy';

export const initialState: RepositoryState = {
    data: [],
    errors: undefined,
    loading: false
};
const reducer: Reducer<RepositoryState> = (state = initialState, action) => {
    switch (action.type) {
        case RepositoryActionTypes.FETCH_REQUEST: {
            return { ...state, loading: true, errors: undefined };
        }
        case RepositoryActionTypes.FETCH_SEARCH_SUCCESS: {
            return {
                ...state, loading: false, data: action.payload, errors: undefined
            };
        }
        case RepositoryActionTypes.FETCH_SUCCESS: {
            const newData = unionBy(action.payload, state.data, "id");

            return {
                ...state, loading: false, data: newData, errors: undefined
            };
        }
        case RepositoryActionTypes.FETCH_ERROR: {
            return { ...state, loading: false, errors: action.payload };
        }
        default: {
            return state;
        }
    }
};
export { reducer as RepositoryReducer };