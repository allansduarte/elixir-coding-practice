import React, { useState, useEffect } from 'react';
import { RouteComponentProps } from 'react-router-dom';
import { useDispatch, useSelector } from "react-redux";

import { makeStyles, Theme } from '@material-ui/core/styles';
import Container from '@material-ui/core/Container';
import Alert from '@material-ui/lab/Alert';

import UserSearch from '../../components/UserSearch';

import { fetchRepositoryFromGithub } from "../../store/repository/action";
import { ApplicationState } from '../../store';
import { RepositoryState } from '../../store/repository/types';

const useStyles = makeStyles((theme: Theme) => ({
    container: {
        height: '100%',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        flexDirection: 'column'
    },
    alert: {
        width: "100%",
        marginBottom: theme.spacing(2)
    }
}));

const HomePage: React.FC<RouteComponentProps> = ({
    history
}) => {
    const dispatch = useDispatch();
    const classes = useStyles();
    const repositoryState = useSelector<ApplicationState, RepositoryState>((state: ApplicationState) => state.repository);
    const [userNameQuery, setUserQueryName] = useState("");

    useEffect(() => {
        if (repositoryState.data.length && userNameQuery && !repositoryState.errors) {
            setUserQueryName("");
            history.push("/repositories");
        }
    }, [repositoryState.data])

    const changeHandler = ({ target }: any) => {
        setUserQueryName(target.value);
    }

    const clickHandler = () => {
        if (userNameQuery) {
            dispatch(fetchRepositoryFromGithub(userNameQuery));
        }
    }

    return (
        <Container maxWidth="xl" className={classes.container}>
            {repositoryState.errors && <Alert className={classes.alert} variant="filled" severity="error">{repositoryState.errors}</Alert>}
            {repositoryState.loading ? <div>Loading...</div> : <UserSearch changed={changeHandler} clicked={clickHandler} value={userNameQuery} />}
        </Container>
    )
}

export default HomePage;