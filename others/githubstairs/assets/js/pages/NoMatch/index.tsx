import React, { useState } from 'react';
import { RouteComponentProps } from 'react-router-dom';

import { makeStyles, Theme } from '@material-ui/core/styles';
import Button from '@material-ui/core/Button';
import Container from '@material-ui/core/Container';
import Card from '@material-ui/core/Card';
import CardHeader from '@material-ui/core/CardHeader';
import CardActions from '@material-ui/core/CardActions';

const useStyles = makeStyles((theme: Theme) => ({
    container: {
        height: '100%',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center'
    }
}));

const NoMatchPage: React.FC<RouteComponentProps> = ({
    history
}) => {
    const classes = useStyles();

    return (
        <Container className={classes.container}>
            <Card>
                <CardHeader
                    title="Page not found :("
                    subheader="Maybe the page you are looking for has been removed, or you typed in the wrong URL"
                />
                <CardActions>
                    <Button size="small" color="primary" onClick={() => { history.goBack() }}>
                        go back
                    </Button>
                    <Button size="small" color="primary" onClick={() => { history.push("/") }}>
                        go to home page
                    </Button>
                </CardActions>
            </Card>
        </Container>
    )
}

export default NoMatchPage;