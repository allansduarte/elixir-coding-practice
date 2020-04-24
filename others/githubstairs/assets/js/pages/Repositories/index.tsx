import React, { useEffect, useState } from 'react';
import { RouteComponentProps } from 'react-router-dom';
import { useDispatch } from "react-redux";
import { Channel } from "phoenix";

import Container from '@material-ui/core/Container';

import SearchField from '../../components/SearchField';
import RepositoryList from '../../components/RepositoryList';
import socket from "../../socket";

import { fetchRepositories, fetchRepositorySearchSuccess } from "../../store/repository/action";

const RepositoriesListPage: React.FC<RouteComponentProps> = () => {
    const dispatch = useDispatch();
    const [searchTerm, setSearchTerm] = useState<string>("");
    const [channel, setChannel] = useState<Channel>()

    useEffect(() => {
        dispatch(fetchRepositories())
        socket.connect()
        setChannel(socket.channel("search:repository"))
    }, []);

    useEffect(() => {
        channel?.join()
            .receive("ok", (response) => {
                console.log("Joined successfully", response)
                channel.on("new_search", (response) => {
                    console.log("Feedback search", response.repositories.data)
                    dispatch(fetchRepositorySearchSuccess(response.repositories.data))
                })
            })
            .receive("error", reason => console.log("join failed", reason))
    }, [channel])

    useEffect(() => {
        channel?.push("new_search", { query: searchTerm })
            .receive("error", e => console.log(e))
    }, [searchTerm])

    const handleSearchTerm = ({ target }: any) => {
        setSearchTerm(target.value);
    }

    return (
        <Container>
            <SearchField value={searchTerm} changed={handleSearchTerm}></SearchField>
            <RepositoryList />
        </Container>
    )
}

export default RepositoriesListPage;