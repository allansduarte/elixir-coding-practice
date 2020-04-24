import React from 'react';

import { makeStyles, Theme } from '@material-ui/core/styles';
import Button from '@material-ui/core/Button';
import TextField from '@material-ui/core/TextField';

interface Props {
    changed: any;
    clicked: any;
    value: string;
}

const useStyles = makeStyles((theme: Theme) => ({
    form: {
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        flexWrap: "wrap"
    },
    textField: {
        width: '250px'
    },
    label: {
        paddingRight: theme.spacing(1)
    },
    button: {
        width: "100%",
        marginTop: theme.spacing(2),
    }
}));

const UserSearch: React.FC<Props> = (props: Props) => {
    const classes = useStyles();

    return (
        <>
            <form noValidate autoComplete="off" className={classes.form}>
                <label className={classes.label}>https://github.com/</label>
                <TextField
                    placeholder="Enter a github username"
                    variant="outlined"
                    onChange={props.changed}
                    className={classes.textField}
                />
                <Button
                    className={classes.button}
                    variant="contained"
                    color="primary"
                    size="large"
                    onClick={props.clicked}
                >Get repositories</Button>
            </form>
            <h4><i>{props.value}</i></h4>
        </>
    )
}

export default UserSearch;