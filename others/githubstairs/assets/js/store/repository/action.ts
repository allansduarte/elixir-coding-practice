import { ActionCreator, Action, Dispatch } from "redux";
import { ThunkAction } from "redux-thunk";
import axios from "axios";

import { ApplicationState } from "../index";
import { RepositoryActionTypes } from "./types";

export type AppThunk = ActionCreator<
    ThunkAction<void, ApplicationState, null, Action<string>>
>;

const fetchRepositoryFromGithubStart = () => {
    return {
        type: RepositoryActionTypes.FETCH_REQUEST,
        payload: {}
    }
}

const fetchRepositoryFromGithubSuccess = (data: any) => {
    return {
        type: RepositoryActionTypes.FETCH_SUCCESS,
        payload: data
    }
}

export const fetchRepositorySearchSuccess = (data: any) => {
    return {
        type: RepositoryActionTypes.FETCH_SEARCH_SUCCESS,
        payload: data
    }
}

const fetchRepositoryFromGithubFail = (error: any) => {
    return {
        type: RepositoryActionTypes.FETCH_ERROR,
        payload: error
    }
}

export const manageTags = (id: number, tags: string) => {
    return (dispatch: Dispatch) => {
        axios.put(`/api/repositories/${id}`, {
            repository: {
                tags: tags
            }
        })
            .then((response) => {
                dispatch(fetchRepositoryFromGithubSuccess([response.data.data]))
            })
            .catch((error) => {
                dispatch(fetchRepositoryFromGithubFail(error.message));
            });
    }
}

const addRepos = (data: any) => {
    return (dispatch: Dispatch) => {
        axios.post("/api/repositories", {
            repositories: data
        })
            .then((response) => {
                dispatch(fetchRepositoryFromGithubSuccess(response.data.data))
            })
            .catch((error) => {
                dispatch(fetchRepositoryFromGithubFail(error.message));
            });
    }
}

export const fetchRepositoryFromGithub: AppThunk = (userNameQuery) => {
    return (dispatch: any) => {
        dispatch(fetchRepositoryFromGithubStart())
        axios.get(`https://api.github.com/users/${userNameQuery}/starred`)
            .then((response) => {
                let data = response.data.map((repository: any) => {
                    return {
                        github_repository_id: repository.id,
                        name: repository.name,
                        description: repository.description,
                        url: repository.url,
                        language: repository.language
                    }
                });
                dispatch(addRepos(data));
            })
            .catch(error => {
                dispatch(fetchRepositoryFromGithubFail(error))
            });
    };
};

export const fetchRepositories: AppThunk = () => {
    return (dispatch: any) => {
        dispatch(fetchRepositoryFromGithubStart())
        fetch('/api/repositories')
            .then((response) => {
                if (response.ok) {
                    return response.json();
                } else {
                    dispatch(fetchRepositoryFromGithubFail(response.statusText))
                    throw response;
                }
            })
            .then(repositories => {
                dispatch(fetchRepositoryFromGithubSuccess(repositories.data))
            }).catch(error => {
                dispatch(fetchRepositoryFromGithubFail(error))
            });
    };
};