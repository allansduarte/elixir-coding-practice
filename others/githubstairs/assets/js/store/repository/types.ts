export interface Tag {
    id: number;
    name: string;
}

export interface Repository {
    id: number;
    github_repository_id: number;
    name: string;
    description: string;
    url: string;
    language: string | null;
    tags: Tag[]
}

export enum RepositoryActionTypes {
    FETCH_REQUEST = "@@repository/FETCH_REQUEST",
    FETCH_SUCCESS = "@@repository/FETCH_SUCCESS",
    FETCH_SEARCH_SUCCESS = "@@repository/FETCH_SEARCH_SUCCESS",
    FETCH_ERROR = "@@repository/FETCH_ERROR"
}

export interface RepositoryState {
    readonly loading: boolean;
    readonly data: Repository[];
    readonly errors?: string;
}